using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Drawing.Imaging;

using Tesseract;

namespace SonSer
{
    public partial class SonSer : Form
    {        
        public SonSer()
        {           
            InitializeComponent();
        }

        [DllImport("User32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool ShowWindow(IntPtr hWnd, ShowWindowCommands nCmdShow);

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        static extern bool SetCursorPos(int x, int y);

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        public static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);
        
        public const int MOUSEEVENTF_LEFTDOWN = 0x02;
        public const int MOUSEEVENTF_LEFTUP = 0x04;

        private Process FocusSpotify(bool r = false)
        {
            Process[] processlist = Process.GetProcesses();
            Process rp = null;
            foreach (Process p in processlist)
            {
                String name = p.MainWindowTitle;
                if (name == "Spotify")
                {
                    rp = p;
                    break;
                }
            }

            SetForegroundWindow(rp.MainWindowHandle);
            ShowWindow(rp.MainWindowHandle, ShowWindowCommands.ShowMaximized);

            if(r)
                return rp;
            else
                return null;           
        }

        private void ClickSpotify(int xpos, int ypos)
        {
            SetCursorPos(xpos, ypos);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
        }
        private void ClickDoubleSpotify(int xpos, int ypos)
        {
            SetCursorPos(xpos, ypos);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
        }

        private void ClickDoubleDelaySpotify(int xpos, int ypos)
        {
            SetCursorPos(xpos, ypos);
            System.Threading.Thread.Sleep(500);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
        }

        private void ClickDelaySpotify(int xpos, int ypos)
        {
            SetCursorPos(xpos, ypos);
            System.Threading.Thread.Sleep(500);
            mouse_event(MOUSEEVENTF_LEFTDOWN, xpos, ypos, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, xpos, ypos, 0, 0);
        }

        public void PausePlaySpotify()
        {
            ClickDelaySpotify(75, 1000);
        }

        private void ClickClearSearchSpotify()
        {
            ClickDelaySpotify(315, 70);
        }
        
        private void SelectSearchbarSpotify()
        {
            ClickDelaySpotify(125, 75);
        }

        private void SelectAllResults()
        {
            System.Threading.Thread.Sleep(500);
            ClickSpotify(125, 125);
        }

        private void PlayFromResultsScreen()
        {
            System.Threading.Thread.Sleep(1000);
            ClickDelaySpotify(300, 200);
        }

        private void PlayFromResultsLowerScreen()
        {
            System.Threading.Thread.Sleep(1000);
            ClickDelaySpotify(300, 450);
        }

        private void PressEnterSpotify()
        {
            SendKeys.Send("{ENTER}");
        }

        private void TypeSpotify(string p)
        {
            char[] keys = p.ToArray<char>();

            foreach (char key in keys)
            {
                SendKeys.Send(key.ToString());
            }
        }

        public String SeeifAlbumsInSearchResults()
        {
            int topsize = 30;
            int widthsize = 125;
            int left = 265;
            int top = 180;

            Bitmap bmp = new Bitmap(widthsize, topsize, PixelFormat.Format32bppArgb);

            using (Graphics g = Graphics.FromImage(bmp))
            {                
                var rect = new User32.Rect();                
                User32.GetWindowRect(FocusSpotify(true).MainWindowHandle, ref rect);

                Graphics graphics = Graphics.FromImage(bmp);
                g.CopyFromScreen(left, top, 0, 0, new Size(widthsize, topsize), CopyPixelOperation.SourceCopy);
            }

            //make it a big bigger first
            Size si = new Size(bmp.Width * 2, bmp.Height * 2); //bump up the size to increase BlueSimilarity's change of not fudging the text
            bmp = ResizeImage(bmp, si);

            bmp.Save("lastsearch.png");

            String MatchedText;

            using (var engine = new TesseractEngine("tesseract-ocr", "eng", EngineMode.Default))
            {
                using (var pix = PixConverter.ToPix(bmp))
                {
                    using (var page = engine.Process(pix))
                    {
                        //3. Get matched text from tesseract                        
                        MatchedText = page.GetText();                        
                    }
                }
            }

            String[] Lines = MatchedText.Split(new char[] { '\n' });
            String Word = Lines[0];

            return Word;
        }

        private void btnFindSong_Click(object sender, EventArgs e)
        {
            FocusSpotify();
            
            System.Threading.Thread.Sleep(1000);
            
            SelectSearchbarSpotify();
            TypeSpotify("Drudkh Cursed Sons, Pt 1");
            
            System.Threading.Thread.Sleep(1000);

            SelectAllResults();
            
            System.Threading.Thread.Sleep(500);
            String i = SeeifAlbumsInSearchResults();

            if(i == "ALBUMS")
                PlayFromResultsLowerScreen();
            else
                PlayFromResultsScreen();

            ClickClearSearchSpotify();            
        }

        private void btnPlayPause_Click(object sender, EventArgs e)
        {
            FocusSpotify();
            PausePlaySpotify();
        }

        public static Bitmap ResizeImage(Bitmap imgToResize, Size size)
        {
            Bitmap b = new Bitmap(size.Width, size.Height);

            using (Graphics g = Graphics.FromImage((Image)b))
            {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(imgToResize, 0, 0, size.Width, size.Height);
            }

            return b;
        }        
    }

    class User32
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct Rect
        {
            public int left;
            public int top;
            public int right;
            public int bottom;
        }

        [DllImport("user32.dll")]
        public static extern IntPtr GetWindowRect(IntPtr hWnd, ref Rect rect);
    }
}

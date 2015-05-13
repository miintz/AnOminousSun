using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;



namespace Handler
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Form f = new Handler();

            //Application.EnableVisualStyles();
            //Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Handler());
            
            f.ClientSize = new System.Drawing.Size(300, 93);
            //f.TransparencyKey = f.BackColor;
            ((Action)(() => System.Windows.Forms.Application.Run(f))).BeginInvoke(null, null);

            using (MicrophoneMonitor game = new MicrophoneMonitor())
            {
                f.ResizeEnd += new EventHandler(game.f_LocationChanged);
                game.Run();
            }
        }
    }
}

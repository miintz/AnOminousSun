using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Handler
{
    class MicrophoneMonitor : Microsoft.Xna.Framework.Game
    {
        public static Rectangle windowRect;

        Microphone MainIn;
        byte[] MainInBuffer;

        public MicrophoneMonitor()
        {
            base.Initialize();

            MainIn = Microphone.Default;
            MainIn.BufferDuration = TimeSpan.FromSeconds(1);
            MainInBuffer = new byte[MainIn.GetSampleSizeInBytes(MainIn.BufferDuration)];
            MainIn.BufferReady += MainIn_BufferReady;

            base.Run();
            
        }

        public void f_LocationChanged(object sender, EventArgs e)
        {
            var FakeWindow = sender as System.Windows.Forms.Form;

            var drawClientArea = FakeWindow.RectangleToScreen(
                                   FakeWindow.ClientRectangle);
            windowRect = new Rectangle(
                       drawClientArea.X,
                       drawClientArea.Y,
                       drawClientArea.Width,
                       drawClientArea.Height);
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }

        public void StartMic()
        {
            MainIn.Start();
        }

        private void MainIn_BufferReady(object sender, EventArgs e)
        {
            MainIn.GetData(MainInBuffer);
        }

        protected override void Draw(Microsoft.Xna.Framework.GameTime gameTime)
        {
            base.SuppressDraw();
        }

        protected override void Update(Microsoft.Xna.Framework.GameTime gameTime)
        {
            base.Update(gameTime);   
        }
    }
}

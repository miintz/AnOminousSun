using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.IO.Ports;

using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework;
using System.IO;

using GdiColor = System.Drawing.Color;
using XnaColor = Microsoft.Xna.Framework.Color;

namespace Handler
{
    public partial class Handler : Form
    {
        SerialPort port;
        MicrophoneMonitor Monitor;

        public Handler()
        {
            InitializeComponent();

        }

        public void SetMicrophoneMonitorInstance(MicrophoneMonitor m)
        {
            Monitor = m;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Monitor.StartMic();

            port = new SerialPort("COM3", 57600);

            try
            {
                //un-comment this line to cause the arduino to re-boot when the serial connects
                //port.DtrEnabled = true;

                port.Open();
            }
            catch (Exception ex)
            {
                //alert the user that we could not connect to the serial port
                this.Close();
                this.Dispose();
            }
        }

        private void ArmListener()
        { 
            //9
        }

        private void FireListener()
        { 
        
        }

        private void ResetListener()
        { 
        
        }

        private void ArmBacker()
        { 
            //10
        }

        private void FireBacker()
        { 
        
        }

        private void ResetBacker()
        { 
            
        }
    }
}

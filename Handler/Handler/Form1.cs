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

namespace Handler
{
    public partial class Handler : Form
    {
        SerialPort port;
        
        public Handler()
        {
            InitializeComponent();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            port = new SerialPort("COM3", 57600);

            try
            {                
                port.Open();
            }
            catch (Exception ex)
            {             
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
            //9
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

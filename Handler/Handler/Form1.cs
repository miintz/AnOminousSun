using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Phidget21COM;
using System.Threading;
using System.IO.Ports;

namespace Handler
{
    public partial class Form1 : Form
    {
        SerialPort port;

        public Form1()
        {
            InitializeComponent();
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
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            port.Write("x");
            port.Write("y");

            port.Write("a"); //listen loop on;
            port.Write("b");

            port.Write("z");
            //etc
        }
    }
}

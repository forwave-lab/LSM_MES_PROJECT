using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Milling_Marking
{
    public partial class Form1 : Form
    {
        public const string Port = "COM5";
        public const string Baud = "9600";
        public const string Databits = "8";
        public const string Parity = "None";
        public const string Stop = "One";

        const byte STX = (byte)0x02;
        const byte ETX = (byte)0x03;
        const byte SOH = (byte)0x01;
        const byte EOT = (byte)0x04;
        const byte BEL = (byte)0x07;
        const byte ENQ = (byte)0x05;
        const byte SO = (byte)0x0E;
        const byte SI = (byte)0x0F;
        const byte ACK = (byte)0x06;
        const byte NAK = (byte)0x15;

        MarkingSocket.MarkingSocket MS = new MarkingSocket.MarkingSocket();

        public Form1()
        {
            InitializeComponent();
            this.btn_Open.Click += new System.EventHandler(this.Serial_Open);
            this.btn_Close.Click += new System.EventHandler(this.Serial_Close);
            this.btn_Send.Click += new System.EventHandler(this.Serial_Send);
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void Serial_Open(object sender, EventArgs e)
        {
            this.label1.Text = MS.Comport_Open(Port, Baud, Databits, Parity, Stop);       
        }

        private void Serial_Close(object sender, EventArgs e)
        {
            MS.CloseSerialComm();
            this.label1.Text = "Colse";
        }

        private void Serial_Send(object sender, EventArgs e)
        {
            string FOLDER_FILENAME = "02" + ":" + "23";
            //string strMarking = (char)STX + str2hex(FOLDER_FILENAME) + (char)ETX + (char)STX + str2hex(textBox1.Text) + (char)SOH + (char)SO + (char)BEL;// + (char)ETX
            string strMarking = (char)STX + FOLDER_FILENAME + (char)ETX + (char)STX + textBox1.Text + " " + (char)SOH + (char)SI + (char)BEL;// + (char)ETX

            byte[] sdata = ASCIIEncoding.ASCII.GetBytes(strMarking);

            ListAdd(sdata);
            
            MS.SendSerialComm(sdata, sdata.Length);
        }

        public void Serial_Receive(string LotID)
        {

        }

        private void ListAdd(byte[] Msg)
        {
            string mMsg = string.Empty;
            foreach (byte b in Msg)
            {
                mMsg += string.Format("{0:X2}", b) + " ";
            }
            this.listBox1.Items.Add(mMsg);
        }

        public string str2hex(string strData)
        {
            string resultHex = string.Empty;
            byte[] arr_byteStr = Encoding.Default.GetBytes(strData);

            foreach (byte byteStr in arr_byteStr)
                resultHex += string.Format("{0:X2}", byteStr);
            return resultHex;
        }
    }
}

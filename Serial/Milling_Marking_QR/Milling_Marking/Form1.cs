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
        MarkingSocket.MarkingSocket MS = new MarkingSocket.MarkingSocket();

        string port = "COM5";
        string baud = "115200";
        string databits = "8";
        string parity = "None";
        string stop = "One";

        public Form1()
        {
            InitializeComponent();
            this.btn_Open.Click += new System.EventHandler(this.Serial_Open);
            this.btn_Close.Click += new System.EventHandler(this.Serial_Close);
            this.btn_Send.Click += new System.EventHandler(this.Serial_Send);
        }

        public void Form1_Load(object sender, EventArgs e)
        {

        }

        private void Serial_Open(object sender, EventArgs e)
        {
            this.label1.Text = MS.Comport_Open(port,baud,databits,parity,stop);           
        }

        private void Serial_Close(object sender, EventArgs e)
        {
            MS.CloseSerialComm();
            this.label1.Text = "Colse";
        }

        private void Serial_Send(object sender, EventArgs e)
        {
            byte SOH = (byte)0x01; //START OF HEADING
            byte NUL = (byte)0x00; //장비번호
            byte ESC = (byte)0x1B;
            byte STX = (byte)0x02;
            byte ETX = (byte)0x03;
            byte EOT = (byte)0x04;
            byte BEL = (byte)0x07;
            byte ENQ = (byte)0x05;
            byte SO = (byte)0x0E;
            byte SI = (byte)0x0F;
            byte GS = (byte)0x1D; //GROUP SEPARATOR
            byte VT = (byte)0x0B; //VERTICAL TAB
            byte LF = (byte)0x0A;
            byte ACK = (byte)0x06;
            byte NAK = (byte)0x15;
            byte ck = (byte)0xAB;

            byte NF1 = (byte)0x02;
            byte ID1 = (byte)0x01;
            byte ID2 = (byte)0x02;
            byte ID3 = (byte)0x03;
            byte BT1 = (byte)0x0A;

            /*
            string strMarking = string.Format("{0:X2}", ESC)
                + string.Format("{0:X2}", STX)
                + string.Format("{0:X2}", NUL)
                + string.Format("{0:X2}", GS)
                + string.Format("{0:X2}", STX)
                + string.Format("{0:X2}", SOH)
                + string.Format("{0:X2}", VT) 
                + str2hex(textBox1.Text)
                + string.Format("{0:X2}", ETX)
                + string.Format("{0:X2}", LF)
                + str2hex(textBox2.Text)
                + string.Format("{0:X2}", ESC)
                + string.Format("{0:X2}", ETX);
            */

            string strMarking = (char)ESC + (char)STX + (char)NUL + (char)GS + (char)STX + (char)SOH + (char)VT + str2hex(textBox1.Text) + (char)ETX + (char)LF + str2hex(textBox2.Text) + (char)ESC + (char)ETX;

            byte[] Data1 = ASCIIEncoding.ASCII.GetBytes(textBox1.Text);
            byte[] Data2 = ASCIIEncoding.ASCII.GetBytes(textBox2.Text);
            byte[] Data3 = ASCIIEncoding.ASCII.GetBytes(textBox3.Text);

            byte[] ComData = new byte[7];
            ComData[0] = ESC;
            ComData[1] = STX;
            ComData[2] = NUL;
            ComData[3] = GS;
            ComData[4] = NF1;// STX;
            ComData[5] = ID1;// SOH;
            ComData[6] = 0X0F;

            byte[] NewData1 = new byte[Data1.Length + 2];
            Array.Copy(Data1, NewData1, Data1.Length);
            NewData1[NewData1.Length - 2] = ID2;
            NewData1[NewData1.Length - 1] = 0X1E;

            byte[] NewData2 = new byte[NewData1.Length + Data2.Length + 2];
            Array.Copy(NewData1, 0, NewData2, 0, NewData1.Length);
            Array.Copy(Data2, 0, NewData2, NewData1.Length, Data2.Length);
            NewData2[NewData2.Length - 2] = ID3;
            NewData2[NewData2.Length - 1] = BT1;

            byte[] NewData3 = new byte[NewData2.Length + Data3.Length + 2];
            Array.Copy(NewData2, 0, NewData3, 0, NewData2.Length);
            Array.Copy(Data3, 0, NewData3, NewData2.Length, Data3.Length);
            NewData3[NewData3.Length - 2] = ESC;
            NewData3[NewData3.Length - 1] = ETX;

            byte[] NewData = new byte[ComData.Length + NewData3.Length + 1];
            Array.Copy(ComData, 0, NewData, 0, ComData.Length);
            Array.Copy(NewData3, 0, NewData, ComData.Length, NewData3.Length);

            NewData[NewData.Length - 1] = CalculateChecksum(NewData);

            ListAdd(NewData);            

            MS.SendSerialComm(NewData, NewData.Length);
        }

        private void ListAdd(byte[] Msg)
        {
            string mMsg = string.Empty;
            foreach (byte b in Msg)
            {
                mMsg += string.Format("{0:X2}", b) + " ";
            }
            this.listBox1.Items.Add(mMsg);
            textBox4.Text = mMsg;
        }

        public string str2hex(string strData)
        {
            string resultHex = string.Empty;
            byte[] arr_byteStr = Encoding.Default.GetBytes(strData);

            foreach (byte byteStr in arr_byteStr)
                resultHex += string.Format("{0:X2}", byteStr);
            return resultHex;
        }

        private byte CalculateChecksum(byte[] dataToCalculate)
        {
            int i = 256;
            int checksum = 0;
            foreach (byte chData in dataToCalculate)
            {
                checksum += chData;
            }
            checksum &= 0xff;        
            checksum = i - checksum;
            //return string.Format("{0:X2}", checksum);
            byte[] byteArray = BitConverter.GetBytes(checksum);
            return byteArray[0];
        }
    }
}

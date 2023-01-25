using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using System.IO.Ports;

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

        public ArrayList arrSerialbuff = new ArrayList();
        private SerialPort sp = new SerialPort();
        public string LotID;

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
            //this.label1.Text = this.Comport_Open(Port, Baud, Databits, Parity, Stop);       
        }

        private void Serial_Close(object sender, EventArgs e)
        {
            this.CloseSerialComm();
            this.label1.Text = "Colse";
        }

        //marking button 클릭시
        private void Serial_Send(object sender, EventArgs e)
        {
            //string FOLDER_FILENAME = "02" + ":" + "23";
            ////string strMarking = (char)STX + str2hex(FOLDER_FILENAME) + (char)ETX + (char)STX + str2hex(textBox1.Text) + (char)SOH + (char)SO + (char)BEL;// + (char)ETX
            //string strMarking = (char)STX + FOLDER_FILENAME + (char)ETX + (char)STX + textBox1.Text + " " + (char)SOH + (char)SI + (char)BEL;// + (char)ETX

            //byte[] sdata = ASCIIEncoding.ASCII.GetBytes(strMarking);

            //ListAdd(sdata);
            
            //this.SendSerialComm(sdata, sdata.Length);
            string Result = string.Empty;
            Result = this.Comport_Open(Port, Baud, Databits, Parity, Stop);
            if (Result == "Fail")
            {
                Serial_Port_Close();
            }
            else
            {
                Send_Data("S");
            }
        }

        private void Send_Data(string Result)
        {
            string strMarking = string.Empty;
            string FOLDER_FILENAME = "02" + ":" + "23";
            //string strMarking = (char)STX + str2hex(FOLDER_FILENAME) + (char)ETX + (char)STX + str2hex(textBox1.Text) + (char)SOH + (char)SO + (char)BEL;
            if (Result == "S")
            {
                strMarking = (char)STX + FOLDER_FILENAME + (char)ETX + (char)STX + textBox1.Text + " " + (char)SOH + (char)SI + (char)BEL;
            }
            else
            {
                strMarking = (char)STX + FOLDER_FILENAME + (char)ETX + (char)STX + textBox1.Text + " " + (char)SOH + (char)SO + (char)EOT;
            }

            byte[] sdata = ASCIIEncoding.ASCII.GetBytes(strMarking);

            //ListAdd(sdata);

            this.SendSerialComm(sdata, sdata.Length); 
        }


        private void Serial_Receive(string LotID)
        {
            string Msg = string.Empty;

            if (LotID == string.Empty)
            {
                MessageBox.Show("마킹을 완료하였습니다.");
            }
            else if (LotID.Length == 3)
            {
                switch (LotID)
                {
                    case "001":
                        Msg = "전송시작 제어문자 오류";
                        break;
                    case "002":
                        Msg = "폴더파일명 전송문자 초과 오류";
                        break;
                    case "003":
                        Msg = "폴더명 전송문자 초과 오류";
                        break;
                    case "004":
                        Msg = "폴더명 문자 종류 오류";
                        break;
                    case "005":
                        Msg = "파일명 전송문자 초과 오류";
                        break;
                    case "006":
                        Msg = "파일명 문자 종류 오류";
                        break;
                    case "007":
                        Msg = "폴더파일명 종료 제어문자 오류";
                        break;
                    case "008":
                        Msg = "마킹데이타 시작 제어문자 오류";
                        break;
                    case "009":
                        Msg = "마킹데이타 전송문자 초과 오류";
                        break;
                    case "010":
                        Msg = "마킹데이타 종료 제어문자 오류";
                        break;
                    case "011":
                        Msg = "파일없음 오류";
                        break;
                    case "012":
                        Msg = "파일 손상 열기 실패 오류";
                        break;
                    default:
                        Msg = "기타오류(오류내역없음)";
                        break;
                }
                MessageBox.Show(Msg);
            }
            else
            {
                DialogResult dialogResult = MessageBox.Show(LotID + "를 마킹하시겠습니까?", "Milling Marking", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    Send_Data("L");
                }
            }
        }

        //private void ListAdd(byte[] Msg)
        //{
        //    string mMsg = string.Empty;
        //    foreach (byte b in Msg)
        //    {
        //        mMsg += string.Format("{0:X2}", b) + " ";
        //    }
        //    this.listBox1.Items.Add(mMsg);
        //}

        //public string str2hex(string strData)
        //{
        //    string resultHex = string.Empty;
        //    byte[] arr_byteStr = Encoding.Default.GetBytes(strData);

        //    foreach (byte byteStr in arr_byteStr)
        //        resultHex += string.Format("{0:X2}", byteStr);
        //    return resultHex;
        //}

        #region Serial Connection
        public string Comport_Open(string port, string baud, string databits, string parity, string stop)
        {
            try
            {
                sp.PortName = port;
                sp.BaudRate = int.Parse(baud);
                sp.DataBits = int.Parse(databits);
                sp.Parity = (Parity)Enum.Parse(typeof(Parity), parity);
                sp.StopBits = (StopBits)Enum.Parse(typeof(StopBits), stop);

                sp.DataReceived += new SerialDataReceivedEventHandler(sp_DataReceived);

                if (!sp.IsOpen)
                {
                    sp.Open();
                }

                if (sp.IsOpen)
                {
                    return "SerialPort Connect Sucess";
                }
                else
                {
                    return "Fail";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Send
        public void SendSerialComm(byte[] SendComm_Packet, int len)
        {
            string Result = string.Empty;
            try
            {
                if (sp.IsOpen)
                {
                    sp.Write(SendComm_Packet, 0, len);
                }
                else
                {                    
                    Result = this.Comport_Open(Port, Baud, Databits, Parity, Stop);
                    if (Result == "Fail")
                    {
                        Serial_Port_Close();
                    }
                    else
                    {
                        sp.Write(SendComm_Packet, 0, len);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Receive
        private void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
                if (sp.IsOpen)
                {
                    RcvBuffClear();
                    LotID = string.Empty;

                    int nbyte = sp.BytesToRead;
                    byte[] rbuff = new byte[nbyte];

                    if (nbyte > 0)
                    {
                        sp.Read(rbuff, 0, nbyte);
                    }

                    for (int i = 0; i < nbyte; i++)
                    {
                        arrSerialbuff.Add(rbuff[i]);
                        if (i > 3)
                        {
                            if (rbuff[i] == 1)
                            {
                                break;
                            }
                            else
                            {
                                LotID = LotID + string.Format("{0:X2}", (char)rbuff[i]);
                            }
                        }
                    }
                    this.Serial_Receive(LotID);
                }
            }
            catch (Exception ex)
            {
                RcvBuffClear();
                throw ex;
            }
        }
        #endregion

        private void Serial_Port_Close()
        {
            MessageBox.Show("Serial_Connect", "케이블 연결이 되지 않았습니다.");
        }

        #region Receive 사용안함
        //public void RcvSerialComm(object s, EventArgs e)
        //{
        //    try
        //    {
        //        if (sp.IsOpen)
        //        {
        //            int nbyte = sp.BytesToRead;
        //            byte[] rbuff = new byte[nbyte];

        //            if (nbyte > 0)
        //            {
        //                sp.Read(rbuff, 0, nbyte);
        //            }

        //            for (int i = 0; i < nbyte; i++)
        //            {
        //                arrSerialbuff.Add(rbuff[i]);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        arrSerialbuff.Clear();
        //        throw ex;
        //    }
        //}
        #endregion

        #region Serial Close
        public void CloseSerialComm()
        {
            try
            {
                if (sp != null)
                    sp.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region Dispose
        public void Dispose()
        {
            if (arrSerialbuff.Count > 0)
            {
                arrSerialbuff.Clear();
            }

            if (sp != null)
                sp.Dispose();
        }
        #endregion

        #region IsOpen
        public bool IsOpened()
        {
            return sp.IsOpen;
        }
        #endregion

        #region buffer초기화
        public void RcvBuffClear()
        {
            arrSerialbuff.Clear();
        }
        #endregion
    }
}

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
        public string Port = "COM1";
        //public const string Baud = "9600";
        public const string Baud = "115200";
        public const string Databits = "8";
        public const string Parity = "None";
        public const string Stop = "One";

        public string serialMsg;
        int serialoffset = 0;
        //string serialstartStr;
        //string serialendStr;

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
        const byte ESC = (byte)0x1B;
        const byte serialstartStr = (byte)0x58;
        const byte serialendStr = (byte)0x0C;

        const byte CR = (byte)0x0D;
        const byte LP = (byte)0x0A;
        const byte Zero = (byte)0x00;
        const byte space = (byte)0x32;


        const byte AT = (byte)0x40; //@
        const byte SEMICOLON = (byte)0x3B; //;



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
            string[] comlist = System.IO.Ports.SerialPort.GetPortNames();

            if (comlist.Length > 0)
            {
                comboBox1.Items.AddRange(comlist);
                comboBox1.SelectedIndex = 0;
            }
        }

        private void Serial_Open(object sender, EventArgs e)
        {
            this.label1.Text = this.Comport_Open(comboBox1.Text, Baud, Databits, Parity, Stop);       
        }

        private void Serial_Close(object sender, EventArgs e)
        {
            this.CloseSerialComm();
            this.label1.Text = "Colse";
        }

        private void Serial_Send(object sender, EventArgs e)
        {
            string Result = string.Empty;

            if(sp.IsOpen)
            {
                Send_Data("S");
            }
            else
            {
                Result = this.Comport_Open(comboBox1.Text, Baud, Databits, Parity, Stop);
                this.label1.Text = Result;

                if (Result == "Fail")
                {
                    Serial_Port_Close();
                }
                else
                {
                    Send_Data("S");
                }
            }
        }

        private void Send_Data(string Result)
        {
            string strMarking = string.Empty;

            strMarking = (char)ESC + "@" + (char)SEMICOLON;                                   //메모리 초기화
            strMarking = strMarking + (char)ESC + "G1" + (char)SEMICOLON;                     //마킹타입
            strMarking = strMarking + (char)ESC + "H0" + (char)SEMICOLON;                     //폰트타입
            strMarking = strMarking + (char)ESC + "I300" + (char)SEMICOLON;                   //X축좌표
            strMarking = strMarking + (char)ESC + "J300" + (char)SEMICOLON;                   //Y축좌표
            strMarking = strMarking + (char)ESC + "L000" + (char)SEMICOLON;                   //마킹각도타입
            strMarking = strMarking + (char)ESC + "M030" + (char)SEMICOLON;                   //문자간격
            strMarking = strMarking + (char)ESC + "O030" + (char)SEMICOLON;                   //문자높이
            strMarking = strMarking + (char)ESC + "?U" + textBox1.Text + (char)SEMICOLON;     //폰트타입
            strMarking = strMarking + (char)ESC + "!" + (char)SEMICOLON;                      //Start     

            byte[] sdata = ASCIIEncoding.ASCII.GetBytes(strMarking);

            ListAdd(sdata);

            this.SendSerialComm(sdata, sdata.Length); 
        }


        private void Serial_Receive(string LotID)
        {
            string Msg = string.Empty;
            MessageBox.Show(LotID);            
            return;

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
                DialogResult dialogResult = MessageBox.Show(LotID + "를 마킹하시겠습니까?", "TubeMilling Marking", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    //Send_Data("L");
                }
            }
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
                return ex.Message;
                //throw ex;
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
                    Result = this.Comport_Open(comboBox1.Text, Baud, Databits, Parity, Stop);
                    this.label1.Text = Result;
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
                    byte[] rbuff = new byte[4096];
                    //변경
                    //byte[] rbuff;
                    if (serialoffset == 0)
                    {
                        //rbuff = new byte[4096];
                    }
                    string serialtostring;
                    if (nbyte != 0)
                    {
                        sp.Read(rbuff, serialoffset, nbyte);
                        serialoffset += nbyte;


                        for (int i = 0; i < serialoffset; i++)
                        {
                            if(rbuff[i] != CR && rbuff[i] != LP && rbuff[i] != Zero && rbuff[i] != space)
                            {
                                serialMsg += Convert.ToChar(rbuff[i]);
                            } 
                        }
                        
                        //if (serialMsg.Contains((char)serialstartStr))
                        //{
                           //serialMsg = serialMsg.Substring(serialMsg.IndexOf((char)serialstartStr));
                            if (serialMsg.Contains((char)serialendStr))
                            {
                                this.Serial_Receive(serialMsg);
                                Console.WriteLine(serialMsg);
                                serialoffset = 0;
                                serialMsg = string.Empty;
                        }
                        //}
                    }

                    return;

                    serialtostring = sp.ReadLine();                    
                    MessageBox.Show(serialtostring);
                    return;


                    serialMsg = serialMsg + sp.ReadByte().ToString();



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

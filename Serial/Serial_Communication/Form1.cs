using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;  //시리얼통신을 위해 추가해줘야 함

namespace Serial_Communication
{
    public partial class Form1 : Form
    {
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

        const byte AT = (byte)0x40; //@
        const byte SEMICOLON = (byte)0x3B; //;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)  //폼이 로드되면
        {
            comboBox_port.DataSource = SerialPort.GetPortNames(); //연결 가능한 시리얼포트 이름을 콤보박스에 가져오기 
        }
               
        private void Button_connect_Click(object sender, EventArgs e)  //통신 연결하기 버튼
        {
            if (!serialPort1.IsOpen)  //시리얼포트가 열려 있지 않으면
            {
                serialPort1.PortName = comboBox_port.Text;  //콤보박스의 선택된 COM포트명을 시리얼포트명으로 지정
                serialPort1.BaudRate = 9600;  //보레이트 변경이 필요하면 숫자 변경하기
                serialPort1.DataBits = 8;
                serialPort1.StopBits = StopBits.One;
                serialPort1.Parity = Parity.None;
                serialPort1.DataReceived += new SerialDataReceivedEventHandler(serialPort1_DataReceived); //이것이 꼭 필요하다
                
                serialPort1.Open();  //시리얼포트 열기

                label_status.Text = "포트가 열렸습니다.";
                comboBox_port.Enabled = false;  //COM포트설정 콤보박스 비활성화
            }
            else  //시리얼포트가 열려 있으면
            {
                label_status.Text = "포트가 이미 열려 있습니다.";
            }
        }
                
        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)  //수신 이벤트가 발생하면 이 부분이 실행된다.
        {
            System.Threading.Thread.Sleep(100);

            this.Invoke(new EventHandler(MySerialReceived));  //메인 쓰레드와 수신 쓰레드의 충돌 방지를 위해 Invoke 사용. MySerialReceived로 이동하여 추가 작업 실행.
        }

     

        private void Serial_Receive()
        {

            //수신 문자열 체크
            if (richTextBox_received_hex.Text.IndexOf(textBox_send.Text) != -1)
            {
                label_comm.Text = "lot 정상 수신";
            }
            else if (richTextBox_received_hex.Text.IndexOf("E01") != -1)
            {
                label_comm.Text = "각인 취소";

            }
            else if (richTextBox_received_hex.Text.IndexOf("E03") != -1)
            {
                label_comm.Text = "각인 완료";

            }
            else if (richTextBox_received_hex.Text.IndexOf("B0000") != -1)
            {
                label_comm.Text = "각인 중";

            }
            else
            {
                label_comm.Text = "err code";
            }
        }

        private void Button_send_Click(object sender, EventArgs e)  //보내기 버튼을 클릭하면
        {
            string strMarking = string.Empty;
            string strMarking_rev = string.Empty;

            strMarking = (char)ESC + "U" + textBox_send.Text + (char)SEMICOLON;     //센드데이터
            strMarking_rev = (char)ESC + "?U" + (char)SEMICOLON;     //센드데이터 갔는지 확인 리시브 데이터

            byte[] sdata = ASCIIEncoding.ASCII.GetBytes(strMarking);
            byte[] sdata_rev = ASCIIEncoding.ASCII.GetBytes(strMarking_rev);

            ListAdd(sdata);

            this.SendSerialComm(sdata, sdata.Length);           //데이터 송신
            //Delay(1000);                                         //만약 송신 중에 바로 또 송신이 될경우 주석 해제
            this.SendSerialComm(sdata_rev, sdata_rev.Length);   //정상 수신 했는지 체크 송신 -> 보내면 바로 받은 데이터 수신보내줌

        }

        private void ListAdd(byte[] Msg)
        {
            string mMsg = string.Empty;

            textBox_send_hex.Text = "";

            foreach (byte b in Msg)
            {
                mMsg += string.Format("{0:X2}", b) + " ";
            }
            this.textBox_send_hex.Text = mMsg;
        }


        private void ListAdd_rev(int Msg)
        {
            
            this.richTextBox_received_hex.Text = string.Format("{0:X2}", Msg); 
        }


        private void ListAdd_rev_1(string rev)
        {

            this.richTextBox_received_hex.Text = rev;
        }

        #region Receive
        private void MySerialReceived(object s, EventArgs e)  //여기에서 수신 데이타를 사용자의 용도에 따라 처리한다.
        {

            string LotID = "";

            try
            {
                if (serialPort1.IsOpen)
                {
                    //RcvBuffClear();
                    LotID = string.Empty;

                    //int nbyte = serialPort1.BytesToRead;
                    //byte[] rbuff = new byte[nbyte];

                    string sRcv = serialPort1.ReadExisting();

                    //ListAdd_rev(nbyte);
                    ListAdd_rev_1(sRcv);

                    //if (nbyte > 0)
                    //{
                    //    serialPort1.Read(rbuff, 0, nbyte);
                    //}

                    //for (int i = 0; i < nbyte; i++)
                    //{
                    //    //arrSerialbuff.Add(rbuff[i]);
                    //    if (i >= 0)
                    //    {
                    //        if (rbuff[i] == 1)
                    //        {
                    //            break;
                    //        }
                    //        else
                    //        {
                    //            LotID = LotID + string.Format("{0:X2}", (char)rbuff[i]);
                    //        }
                    //    }
                    //}
                    //richTextBox_received.Text = LotID;
                    this.Serial_Receive();
                }
            }
            catch (Exception ex)
            {
                //RcvBuffClear();
                throw ex;
            }


        }
        #endregion

        #region send
        public void SendSerialComm(byte[] SendComm_Packet, int len)
        {
            string Result = string.Empty;

            try
            {
                if (serialPort1.IsOpen)
                {
                    serialPort1.Write(SendComm_Packet, 0, len);
                }
                else
                {
                    serialPort1.Close();
                    serialPort1.Open();
                    serialPort1.Write(SendComm_Packet, 0, len);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                return;
                //throw ex;
            }
        }
        #endregion

        #region 연결해제
        private void Button_disconnect_Click(object sender, EventArgs e)  //통신 연결끊기 버튼
        {
            if (serialPort1.IsOpen)  //시리얼포트가 열려 있으면
            {
                serialPort1.Close();  //시리얼포트 닫기

                label_status.Text = "포트가 닫혔습니다.";
                comboBox_port.Enabled = true;  //COM포트설정 콤보박스 활성화
            }
            else  //시리얼포트가 닫혀 있으면
            {
                label_status.Text = "포트가 이미 닫혀 있습니다.";
            }
        }
        #endregion

        #region Delay 함수
        private static DateTime Delay(int MS)
        {
            DateTime ThisMoment = DateTime.Now;
            TimeSpan duration = new TimeSpan(0, 0, 0, 0, MS);
            DateTime AfterWards = ThisMoment.Add(duration);

            while (AfterWards >= ThisMoment)
            {
                System.Windows.Forms.Application.DoEvents();
                ThisMoment = DateTime.Now;
            }

            return DateTime.Now;
        }
        #endregion
    }
}

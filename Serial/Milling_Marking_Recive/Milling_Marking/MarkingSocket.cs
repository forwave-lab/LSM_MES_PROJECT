using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Ports;
using System.Collections;

namespace MarkingSocket
{
    class MarkingSocket
    {
//////        public ArrayList arrSerialbuff = new ArrayList();
//////        private SerialPort sp = new SerialPort();
//////        public string LotID;

////////.Form1 form = new Milling_Marking.Form1();

//////        #region Serial Connection
//////        public string Comport_Open(string port, string baud, string databits, string parity, string stop)
//////        {
//////            try
//////            {                
//////                sp.PortName = port;
//////                sp.BaudRate = int.Parse(baud);
//////                sp.DataBits = int.Parse(databits);
//////                sp.Parity = (Parity)Enum.Parse(typeof(Parity), parity);
//////                sp.StopBits = (StopBits)Enum.Parse(typeof(StopBits), stop);

//////                sp.DataReceived += new SerialDataReceivedEventHandler(sp_DataReceived);

//////                if (!sp.IsOpen)
//////                {
//////                    sp.Open();
//////                }

//////                if (sp.IsOpen)
//////                {
//////                    return "SerialPort Connect Sucess";
//////                }
//////                else
//////                {
//////                    return "SerialPort Connect Fail";
//////                }
//////            }
//////            catch (Exception ex)
//////            {
//////                throw ex;
//////            }
//////        }
//////        #endregion

//////        #region Send
//////        public void SendSerialComm(byte[] SendComm_Packet, int len)
//////        {
//////            try
//////            {
//////                if (sp.IsOpen)
//////                    sp.Write(SendComm_Packet, 0, len);
//////            }
//////            catch (Exception ex)
//////            {
//////                throw ex;
//////            }
//////        }
//////        #endregion
        
//////        private void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
//////        {
//////            try
//////            {
//////                if (sp.IsOpen)
//////                {
//////                    int nbyte = sp.BytesToRead;
//////                    byte[] rbuff = new byte[nbyte];

//////                    if (nbyte > 0)
//////                    {
//////                        sp.Read(rbuff, 0, nbyte);
//////                    }

//////                    for (int i = 0; i < nbyte; i++)
//////                    {
//////                        arrSerialbuff.Add(rbuff[i]);
//////                        if (i > 3)
//////                        {
//////                            if (rbuff[i] == 1)
//////                            {
//////                                break;
//////                            }
//////                            else
//////                            {
//////                                LotID = LotID + string.Format("{0:X2}", (char)rbuff[i]);
//////                            }
//////                        }
//////                    }
//////                }
//////            }
//////            catch (Exception ex)
//////            {
//////                arrSerialbuff.Clear();
//////                throw ex;
//////            }
//////        }

//////        #region Receive 사용안함
//////        //public void RcvSerialComm(object s, EventArgs e)
//////        //{
//////        //    try
//////        //    {
//////        //        if (sp.IsOpen)
//////        //        {
//////        //            int nbyte = sp.BytesToRead;
//////        //            byte[] rbuff = new byte[nbyte];

//////        //            if (nbyte > 0)
//////        //            {
//////        //                sp.Read(rbuff, 0, nbyte);
//////        //            }

//////        //            for (int i = 0; i < nbyte; i++)
//////        //            {
//////        //                arrSerialbuff.Add(rbuff[i]);
//////        //            }
//////        //        }
//////        //    }
//////        //    catch (Exception ex)
//////        //    {
//////        //        arrSerialbuff.Clear();
//////        //        throw ex;
//////        //    }
//////        //}
//////        #endregion

//////        #region Serial Close
//////        public void CloseSerialComm()
//////        {
//////            try
//////            {
//////                if (sp != null)
//////                    sp.Close();
//////            }
//////            catch (Exception ex)
//////            {
//////                throw ex;
//////            }
//////        }
//////        #endregion 

//////        #region Dispose
//////        public void Dispose()
//////        {
//////            if (arrSerialbuff.Count > 0)
//////            {
//////                arrSerialbuff.Clear();
//////            }

//////            if (sp != null)
//////                sp.Dispose();
//////        }
//////        #endregion

//////        public bool IsOpened()
//////        {
//////            return sp.IsOpen;
//////        }

//////        public int RcvCnt()
//////        {
//////            return arrSerialbuff.Count;
//////        }

//////        public void RcvBuffClear()
//////        {
//////            arrSerialbuff.Clear();
//////        }
    }
}
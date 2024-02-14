using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace zpl_viewer
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string zpl_code; //그리드에서 클릭한 row의 zpl데이타로 string 변수할당
            zpl_code = @"^XA   
                        ^MMT
                        ^PW992
                        ^LL709
                        ^LS0
                        ^CI28
                        ^CFJ,50
                        //^SEE:UHANGUL.DAT^FS 
                        //^CW1,E:KFONT3.FNT^CI26^FS 
                        ^FO220,60^A0N,40,40^FDGN7-CLUSTER-Main-BOT^FS      //품번
                        ^FO760,43^BXN,8,200,^FDPK20240205000001^FS         //포장LOT 바코드
                        ^FO745,180^A0N,40,20^FDPK20240205000001^FS         //포장LOT
                        ^FO220,155^A0N,40,40^FDGN7-MDPS-POWER-UNIT^FS      //품명
                        ^FO220,250^A1N,40,40^FD수삽2라인^FS                //품명
                        ^FO765,250^A0N,40,40^FDGN7^FS                      //차종
                        ^FO220,345^A0N,40,40^FD2024.02.05^FS               //생산일
                        ^FO480,345^A1N,40,40^FD주간^FS                     //근무조
                        ^FO765,345^A0N,40,40^FD1,000^FS                    //수량
                        ^FO220,440^A0N,40,45^FDPK20240205000001^FS         //포장LOT
                        ^FO220,530^A0N,40,45^FDWI20240115-000001^FS        //작업지시번호
                        ^PQ1,1,1,Y^FS
                        ^XZ";
            //byte[] zpl = Encoding.UTF8.GetBytes(zpl_code);

            //var request = (HttpWebRequest)WebRequest.Create("http://api.labelary.com/v1/printers/8dpmm/labels/8x5/0/");
            //request.Method = "POST";
            //request.Accept = "application/pdf"; 
            //request.ContentType = "application/x-www-form-urlencoded";
            //request.ContentLength = zpl.Length;

            //var requestStream = request.GetRequestStream();
            //requestStream.Write(zpl, 0, zpl.Length);
            //requestStream.Close();

            //on line zpl to viewer API 활용
            String url = "http://api.labelary.com/v1/printers/8dpmm/labels/8x5/0/" + zpl_code;
            String fileName = "PackingLabel.png";
            if (DownloadRemoteImageFile(url, fileName))
            {
                //pictureBox1.Load(fileName);
                //pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            }

            //try
            //{
            //    var response = (HttpWebResponse)request.GetResponse();
            //    var responseStream = response.GetResponseStream();
            //    var fileStream = File.Create("label.pdf"); // change file name for PNG images
            //    responseStream.CopyTo(fileStream);
            //    responseStream.Close();
            //    fileStream.Close();
            //}
            //catch (WebException )
            //{
            //   // Console.WriteLine("Error: {0}", e.Status);
            //}
        }

        private bool DownloadRemoteImageFile(string uri, string fileName)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            bool bImage = response.ContentType.StartsWith("image",
                StringComparison.OrdinalIgnoreCase);
            if ((response.StatusCode == HttpStatusCode.OK ||
                response.StatusCode == HttpStatusCode.Moved ||
                response.StatusCode == HttpStatusCode.Redirect) &&
                bImage)
            {
                //API에서 받은 stream으로 PictureBox에 로드
                using (Stream inputStream = response.GetResponseStream())
                {
                    Bitmap bitmap = new Bitmap(inputStream);
                    pictureBox1.Image = bitmap;
                }
                ////using (Stream outputStream = File.OpenWrite(fileName))
                ////{
                ////    byte[] buffer = new byte[4096];
                ////    int bytesRead;
                ////    do
                ////    {
                ////        bytesRead = inputStream.Read(buffer, 0, buffer.Length);
                ////        outputStream.Write(buffer, 0, bytesRead);
                ////    } while (bytesRead != 0);
                ////}

                return true;
            }
            else
            {
                return false;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // pictureBox1.Load(@"PackingLabel.png");
            pictureBox1.Image = null;
        }
    }
}

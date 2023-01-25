using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net.Mail;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SmtpClient client = new SmtpClient("smtp.gmail.com", 587);
            client.UseDefaultCredentials = false; 
            client.EnableSsl = true;  
            client.DeliveryMethod = SmtpDeliveryMethod.Network; 
            client.Credentials = new System.Net.NetworkCredential("forwave@nate.com", "!2rlduddlapp");

            MailAddress from = new MailAddress("forwave@nate.com", "이기영", System.Text.Encoding.UTF8);
            MailAddress to = new MailAddress("kiyoung.lee@bizentro.com");

            MailMessage message = new MailMessage(from, to);

            message.Body = "This is a test e-mail message sent by an application. ";
            string someArrows = new string(new char[] { '\u2190', '\u2191', '\u2192', '\u2193' });
            message.Body += Environment.NewLine + someArrows;
            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.Subject = "test message 2" + someArrows;
            message.SubjectEncoding = System.Text.Encoding.UTF8;

            try
            {
                // 동기로 메일을 보낸다.
                client.Send(message);

                // Clean up.
                message.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }
    }
}

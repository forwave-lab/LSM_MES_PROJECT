using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace fade_out_message
{
    public partial class MsgForm : Form
    {
        public MsgForm(string title, string contents, int myHeight, int myWidth, int parentX, int parentY)
        {
            InitializeComponent();
            this.FormBorderStyle = FormBorderStyle.None;
            this.StartPosition = FormStartPosition.Manual;

            this.Location = new Point(parentX, parentY + (myHeight - this.Height));

            this.Width = myWidth;
            label1.Text = title;
            label2.Text = contents;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            MessageFadeOut();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (this.Opacity > 0.01)
                this.Opacity = this.Opacity - 0.01;//f;
            else
                this.Close();
        }

        public void Delay(int ms)
        {
            DateTime dateTimeNow = DateTime.Now;
            TimeSpan duration = new TimeSpan(0, 0, 0, 0, ms);
            DateTime dateTimeAdd = dateTimeNow.Add(duration);
            while (dateTimeAdd >= dateTimeNow)
            {
                System.Windows.Forms.Application.DoEvents();
                dateTimeNow = DateTime.Now;
            }

        }

        private void MessageFadeOut()
        {
            //Fade003: Cancel Form close action 
            //when the opacity is more than 1%.
            if (this.Opacity > 0.01f)
            {
                timer1.Interval = 20;
                timer1.Enabled = true;
            }
            else
            {
                timer1.Enabled = false;
            }
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Click(object sender, EventArgs e)
        {
            Opacity = 0.00;
        }
    }
}

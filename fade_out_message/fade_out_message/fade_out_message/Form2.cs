using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace fade_out_message
{
    public partial class Form2 : Form
    {
        public static Form2 MainForm;

        public Form2()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            MainForm = this;
            fadeclass fc = new fadeclass();
            fc.fadeMsg(MainForm);
        }
    }
}

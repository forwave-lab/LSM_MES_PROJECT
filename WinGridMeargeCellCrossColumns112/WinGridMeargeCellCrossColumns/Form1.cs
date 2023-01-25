using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WinGridMeargeCellCrossColumns
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
            DataTable table = new DataTable();
            for (int i = 0; i < 5; i++)
                table.Columns.Add("Coll" + i.ToString(), typeof(string)).DefaultValue = "Text";

            for (int i = 0; i < 5; i++)
                table.Rows.Add();
            Random rmd = new Random();
            ultraGrid1.DataSource = table;
            for(int i =0; i< 5 ;i++)
                ultraGrid1.Rows[i].Cells[rmd.Next(0, 4)].Value = "NoText";
            ultraGrid1.CreationFilter = new MyCreation();
        }

    }
}

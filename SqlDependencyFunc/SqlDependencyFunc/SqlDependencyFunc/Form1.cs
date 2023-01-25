using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Threading.Tasks;

namespace SqlDependencyFunc
{
    public partial class Form1 : Form
    {
        SqlDependency SqlDep;
        SqlConnection SqlCon;

        public Form1()
        {
            InitializeComponent();

            string SqlConect = "Data Source=165.243.102.161,1433;Initial Catalog=UNIMES_TEST;User ID=sa;Password=lsm#erp2021;";
            SqlCon = new SqlConnection(SqlConect);
            SqlCon.Open();
            SqlDependency.Start(SqlConect);
        }

        public void GetLastDBState()
        {
            SqlCommand SqlCom = new SqlCommand(@"Select Lotid from LMSEGMENTRECORD", SqlCon);
            SqlDep = new SqlDependency(SqlCom);

            SqlDep.OnChange += SqlDep_OnChange;
            SqlDataReader Sqldr = SqlCom.ExecuteReader();
            Sqldr.Close();
            
        }

        private void ultraButton1_Click(object sender, EventArgs e)
        {
            GetLastDBState();
        }

        private void SqlDep_OnChange(object sender, SqlNotificationEventArgs e)
        {
            string sLog = string.Format("Type:{0} / Info:{1} / Source:{2}", e.Type.ToString(), e.Info.ToString(), e.Source.ToString());
            Debug.WriteLine(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " " + sLog);
            GetLastDBState();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void ultraButton2_Click(object sender, EventArgs e)
        {
            //SqlDependency.Stop(SqlConect);
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            //SqlDependency.Stop(SqlConect);
        }
    }
}





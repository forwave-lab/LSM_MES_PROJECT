using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Infragistics.UltraChart.Shared.Styles;
using Infragistics.UltraChart.Resources.Appearance;
using Infragistics.UltraChart.Core.Layers;
using Infragistics.Win.UltraWinChart;

namespace steplinechart
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("date", typeof(DateTime));
            dt.Columns.Add("value1", typeof(double));
            dt.Columns.Add("value2", typeof(double));

            dt.Rows.Add(new object[] { DateTime.Now.AddDays(0), 50, 30 });
            dt.Rows.Add(new object[] { DateTime.Now.AddDays(2), 60, 40 });
            dt.Rows.Add(new object[] { DateTime.Now.AddDays(5), 80, 20 });
            dt.Rows.Add(new object[] { DateTime.Now.AddDays(6), 30, 15 });
            dt.Rows.Add(new object[] { DateTime.Now.AddDays(8), 60, 25 });
            dt.Rows.Add(new object[] { DateTime.Now.AddDays(9), 100, 20 });

            ultraChart1.ChartType = ChartType.StepLineChart;
            ultraChart1.Axis.X.TimeAxisStyle.TimeAxisStyle = RulerGenre.Discrete;

            NumericTimeSeries series1 = new NumericTimeSeries();
            series1.Data.DataSource = dt;
            series1.Data.TimeValueColumn = "date";
            series1.Data.ValueColumn = "value1";
            ultraChart1.Series.Add(series1);

            NumericTimeSeries series2 = new NumericTimeSeries();
            series2.Data.DataSource = dt;
            series2.Data.TimeValueColumn = "date";
            series2.Data.ValueColumn = "value2";
            ultraChart1.Series.Add(series2);

            series1.DataBind();
            series2.DataBind();
        }
    }
}

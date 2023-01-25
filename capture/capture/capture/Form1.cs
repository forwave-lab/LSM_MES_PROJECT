using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Imaging;
using Infragistics.Documents.Excel;
using System.Runtime.InteropServices;
using Infragistics.UltraChart.Shared.Styles;
using Infragistics.UltraChart.Resources.Appearance;
using Infragistics.UltraChart.Core.Layers;
using Infragistics.Win.UltraWinChart;
using Infragistics.Win.UltraWinGrid;
using Infragistics.Win;
using Infragistics.Documents.Reports.Report;
using Infragistics.Documents.Reports.Report.Section;
using Infragistics.Win.Printing;


namespace capture
{
    public partial class Form1 : Form
    {
        Boolean Excel_Read_Close = false;
        DataTable HeatRecord = new DataTable("HeatRecord");

        DataTable ddata = new DataTable("defaultdata");

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Bitmap Bitmap;
            Point StartX;
            Point StartY;
            Graphics Graphics;
            if (radioButton1.Checked == true)
            {
                Bitmap = new Bitmap(ultraChart1.Width, ultraChart1.Height);
                Graphics = Graphics.FromImage(Bitmap);

                StartX = PointToScreen(new Point(ultraChart1.Location.X, 0));
                StartY = PointToScreen(new Point(0, ultraChart1.Location.Y));
            }
            else
            {
                Bitmap = new Bitmap(pictureBox1.Width, pictureBox1.Height);
                Graphics = Graphics.FromImage(Bitmap);

                StartX = PointToScreen(new Point(pictureBox1.Location.X, 0));
                StartY = PointToScreen(new Point(0, pictureBox1.Location.Y));
            }

            Graphics.CopyFromScreen(
            StartX.X,
            StartY.Y,
            0,
            0,
            new Size(Bitmap.Width, Bitmap.Height));

            //Bitmap.Save(@"test.bmp", System.Drawing.Imaging.ImageFormat.Bmp);
            Clipboard.SetImage((Image)Bitmap);
        }

        private static string FromStringToDate(string stringDate)
        {
            double date = double.Parse(stringDate);
            string sdate = DateTime.FromOADate(date).ToString("yyyy-MM-dd");
            return sdate;
        }

        private static string FromStringToTime(string stringDate)
        {
            double time = double.Parse(stringDate);
            string stime = DateTime.FromOADate(time).ToString("HH:mm:ss");
            return stime;
        }

        private void ultraButton1_Click(object sender, EventArgs e)
        {
            //List<string> ExcelList = new List<string>();

            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.DefaultExt = "Excel Files";
                openFileDialog.Filter = "Excel Files |*.xls;*.xlsx";
                openFileDialog.Multiselect = false;

                string strFileDir = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
                openFileDialog.InitialDirectory = strFileDir;

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    try
                    {
                        if (openFileDialog.SafeFileName.LastIndexOf(".") > -1)
                        {
                            Workbook workbook = new Workbook();
                            workbook = Workbook.Load(openFileDialog.FileName);
                            
                            Worksheet worksheet = workbook.Worksheets[0];                            

                           // DataTable HeatRecord = new DataTable("HeatRecord");

                            int rowCount = 0;
                            int columnCount = 0;

                            foreach (WorksheetRow worksheetRow in worksheet.Rows)
                            {
                                if (rowCount == 0)
                                {
                                    //foreach (WorksheetCell worksheetCell in worksheetRow.Cells)
                                    //{
                                    //    string cellValue = worksheetCell.Value.ToString().Trim();
                                    //    if (cellValue == string.Empty || cellValue == "$Date")
                                    //    {
                                    //        break;
                                    //    }
                                    //    else
                                    //    {
                                    //        //DataColumn dataColumn = HeatRecord.Columns.Add();
                                    //        //dataColumn.ColumnName = cellValue;
                                    //        //dataColumn.DataType = worksheet.Rows[rowCount + 1].Cells[columnCount].Value.GetType();
                                    //    }
                                    //    //columnCount++;
                                    //}
                                }
                                else
                                {
                                    columnCount = 0;
                                    DataRow HeatRecordRow = HeatRecord.NewRow();
                                    foreach (WorksheetCell worksheetCell in worksheetRow.Cells)
                                    {
                                        if (worksheetCell.Value == null)
                                        {
                                            Excel_Read_Close = true;
                                            break;
                                        }    
                                        else
                                        {
                                            string cellValue = worksheet.Rows[rowCount].Cells[columnCount].Value.ToString().Trim();
                                            if (rowCount == 1)
                                            {
                                                if(columnCount == 0)
                                                {
                                                    DataColumn dataColumn = HeatRecord.Columns.Add("date1", typeof(DateTime));
                                                }
                                                else if(columnCount == 1)
                                                {
                                                    DataColumn dataColumn = HeatRecord.Columns.Add("date2", typeof(DateTime));
                                                }
                                                else if(columnCount == 2)
                                                {
                                                    DataColumn dataColumn = HeatRecord.Columns.Add("value1", typeof(double));
                                                }
                                                else if (columnCount == 3)
                                                {
                                                    DataColumn dataColumn = HeatRecord.Columns.Add("value2", typeof(double));
                                                }
                                                else
                                                {
                                                    DataColumn dataColumn = HeatRecord.Columns.Add();
                                                }
                                                //dataColumn.DataType = worksheet.Rows[rowCount + 1].Cells[columnCount].Value.GetType();
                                                //dataColumn.ColumnName = cellValue;
                                            }

                                            if (columnCount == 0)
                                            {
                                                HeatRecordRow[columnCount] = FromStringToDate(cellValue).ToString();
                                            }
                                            else if (columnCount == 1)
                                            {
                                                HeatRecordRow[columnCount] = FromStringToTime(cellValue).ToString();
                                            }
                                            else
                                            {
                                                HeatRecordRow[columnCount] = Math.Round(double.Parse(cellValue), 2);
                                            }

                                            columnCount++;
                                        }
                                    }
                                    HeatRecord.Rows.Add(HeatRecordRow);  
                                }
                                rowCount++;
                                if (Excel_Read_Close == true)
                                {
                                    break;
                                }
                            }
                            HeatRecord.AcceptChanges();

                           // workbook.Worksheets[0].Rows[0].Cells[0].Value = 42;                            
                        }
                        else
                        {

                        }
                    }
                    catch(Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                    ultraGrid1.DataSource = HeatRecord;
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            ultrachart_initial();
        }

        private void ultrachart_initial()
        {
            DataRow ddataRow = ddata.NewRow();
            DataColumn dataColumn;
            dataColumn = ddata.Columns.Add("date2", typeof(DateTime));
            ddataRow[0] = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            dataColumn = ddata.Columns.Add("value1", typeof(double));
            ddataRow[1] = 0;
            dataColumn = ddata.Columns.Add("value2", typeof(double));
            ddataRow[2] = 0;
            ddata.Rows.Add(ddataRow); 
            ddata.AcceptChanges();

            ultraChart1.ChartType = ChartType.StepLineChart;
            ultraChart1.Axis.X.TimeAxisStyle.TimeAxisStyle = RulerGenre.Discrete;
            ultraChart1.Legend.Visible = false;
            ultraChart1.Data.SwapRowsAndColumns = true; 

            NumericTimeSeries series1 = new NumericTimeSeries();
            series1.Data.DataSource = ddata;
            series1.Data.TimeValueColumn = "date2";
            series1.Data.ValueColumn = "value1";
            ultraChart1.Series.Add(series1);

            NumericTimeSeries series2 = new NumericTimeSeries();
            series2.Data.DataSource = ddata;
            series2.Data.TimeValueColumn = "date2";
            series2.Data.ValueColumn = "value2";
            ultraChart1.Series.Add(series2);

            series1.DataBind();
            series2.DataBind();            
        }

        private void ultraGrid1_InitializeLayout(object sender, Infragistics.Win.UltraWinGrid.InitializeLayoutEventArgs e)
        {
            UltraGridLayout layout = e.Layout;
            UltraGridBand band = layout.Bands[0];
            UltraGridOverride ov = layout.Override;

            ov.WrapHeaderText = DefaultableBoolean.True;
            band.Columns["date2"].Header.Caption = "DateTime" + Environment.NewLine + "Time Only";
        }

        private void ultraButton2_Click(object sender, EventArgs e)
        {
            ultraChart1.Series.Clear();
            ultraChart1.ChartType = ChartType.StepLineChart;
            ultraChart1.Axis.X.TimeAxisStyle.TimeAxisStyle = RulerGenre.Discrete;
            ultraChart1.Legend.Visible = false;
            ultraChart1.Data.SwapRowsAndColumns = false; 

            NumericTimeSeries series1 = new NumericTimeSeries();
            series1.Data.DataSource = HeatRecord;
            series1.Data.TimeValueColumn = "date2";
            series1.Data.ValueColumn = "value1";
            ultraChart1.Series.Add(series1);

            NumericTimeSeries series2 = new NumericTimeSeries();
            series2.Data.DataSource = HeatRecord;
            series2.Data.TimeValueColumn = "date2";
            series2.Data.ValueColumn = "value2";
            ultraChart1.Series.Add(series2);

            series1.DataBind();
            series2.DataBind();
        }

        private void ultraButton3_Click(object sender, EventArgs e)
        {
            UltraPrintPreviewDialog a = new UltraPrintPreviewDialog();

            this.ultraPrintPreviewDialog1.Document = this.ultraPrintDocument1;
            this.ultraPrintPreviewDialog1.ShowDialog();
        }

        private void ultraPrintDocument1_PrintPage(object sender, System.Drawing.Printing.PrintPageEventArgs e)
        {
            //System.Drawing.Bitmap memoryImage = new System.Drawing.Bitmap(this.ultraChart1.Width, this.ultraChart1.Height);
            Report report = new Report();
            ISection section = report.AddSection();
            section.PageSize = PageSizes.A4;
            //System.Drawing.Bitmap memoryImage = new System.Drawing.Bitmap(Convert.ToInt32(section.PageSize.Width),Convert.ToInt32(section.PageSize.Height));
            System.Drawing.Bitmap memoryImage = new System.Drawing.Bitmap(this.ultraChart1.Width, this.ultraChart1.Height);
            this.ultraChart1.DrawToBitmap(memoryImage, this.ultraChart1.ClientRectangle);
            //e.Graphics.DrawImage(memoryImage, 20, 20);
            e.Graphics.DrawImage(memoryImage, 20, 50, Convert.ToInt32(section.PageSize.Width) + 200, Convert.ToInt32(section.PageSize.Height) + 200);
        }
    }
}

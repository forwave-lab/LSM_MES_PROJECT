using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace fade_out_message
{
    class fadeclass
    {
        public void fadeMsg(Form2 MainForm)
        {
            MsgForm MsgForm = new MsgForm("title", "contents", MainForm.Height, MainForm.Width, MainForm.Location.X, MainForm.Location.Y);
            MsgForm.ShowDialog();
        }
    }
}

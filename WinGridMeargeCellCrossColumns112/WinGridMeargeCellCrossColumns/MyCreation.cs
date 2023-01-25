using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Infragistics.Win;
using Infragistics.Win.UltraWinGrid;
using System.Drawing;
using System.Diagnostics;


namespace WinGridMeargeCellCrossColumns
{
    class MyCreation:IUIElementCreationFilter
    {
        #region IUIElementCreationFilter Members

        public void AfterCreateChildElements(UIElement parent)
        {
            RowCellAreaUIElement row = parent as RowCellAreaUIElement;
            if (row != null && row.HasChildElements)
            {
                List<CellUIElement> remcell = new List<CellUIElement>();
                CellUIElement cell = (CellUIElement)row.ChildElements[0];
               
                    //for (int i = 1; i < row.ChildElements.Count; i++)
                    for (int i = 1; i < 2; i++) //1번 컬럼, 2번 컬럼만 병합처럼 표현한다.
                    {
                        if (!(row.ChildElements[i] is CellUIElement))
                            continue;
                        CellUIElement nextCell = (CellUIElement)row.ChildElements[i];
                        if (cell.Cell.Value.ToString() == nextCell.Cell.Value.ToString()) //1번, 2번 데이타를 같게 만들어서 처리해야한다. 계획정지, 비가동은 병합되면 안된다.
                        {
                            Size s = cell.Rect.Size;
                            s.Width += nextCell.Rect.Width;
                            cell.Rect = new Rectangle(cell.Rect.Location, s);
                            nextCell.Rect = new Rectangle(0, 0, 0, 0);
                            remcell.Add(nextCell);
                        }
                        else
                        {
                            cell = nextCell;
                        }
                    }
                    foreach (CellUIElement rc in remcell)
                        row.ChildElements.Remove(rc);
            }
        }

        public bool BeforeCreateChildElements(UIElement parent)
        {
            return false;//throw new NotImplementedException();
        }

        #endregion
    }
}

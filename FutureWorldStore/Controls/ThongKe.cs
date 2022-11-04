using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class ThongKe
    {
        DBMain db = null!;
        private string view = " v_infHoaDon";
        string str;
        public ThongKe()
        {
            db = new DBMain();
        }
        public DataSet ThongKeDoanhThu()
        {
            str = "execute pr_thongKeTongDoanhThu";
            return db.ExecuteQueryDataSet(str, CommandType.Text);
        }
    }

}

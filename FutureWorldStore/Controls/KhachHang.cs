using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class KhachHang
    {
        DBMain db = null!;
        private string view = " v_infkhachhang";
        public KhachHang()
        {
            db = new DBMain();
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public bool Add(string idKH, string tenKH, string sdt, ref string err)
        {
            string sqlString = $"exec sp_ReviseKhachHang '{idKH}',N'{tenKH}','{sdt}','{0}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idKH, string tenKH, string sdt,string diemThuong, ref string err)
        {
            string sqlString = $"exec sp_ReviseKhachHang '{idKH}',N'{tenKH}','{sdt}','','Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idKH, ref string err)
        {
            string sqlString = $"exec sp_deleteKhachHang '{idKH}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idKH, string tenKH, string sdt, string diemThuong, ref string err)
        {

            string sqlString = $"select * from KhachHang Where    ";
            if (idKH != "")
                sqlString += $"idKH = '{idKH}' and ";
            if (sdt != "")
                sqlString += $"sdt = N'{sdt}' and ";
            if (tenKH != "")
                sqlString += $"tenKH = '{tenKH}' and ";
            if (diemThuong.ToString() != "")
                sqlString += $"status = {diemThuong} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}

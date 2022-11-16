using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class KhachHang
    {
        DBMain db = null!;
        private string view = " v_infkhachhang";
       /* public KhachHang()
        {
            db = new DBMain();
        }*/
        public KhachHang(string role)
        {
            db = new DBMain(role);
        }

        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }
        public DataSet GetIdKH()
        {
            return db.ExecuteQueryDataSet($"SELECT * from Khachhang", CommandType.Text);
        }
        public bool Add(string idKH, string tenKH, string sdt, ref string err)
        {
            string sqlString = $"exec sp_ReviseKhachHang '{idKH}',N'{tenKH}','{sdt}','{0}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }

        public bool AddKH(string tenKH, string sdt, ref string err)
        {
            string sqlString = $"insert into KHACHHANG(tenKH,sdt) values (N'{tenKH}','{sdt}')";
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

        public DataSet SearchSDT( string sdt)
        {
            return db.ExecuteQueryDataSet($"select * from fn_khachhang_sdt('{sdt}')", CommandType.Text);
        }

        public bool SearchKH(string sdt, ref string err)
        {
            return db.MyExecuteNonQuery($"select tenKH from fn_khachhang_sdt('{sdt}')", CommandType.Text, ref err);

        }

    }
}

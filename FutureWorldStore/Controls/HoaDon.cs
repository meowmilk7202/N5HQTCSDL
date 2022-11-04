using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace FutureWorldStore.Controls
{
    class HoaDon
    {
        DBMain db = null!;
        private string view = " v_infHoaDon";
        private string view2 = " sp_thongKeTongDoanhThu";
        public HoaDon()
        {
            db = new DBMain();
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public DataSet GetDT()
        {
            return db.ExecuteQueryDataSet($"exec {view2}", CommandType.Text);
        }
        public bool Add(string idHoaDon, string idNV, string idKH, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseHoaDon '{idHoaDon}','{idNV}',N'{idKH}',{status},'Insert'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idHoaDon, string idNV, string idKH, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseHoaDon '{idHoaDon}','{idNV}',N'{idKH}',{status},'Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idHoaDon, ref string err)
        {
            string sqlString = $"exec sp_deleteHoaDon '{idHoaDon}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idHoaDon, string idNV, string idKH, string status, ref string err)
        {

            string sqlString = $"select * from HoaDon Where    ";
            if (idHoaDon != "")
                sqlString += $"idHoaDon = '{idHoaDon}' and ";
            if (idKH != "")
                sqlString += $"idKH = N'{idKH}' and ";
            if (idNV != "")
                sqlString += $"idNV = '{idNV}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}


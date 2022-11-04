using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class ChiTietHoaDon
    {
        DBMain db = null!;
        private string view = " v_infChiTietHoaDon";
        public ChiTietHoaDon()
        {
            db = new DBMain();
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public bool Add(string idChiTietHoaDon, string idHoaDon, string idDienThoai, string soLuong, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseChiTietHoaDon '{idChiTietHoaDon}','{idHoaDon}',N'{idDienThoai}',N'{soLuong}',{status},'Insert'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idChiTietHoaDon, string idHoaDon, string idDienThoai, string soLuong, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseChiTietHoaDon '{idChiTietHoaDon}','{idHoaDon}',N'{idDienThoai}',N'{soLuong}',{status},'Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idChiTietHoaDon, ref string err)
        {
            string sqlString = $"exec sp_deleteChiTietHoaDon '{idChiTietHoaDon}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idChiTietHoaDon, string idHoaDon, string idDienThoai, string soLuong, string status, ref string err)
        {

            string sqlString = $"select * from ChiTietHoaDon Where    ";
            if (idChiTietHoaDon != "")
                sqlString += $"idChiTietHoaDon = '{idChiTietHoaDon}' and ";
            if (idDienThoai != "")
                sqlString += $"idDienThoai = N'{idDienThoai}' and ";
            if (idHoaDon != "")
                sqlString += $"idHoaDon = '{idHoaDon}' and ";
            if (soLuong != "")
                sqlString += $"soLuong = N'{soLuong}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}

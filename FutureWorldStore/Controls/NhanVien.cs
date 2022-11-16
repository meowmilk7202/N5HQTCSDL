using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{


    class NhanVien
    {
        DBMain db = null!;
        private string view = " v_infNhanVien";
        private string statemantype = "Update";
       /* public NhanVien()
        {
            db = new DBMain();
        }*/
        public NhanVien(string role)
        {
            db = new DBMain(role);
        }

        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public bool Add(string idNV, string tenNV, string username, string password, string sdt, string email, string phanquyen, string status, ref string err)
        {
            string sqlString = $"exec sp_reviseNhanVien '{idNV}',N'{tenNV}','{username}','{password}','{sdt}','{email}','{phanquyen}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idNV, string tenNV, string username, string password, string sdt, string email, string phanquyen, string status, ref string err)
        {
            string sqlString = $"exec sp_reviseNhanVien '{idNV}',N'{tenNV}','{username}','{password}','{sdt}','{email}','{phanquyen}','{status}','{statemantype}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idNV, ref string err)
        {
            string sqlString = $"exec sp_DeleteNhanVien '{idNV}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idNV, string tenNV, string username, string password, string sdt, string email, string phanquyen, string status, ref string err)
        {

            string sqlString = $"select * from NhanVien Where    ";
            if (idNV != "")
                sqlString += $"idNV = '{idNV}' and ";
            if (tenNV != "")
                sqlString += $"tenNV = N'{tenNV}' and ";
            if (username != "")
                sqlString += $"username = '{username}' and ";
            if (password != "")
                sqlString += $"password = '{password}' and ";
            if (sdt != "")
                sqlString += $"sdt = N'{sdt}' and ";
            if (email != "")
                sqlString += $"email = '{email}' and ";
            if (phanquyen != "")
                sqlString += $"phanQuyen = '{phanquyen}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}

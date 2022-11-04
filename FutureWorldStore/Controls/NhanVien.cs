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
        private string tableName = "NHANVIEN";
        string statemantype = "Update";
        public NhanVien()
        {
            db = new DBMain();
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }
        public bool Add(string idNV, string tenNV, string username, string password, string sdt, string email, int phanquyen, int status, ref string err)
        {
            string sqlString = $"exec sp_reviseNhanVien '{idNV}',N'{tenNV}','{username}','{password}','{sdt}','{email}','{phanquyen}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idNV, string tenNV, string username, string password, string sdt, string email, int phanquyen, int status, ref string err)
        {
            string sqlString = $"exec sp_reviseNhanVien '{idNV}',N'{tenNV}','{username}','{password}','{sdt}','{email}','{phanquyen}','{status}','{statemantype}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idNV, ref string err)
        {
            string sqlString = $"exec sp_DeleteNhanVien '{idNV}";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
    }
}

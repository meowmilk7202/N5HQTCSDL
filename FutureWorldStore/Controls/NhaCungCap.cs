using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class NhaCungCap
    {
        DBMain db = null!;
        private string view = " v_infNhaCungCap";
       /* public NhaCungCap()
        {
            db = new DBMain();
        }*/
        public NhaCungCap(string role)
        {
            db = new DBMain(role);
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }
        public bool Add(string idNCC, string tenNCC, string sdt, string email, string diaChi, string status , ref string err)
        {
            string sqlString = $"exec sp_reviseNCC '{idNCC}',N'{tenNCC}','{sdt}','{email}',N'{diaChi}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idNCC, string tenNCC, string sdt, string email, string diaChi, string status, ref string err)
        {
            string sqlString = $"exec sp_reviseNCC '{idNCC}','{tenNCC}',N'{sdt}',N'{email}','{diaChi}','{status}','Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idNCC, ref string err)
        {
            string sqlString = $"exec sp_deleteNCC '{idNCC}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idNCC, string tenNCC, string sdt, string email, string diaChi, string status, ref string err)
        {

            string sqlString = $"select * from DIENTHOAI Where ";
            if (idNCC != "")
                sqlString += $"idNCC = '{idNCC}' and ";
            if (tenNCC != "")
                sqlString += $"tenNCC = N'{tenNCC}' and ";
            if (sdt != "")
                sqlString += $"sdt = N'{sdt}' and ";
            if (email != "")
                sqlString += $"email = '{email}' and ";
            if (diaChi != "")
                sqlString += $"diachi = '{diaChi}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }

    }
}

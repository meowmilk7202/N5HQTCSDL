using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FutureWorldStore.Models;

namespace FutureWorldStore.Controls
{
    class HangDienThoai
    {
        DBMain db = null!;
        public HangDienThoai()
        {
            db = new DBMain();
        }
        private string view = "v_infHangDT";


        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public DataSet GetName()
        {
            return db.ExecuteQueryDataSet($"select distinct tenHangDT, idHangDT from {view}", CommandType.Text);
        }
        public bool Add(string idHangDT, string tenHangDT,  int status, ref string err)
        {
            string sqlString = $"exec sp_ReviseHDT '{idHangDT}','{tenHangDT}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idHangDT, string tenHangDT, int status, ref string err)
        {
            string sqlString = $"exec sp_ReviseHDT '{idHangDT}',N'{tenHangDT}','{status}','Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idDienThoai, string tenDienThoai, int status, ref string err)
        {
            string sqlString = $"select * from HANGDIENTHOAI Where    ";
            if (idDienThoai != "")
                sqlString += $"idDienThoai = '{idDienThoai}' and ";
            if (tenDienThoai != "")
                sqlString += $"tenDienThoai = N'{tenDienThoai}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
        public bool Delete(string idHangDT, ref string err)
        {
            string sqlString = $"exec sp_deleteHDT '{idHangDT}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
    }

}


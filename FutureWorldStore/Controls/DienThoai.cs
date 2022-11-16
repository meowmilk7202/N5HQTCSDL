using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FutureWorldStore.Models;

namespace FutureWorldStore.Controls
{
    class DienThoai
    {
        DBMain db = null!;
        private string view = " v_infdienthoai";
       /* public DienThoai()
        {
            db = new DBMain();
        }*/
        public DienThoai(string role)
        {
            db = new DBMain(role);
        }

        public DataSet GetName()
        {
            return db.ExecuteQueryDataSet($"select distinct tenHangDT, idHangDT from {view}", CommandType.Text);
        }

        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }
        
        public bool Add(string idDienThoai,string idHangDT, string tenDienThoai, string mauSac, string dungLuong,
            string boNho, string soLuong, string giaBan, string khuyenMai ,string status, ref string err)
        {
            string sqlString = $"exec sp_RevisePhone '{idDienThoai}','{idHangDT}',N'{tenDienThoai}',N'{mauSac}','{dungLuong}','{boNho}','{soLuong}','{giaBan}','{khuyenMai}','{status}','Insert'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idDienThoai, string idHangDT, string tenDienThoai, string mauSac, string dungLuong,
            string boNho, string soLuong, string giaBan, string khuyenMai, string status, ref string err)
        {
            string sqlString = $"exec sp_RevisePhone '{idDienThoai}','{idHangDT}',N'{tenDienThoai}',N'{mauSac}','{dungLuong}','{boNho}','{soLuong}','{giaBan}','{khuyenMai}','{status}','Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idDienThoai, ref string err)
        {
            string sqlString = $"exec sp_deletePhone '{idDienThoai}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idDienThoai, string idHangDT, string tenDienThoai, string mauSac, string dungLuong,
            string boNho, string soLuong, string giaBan, string khuyenMai, string status, ref string err)
        {
            //Toàn viết lại
            string sqlString = $"select * from DIENTHOAI Where    ";
            if (idDienThoai != "")
                sqlString += $"idDienThoai = '{idDienThoai}' and ";
            if (tenDienThoai != "")
                sqlString += $"tenDienThoai = N'{tenDienThoai}' and ";
            if (mauSac != "")
                sqlString += $"mauSac = N'{mauSac}' and ";
            if (dungLuong.ToString() != "")
                sqlString += $"dungLuong = '{dungLuong}' and ";
            if (boNho.ToString() != "")
                sqlString += $"boNho = '{boNho}' and ";
            if (soLuong.ToString() != "")
                sqlString += $"soLuong = {soLuong} and ";
            if (giaBan.ToString() != "")
                sqlString += $"giaBan = {giaBan} and ";
            if (khuyenMai.ToString() != "")
                sqlString += $"khuyenmMai = {khuyenMai} and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }

        public DataSet SearchPhone(string tenDT)
        {
            return db.ExecuteQueryDataSet($"select * from fn_SearchPhone('{tenDT}')", CommandType.Text);
        }
    }

}

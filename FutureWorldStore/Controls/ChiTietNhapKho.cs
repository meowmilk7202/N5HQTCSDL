using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    class ChiTietNhapKho
    {
        DBMain db = null!;
        private string view = " v_infChiTietNhapKho";
        public ChiTietNhapKho()
        {
            db = new DBMain();
        }
        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public bool Add(string idChiTietPhieuNK, string idNhapKho, string idDienThoai, string soLuong, string donGiaGoc, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseChiTietNhapKho '{idChiTietPhieuNK}','{idNhapKho}',N'{idDienThoai}', {soLuong}, {donGiaGoc}, {status},'Insert'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idChiTietPhieuNK, string idNhapKho, string idDienThoai, string soLuong, string donGiaGoc, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseChiTietNhapKho '{idChiTietPhieuNK}','{idNhapKho}',N'{idDienThoai}', {soLuong}, {donGiaGoc}, {status},'Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idChiTietPhieuNK, ref string err)
        {
            string sqlString = $"exec sp_deleteChiTietNhapKho '{idChiTietPhieuNK}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idChiTietPhieuNK, string idNhapKho, string idDienThoai, string soLuong, string donGiaGoc, string status, ref string err)
        {

            string sqlString = $"select * from ChiTietNhapKho Where    ";
            if (idChiTietPhieuNK != "")
                sqlString += $"idChiTietPhieuNK = '{idChiTietPhieuNK}' and ";
            if (idDienThoai != "")
                sqlString += $"idDienThoai = N'{idDienThoai}' and ";
            if (idNhapKho != "")
                sqlString += $"idNhapKho = '{idNhapKho}' and ";
            if (soLuong != "")
                sqlString += $"soLuong = {soLuong} and ";
            if (donGiaGoc != "")
                sqlString += $"donGiaGoc = {donGiaGoc} and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}

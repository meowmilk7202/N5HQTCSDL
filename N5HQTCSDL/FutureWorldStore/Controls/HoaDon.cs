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

       /* public HoaDon()
        {
            db = new DBMain();
        }*/
        public HoaDon(string role)
        {
            db = new DBMain(role);
        }

        public DataSet Top1BanChay()
        {
            return db.ExecuteQueryDataSet($"select * from ThongKeTop1BanChay()", CommandType.Text);
        }
        public DataSet ThanhToan(string id)
        {
            return db.ExecuteQueryDataSet($"exec sp_Payment '{id}'", CommandType.Text);
        }
        public DataSet HuyThanhToan(string id)
        {
            return db.ExecuteQueryDataSet($"execute sp_DeleteCTHDforHD '{id}'", CommandType.Text);
        }
        public DataSet LoiNhuanNgay(string date)
        {
            return db.ExecuteQueryDataSet($"select dbo.sp_LoiNhuanThuDuoc('{date}',1)", CommandType.Text);
        }

        public DataSet ThongKeDT(string date)
        {
            return db.ExecuteQueryDataSet($"Select * from fn_TKDTTheoNTN('{date}',1)", CommandType.Text);
        }


        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }
        public DataSet GetDT()
        {
            return db.ExecuteQueryDataSet($"exec {view2}", CommandType.Text);
        }
        public bool Add(string idHoaDon, string idNV, string idKH,string date, ref string err)
        {
            string sqlString = $"exec sp_revise_HoaDon '{idHoaDon}','{idNV}','{idKH}','{date}'";
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
        
        public DataSet Search(string idHoaDon, string idNV, string idKH,string soluong,string giaban,string diem,string Date,string thanhtien, string status, ref string err)
        {

            string sqlString = $"select * from HoaDon Where ";
            if (idHoaDon != "")
                sqlString += $"idHoaDon = '{idHoaDon}' and ";
            if (idNV != "")
                sqlString += $"idNV = N'{idNV}' and ";
            if (idKH != "")
                sqlString += $"idKH = '{idKH}' and ";
            if (soluong != "")
                sqlString += $"soluong = '{soluong}' and ";
            if (giaban != "")
                sqlString += $"tongGiaBan = '{giaban}' and ";
            if (diem != "")
                sqlString += $"diemThuong = '{diem}' and ";
            if (Date != "")
                sqlString += $"ngayLapHoaDon = '{Date}' and ";
            if (thanhtien != "")
                sqlString += $"thanhTien = '{thanhtien}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
        public DataSet SumSoTienBanDuoc(string ngay, int loai)
        {
            return db.ExecuteQueryDataSet($"select dbo.fn_SumSoTienBanDuoc('{ngay}',{loai})", CommandType.Text);
        }

        public DataSet LoiNhuanTucThoi(string ngay, int loai)
        {
            return db.ExecuteQueryDataSet($"select dbo.sp_LoiNhuanTucThoi('{ngay}',{loai})", CommandType.Text);
        }
        
        public DataSet LoiNhuanThuDuoc(string ngay, int loai)
        {
            return db.ExecuteQueryDataSet($"select dbo.sp_LoiNhuanThuDuoc('{ngay}',{loai})", CommandType.Text);
        }

        //TKDTTheoNTN 

        public DataSet TKDTTheoNTN(string ngay, int loai)
        {
            return db.ExecuteQueryDataSet($"Select * from fn_TKDTTheoNTN('{ngay}',{loai})", CommandType.Text);
        }
        //Exec SapXepThongKeTopBanChay
        public DataSet SapXepThongKeTopBanChay()
        {
            return db.ExecuteQueryDataSet($"Exec SapXepThongKeTopBanChay", CommandType.Text);
        }
    }
}


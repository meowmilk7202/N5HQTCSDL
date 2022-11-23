﻿using FutureWorldStore.Controls;
using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Library_Manager.BS_Layer
{
    class NhapKho
    {
        DBMain db = null!;
        private string view = " v_infNhapKho";
        /*public NhapKho()
        {
            db = new DBMain();
        }*/
        public NhapKho(string role)
        {
            db = new DBMain(role);
        }

        public DataSet Get()
        {
            return db.ExecuteQueryDataSet($"select * from {view}", CommandType.Text);
        }

        public bool Add(string idNhapKho, string idNhanVien, string idNCC, string ngayNhapKho, string soLuong, string thanhTien, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseNhapKho '{idNhapKho}','{idNhanVien}',N'{idNCC}','{ngayNhapKho}','{soLuong}','{thanhTien}', {status},'Insert'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Update(string idNhapKho, string idNhanVien, string idNCC, string ngayNhapKho, string soLuong, string thanhTien, string status, ref string err)
        {
            string sqlString = $"exec sp_ReviseNhapKho '{idNhapKho}','{idNhanVien}',N'{idNCC}','{ngayNhapKho}','{soLuong}','{thanhTien}', {status},'Update'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public bool Delete(string idNhapKho, ref string err)
        {
            string sqlString = $"exec sp_deleteNhapKho '{idNhapKho}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
        public DataSet Search(string idNhapKho, string idNhanVien, string idNCC,string ngayNhapKho,string soLuong, string thanhTien, string status, ref string err)
        {

            string sqlString = $"select * from NhapKho Where ";
            if (idNhapKho != "")
                sqlString += $"idNhapKho = '{idNhapKho}' and ";
            if (idNhanVien != "")
                sqlString += $"idNV = N'{idNhanVien}' and ";
            if (idNCC != "")
                sqlString += $"idNCC = '{idNCC}' and ";
            if (ngayNhapKho != "")
                sqlString += $"ngayNhapKho = '{ngayNhapKho}' and ";
            if (soLuong != "")
                sqlString += $"tongSoLuong = '{soLuong}' and ";
            if (thanhTien != "")
                sqlString += $"thanhTien = '{thanhTien}' and ";
            if (status.ToString() != "")
                sqlString += $"status = {status} and ";
            sqlString = sqlString.Substring(0, sqlString.Length - 4);
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
        }
    }
}

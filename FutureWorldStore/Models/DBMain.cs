using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace FutureWorldStore.Models
{

    class DBMain
    {

        string ConnStr = @"Data Source=DESKTOP-FTESQMM;Initial Catalog=PMBanDienThoai;User ID=sa;Password=123456";
        //tring ConnStr = "Data Source=DESKTOP-2IK0A0H\\SQLEXPRESS;Initial Catalog=Library_Manager;Integrated Security=True";
        //string ConnStr = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai01;User ID=sa;Password=28072002";
        //string ConnStr = @"Data Source=" + datasource + ";Initial Catalog=" + database + ";Persist Security Info=True;User ID=" + username + ";Password=" + password;
        SqlConnection conn = null!;
        SqlCommand comm = null!;
        SqlDataAdapter da = null!;
        public DBMain()
        {
            conn = new SqlConnection(ConnStr);
            comm = conn.CreateCommand();
        }
        public DataSet ExecuteQueryDataSet(string strSQL, CommandType ct)
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            conn.Open();
            comm.CommandText = strSQL;
            comm.CommandType = ct;
            da = new SqlDataAdapter(comm);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

        public bool MyExecuteNonQuery(string strSQL, CommandType ct, ref string error)
        {
            bool f = false;
            if (conn.State == ConnectionState.Open)
                conn.Close();
            conn.Open();
            comm.CommandText = strSQL;
            comm.CommandType = ct;
            try
            {
                comm.ExecuteNonQuery();
                f = true;
            }
            catch (SqlException ex)
            {
                error = ex.Message;
            }
            finally
            {
                conn.Close();
            }
            return f;
        }
    }
}

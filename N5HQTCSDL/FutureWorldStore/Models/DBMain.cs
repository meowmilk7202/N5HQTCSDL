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

        //string ConnStr = @"Data Source=DESKTOP-6B6U3O1;Initial Catalog=PMBanDienThoai;Integrated Security=True";
        // String ConnStr = "Data Source=DESKTOP-2IK0A0H\\SQLEXPRESS;Initial Catalog=Library_Manager;Integrated Security=True";

        /*string ConnStr = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai;User ID=sa;Password=28072002";
        string connAdmin = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai;User ID=sa;Password=28072002";
        string connSeller = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai;User ID=sa;Password=28072002";*/
        /*     string ConnStr = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai03;User ID=sa;Password=28072002";
             string connAdmin = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai03;User ID=admin1;Password=123";
             string connSeller = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai03;User ID=seller1;Password=123";
     */
        string ConnStr = @"Data Source=QUANGHUY;Initial Catalog=PMBanDienThoai03;User ID=sa;Password=123";
        string connAdmin = @"Data Source=QUANGHUY;Initial Catalog=PMBanDienThoai03;User ID=admin1;Password=123";
        string connSeller = @"Data Source=QUANGHUY;Initial Catalog=PMBanDienThoai03;User ID=seller1;Password=123";

        /*string ConnStr = @"Data Source=DESKTOP-AM54MG4\HOANGTOAN;Initial Catalog=PMBanDienThoai03;User ID=sa;Password=123";
        string connAdmin = @"Data Source=DESKTOP-AM54MG4\HOANGTOAN;Initial Catalog=PMBanDienThoai03;User ID=admin1;Password=123";
        string connSeller = @"Data Source=DESKTOP-AM54MG4\HOANGTOAN;Initial Catalog=PMBanDienThoai03;User ID=seller1;Password=123";
        *///string ConnStr = @"Data Source=CONG-THANH-DESK\SQLEXPRESS;Initial Catalog=PMBanDienThoai02;User ID=sa;Password=28072002";
        SqlConnection conn = null!;
        SqlCommand comm = null!;
        SqlDataAdapter da = null!;
        public DBMain()
        {
            conn = new SqlConnection(ConnStr);
            comm = conn.CreateCommand();
        }
        public DBMain(string role)
        {
            conn = role == "1" ? new SqlConnection(connAdmin) : new SqlConnection(connSeller);
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

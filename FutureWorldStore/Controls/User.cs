using FutureWorldStore.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureWorldStore.Controls
{
    public class User
    {
        DBMain db = new DBMain();
        private string idUser;
        private string username;
        private string password;
        private string name;
        private string phanQuyen;

        public string Username { get => username; set => username = value; }
        public string Password { get => password; set => password = value; }
        public string Name { get => name; set => name = value; }
        public string PhanQuyen { get => phanQuyen; set => phanQuyen = value; }
        public string IdUser { get => idUser; set => idUser = value; }

        public User() { }
        public bool Login()
        {
            string sqlString = $"select * from fn_Login('{Username}','{Password}')";
            DataSet ds = this.db.ExecuteQueryDataSet(sqlString, CommandType.Text);
            DataTable dt = ds.Tables[0];
            if (dt.Rows.Count >= 1)
            {
                this.idUser = dt.Rows[0]["idNV"].ToString();
                this.name = dt.Rows[0]["tenNV"].ToString();
                this.phanQuyen = dt.Rows[0]["phanQuyen"].ToString();
                return true;
            }
            else
            {
                return false;
            }
        }
        public bool Change_Pass(string Username, string Pass_word, string new_password, string Re_Password, ref string err)
        {
            string sqlString = $"exec sp_Changepassword '{Username}','{Pass_word}','{new_password}','{Re_Password}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
    }
}

/*using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FutureWorldStore.Models;
using System.Data;
namespace FutureWorldStore.Controls
{
    class AuthenticationSystem
    {
        DBMain db = null!;
        //private string tableName = "NHANVIEN";
        public AuthenticationSystem()
        {
            db = new DBMain();
        }
        public DataSet Login(string Username, string Pass_word, ref string err)
        {
            string sqlString = $"select * from fn_Login ('{Username}','{Pass_word}')";
            return db.ExecuteQueryDataSet(sqlString, CommandType.Text);
            
        }
        public bool Change_Pass(string Username, string Pass_word, string new_password, string Re_Password, ref string err)
        {
            string sqlString = $"exec sp_Changepassword '{Username}','{Pass_word}','{new_password}','{Re_Password}'";
            return db.MyExecuteNonQuery(sqlString, CommandType.Text, ref err);
        }
    }
}
*/
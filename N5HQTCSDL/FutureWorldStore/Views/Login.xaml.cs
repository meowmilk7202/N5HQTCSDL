using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Data;
using FutureWorldStore.Controls;
namespace FutureWorldStore.Views
{
    /// <summary>
    /// Interaction logic for Login.xaml
    /// </summary>
    public partial class Login : Window
    {
        private FutureWorldStore.Views.Home homeWindow = null!;
        private string err = null!;
        protected string role = null!;
        User user = new User();

        public Login()
        {
            InitializeComponent();
            BG.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\Login1.png"))));
        }
        #region Xử lý
        private void txtUsername_GotFocus(object sender, RoutedEventArgs e)
        {
            txtUsername.Clear();
            if (this.txtPassword.Password == "")
                this.txtPassword.Password = "      ";
        }
        #endregion
        private void txtPassword_GotFocus(object sender, RoutedEventArgs e)
        {
            txtPassword.Clear();
            if (this.txtUsername.Text == "")
                this.txtUsername.Text = "Tên tài khoản";
        }

        private void btnClose_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        // btn login chính
        private void btnLogin_Click(object sender, RoutedEventArgs e)
        {
            user.Username = this.txtUsername.Text.Trim();
            user.Password = this.txtPassword.Password.Trim();

            if (user.Login() == true)
            {
                this.Hide();
                homeWindow = new Home(user);
                homeWindow.Show();
            }
            else
            {
                MessageBox.Show("Đăng nhập thất bại", "", MessageBoxButton.OK);
            }
        }

        // btn chuyển qua trang change password
        private void btnChangePassword_Click(object sender, RoutedEventArgs e)
        {
            BG.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\Change.png"))));
            this.frmChangePassword.Visibility = Visibility.Visible;
            this.frmLogin.Visibility = Visibility.Hidden;
        }

        // btn change password chính
        private void btnLogin_Change_Click(object sender, RoutedEventArgs e)
        {
            user.Username = this.txtUsername_Change.Text.Trim();
            user.Password = this.txtPassword_Change.Password.Trim();
            string new_password = this.txtNewPassword_Change.Password.Trim();
            string re_password = this.txtRePassword_Change.Password.Trim();

            
            if (!user.Login())
            {
                MessageBox.Show("Tài khoản, mật khẩu chưa chính xác");
                return;
            }

            bool res = user.Change_Pass(user.Username, user.Password, new_password, re_password, ref err);

            if (res)
                MessageBox.Show("Đổi mật khẩu thành công");
            else
                MessageBox.Show("Đổi mật khẩu thất bại", "Thông báo", MessageBoxButton.OK);
        }

        // btn chuyển qua trang login
        private void btnChangePassword_Change_Click(object sender, RoutedEventArgs e)
        {
            BG.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\Login1.png"))));
            this.frmChangePassword.Visibility = Visibility.Hidden;
            this.frmLogin.Visibility = Visibility.Visible;
        }

        private void txtUsername_Change_GotFocus(object sender, RoutedEventArgs e)
        {
            this.txtUsername_Change.Clear();
            if (this.txtPassword_Change.Password == "")
                this.txtPassword_Change.Password = "      ";
            if (this.txtRePassword_Change.Password == "")
                this.txtRePassword_Change.Password = "      ";
            if (this.txtNewPassword_Change.Password == "")
                this.txtNewPassword_Change.Password = "      ";
        }

        private void txtPassword_Change_GotFocus(object sender, RoutedEventArgs e)
        {
            this.txtPassword_Change.Clear();
            if (this.txtUsername_Change.Text == "")
                this.txtUsername_Change.Text = "Tên tài khoản";
            if (this.txtRePassword_Change.Password == "")
                this.txtRePassword_Change.Password = "      ";
            if (this.txtNewPassword_Change.Password == "")
                this.txtNewPassword_Change.Password = "      ";
        }

        private void txtRePassword_Change_GotFocus(object sender, RoutedEventArgs e)
        {
            this.txtRePassword_Change.Clear();
            if (this.txtUsername_Change.Text == "")
                this.txtUsername_Change.Text = "Tên tài khoản";
            if (this.txtPassword_Change.Password == "")
                this.txtPassword_Change.Password = "      ";
            if (this.txtNewPassword_Change.Password == "")
                this.txtNewPassword_Change.Password = "      ";
        }

        private void txtNewPassword_Change_GotFocus(object sender, RoutedEventArgs e)
        {
            this.txtNewPassword_Change.Clear();
            if (this.txtUsername_Change.Text == "")
                this.txtUsername_Change.Text = "Tên tài khoản";
            if (this.txtPassword_Change.Password == "")
                this.txtPassword_Change.Password = "      ";
            if (this.txtRePassword_Change.Password == "")
                this.txtRePassword_Change.Password = "      ";
        }
    }
}

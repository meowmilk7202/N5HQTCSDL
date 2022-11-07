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
using System.Windows.Threading;
using System.Data;
using FutureWorldStore.Controls;
using System.Data.SqlClient;
using Library_Manager.BS_Layer;
using System.Reflection;
namespace FutureWorldStore.Views
{
    /// <summary>
    /// Interaction logic for Home.xaml
    /// </summary>
    
    public partial class Home : Window
    {

        private Login loginWindow = null!;
        private string hover_color = "#f7f7f7";

        // Btn switch tab
        private Button btnCaptured = null!;
        private Grid grvTab = null!;
        private DispatcherTimer timer = null!;
        private DienThoai dt = new DienThoai();
        private string err;
        private void dgvTab_Capture_Action(Button btn, Grid grv)
        {
            this.btnCaptured.Background = Brushes.Transparent;
            btn.Background = (SolidColorBrush)new BrushConverter().ConvertFrom(hover_color);
            this.btnCaptured = btn;


            this.grvTab.Visibility = Visibility.Hidden;
            grv.Visibility = Visibility.Visible;
            this.grvTab = grv;
        }

        // Var check
        bool checkAdd = false;
        public Home(Login loginWindow)
        {
            InitializeComponent();
            this.load_firstTab();
            this.loginWindow = loginWindow;
            this.loadTimer();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            string hours = "";
            hours += (DateTime.Now.Hour < 10) ? $"0{DateTime.Now.Hour}:" : $"{DateTime.Now.Hour}:";
            hours += (DateTime.Now.Minute < 10) ? $"0{DateTime.Now.Minute}" : $"{DateTime.Now.Minute}";
            lbHours.Content = hours;
            lbDate.Content = $"{DateTime.Now.DayOfWeek}, {DateTime.Now.Day}/{DateTime.Now.Month}/{DateTime.Now.Year}";
        }


        // private string err = null!;
        private DataTable dataTable = null!;
        private HangDienThoai hangDienThoai = new HangDienThoai();
        private NhaCungCap nhaCungCap = new NhaCungCap();
        private NhapKho nhapKho = new NhapKho();
        private HoaDon hoaDon = new HoaDon();
        private NhanVien nhanVien = new NhanVien();
        private KhachHang khachHang = new KhachHang();
        //private Nha nhaCungCap = new NhaCungCap();

    

        #region Load


        private void loadTimer()
        {
            this.timer_Tick(null!, null!);
            timer = new DispatcherTimer();
            timer.Interval = System.TimeSpan.FromSeconds(1);
            timer.Tick += timer_Tick!;
            timer.Start();
        }
        private void load_firstTab()
        {
            this.btnDienThoai.Background = (SolidColorBrush)new BrushConverter().ConvertFrom(hover_color);
            this.btnCaptured = this.btnDienThoai;
            this.grvTab = this.grvDienThoai;
            this.loadDienThoai();
        }
           


        private void loadDienThoai()
        {
            try
            {
                // Lấy data hiển thị lên DataGridView
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = dt.Get();
                dataTable = ds.Tables[0];
                dgDienThoai.ItemsSource = ds.Tables[0].DefaultView;
                // Lấy data hiển thị lên Combobox
                DataSet dataSet = hangDienThoai.GetName();
                DataTable dtable = dataSet.Tables[0];
                foreach(DataRow dt in dtable.Rows)
                {
                    cbHangDienThoai.Items.Add(dt["idHangDT"].ToString().Trim());
                }    
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadThongKe()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.GetDT();
                dataTable = ds.Tables[0];
                dgThongKe.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadHangDienThoai()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hangDienThoai.Get();
                dataTable = ds.Tables[0];
                dgHangDienThoai.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadNhaCungCap()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhaCungCap.Get();
                dataTable = ds.Tables[0];
                dgNhaCungCap.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadNhapKho()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhapKho.Get();
                dataTable = ds.Tables[0];
                dgNhapKho.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void loadNhanVien()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhanVien.Get();
                dataTable = ds.Tables[0];
                dgNhanVien.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void loadHoaDon()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.Get();
                dataTable = ds.Tables[0];
                dgHoaDon.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }


        private void loadKhachHang()
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = khachHang.Get();
                dataTable = ds.Tables[0];
                dgKhachHang.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        #endregion

        #region Add
        private void addHangDienThoai()
        {
            string idHDT = txtMHDT.Text.Trim();
            string nameHDT = txtHDT.Text.Trim();
            int status = statuss.IsChecked == true ? 1 : 0;
            try
            {
                if (hangDienThoai.Add(idHDT, nameHDT, status, ref err))
                {
                    MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadHangDienThoai();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void addNhaCungCap()
        {
            string idncc = txtidNhaCungCap.Text.Trim();
            string tenNCC = txttenNhaCungCap.Text.Trim();
            string sdtNCC = txtSDTNCC.Text.Trim();
            string emailNCC = txtEmailNCC.Text.Trim();
            string diachiNCC = txtDiaChiNCC.Text.Trim();
            string status = statuss.IsChecked == true ? "1" : "0";
            try
            {
                if (nhaCungCap.Add(idncc, tenNCC, sdtNCC, emailNCC, diachiNCC, status, ref err))
                    MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadNhaCungCap();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void addKhachHang()
        {
            string idKH = txtIdKH.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();

            try
            {
                if (khachHang.Add(idKH,tenKH, sdtKH, ref err))
                    MessageBox.Show("Thêm thành công!", "Khách Hàng", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadKhachHang();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void addDienThoai()
        {

            string idDt = txtIdDienThoai.Text.Trim();
            string idHDT = cbHangDienThoai.SelectionBoxItem.ToString().Trim();
            string nameDT = txtTenDienThoai.Text.Trim();
            string color = txtMauSac.Text.Trim();
            string dungluong = txtDungLuong.Text.Trim();
            string bonho = txtBoNho.Text.Trim();
            string soluong = txtSoLuong.Text.Trim();
            string giaban = txtGiaBan.Text.Trim();
            string khuyenmai = txtKhuyenMai.Text.Trim();
            string status = soluong == "0" ? "0" : "1";
            try
            {
                if (dt.Add(idDt, idHDT, nameDT, color, dungluong, bonho, soluong, giaban, khuyenmai, status, ref err))
                {
                    MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadDienThoai();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void addNhapKho()
        {
            string idNhapKho = txtIdNhapKho.Text.Trim();
            string idNhanVien = txtMaNV.Text.Trim();
            string idNCC = txtMaNCC.Text.Trim();
            string ngayNhapKho = dpkNgayNK.Text.Trim();
            string soLuong = txtTongSoLuong.Text.Trim();
            string thanhTien = txtTienNhapKho.Text.Trim();
            string status = checkboxStatusNhapKho.IsChecked == true ? "1" : "0";
            try
            {
                if (nhapKho.Add(idNhapKho, idNhanVien, idNCC, ngayNhapKho, soLuong, thanhTien,status, ref err))
                    MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadNhaCungCap();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        #endregion

        #region Search
        private void SearchDienThoai()
        {
            string idDt = txtIdDienThoai.Text.Trim();
            string idHDT = cbHangDienThoai.SelectionBoxItem.ToString().Trim();
            string nameDT = txtTenDienThoai.Text.Trim();
            string color = txtMauSac.Text.Trim();
            string dungluong = txtDungLuong.Text.Trim();
            string bonho = txtBoNho.Text.Trim();
            string soluong = txtSoLuong.Text.Trim();
            string giaban = txtGiaBan.Text.Trim();
            string khuyenmai = txtKhuyenMai.Text.Trim();
            string status = soluong == "0" ? "0" : "1";
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = dt.Search(idDt, idHDT, nameDT, color, dungluong, bonho, soluong, giaban, khuyenmai, status, ref err);
                dataTable = ds.Tables[0];
                dgDienThoai.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void searchHangDienThoai()
        {
            string idDt = txtMHDT.Text.Trim();
            string idHDT = txtHDT.Text.Trim();
            int status = statuss.IsChecked == true ? 1 : 0;

            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hangDienThoai.Search(idDt, idHDT, status, ref err);
                dataTable = ds.Tables[0];
                dgHangDienThoai.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void searchNhaCungCap()
        {
            string idNCC = txtidNhaCungCap.Text.Trim();
            string tenNCC = txttenNhaCungCap.Text.Trim();
            string sdt = txtSDTNCC.Text.Trim();
            string email = txtEmailNCC.Text.Trim();
            string diaChi = txtDiaChiNCC.Text.Trim();
            string status = txtStatusNCC.Text.Trim();
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhaCungCap.Search(idNCC, tenNCC, sdt, email, diaChi, status,ref err);
                dataTable = ds.Tables[0];
                dgNhaCungCap.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void searchNhapKho()
        {
            string idNCC = txtidNhaCungCap.Text.Trim();
            string tenNCC = txttenNhaCungCap.Text.Trim();
            string sdt = txtSDTNCC.Text.Trim();
            string email = txtEmailNCC.Text.Trim();
            string diaChi = txtDiaChiNCC.Text.Trim();
            string status = txtStatusNCC.Text.Trim();
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhaCungCap.Search(idNCC, tenNCC, sdt, email, diaChi, status, ref err);
                dataTable = ds.Tables[0];
                dgNhaCungCap.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        #endregion

        #region Edit
        private bool checkID(string id)
        {
            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                if (id == dataTable.Rows[i][0].ToString()!.Trim())
                    return true;
            }
            return false;
        }
        private void EditDienThoai()
        {
            string idDt = txtIdDienThoai.Text.Trim();
            string idHDT = cbHangDienThoai.Text.Trim();
            string nameDT = txtTenDienThoai.Text.Trim();
            string color = txtMauSac.Text.Trim();
            string dungluong = txtDungLuong.Text.Trim();
            string bonho = txtBoNho.Text.Trim();
            string soluong = txtSoLuong.Text.Trim();
            string giaban = txtGiaBan.Text.Trim();
            string khuyenmai = txtKhuyenMai.Text.Trim();
            string status = soluong == "0" ? "0" : "1";
            if (checkID(idDt))
            {

                try
                {
                    if (dt.Update(idDt, idHDT, nameDT, color, dungluong, bonho, soluong, giaban, khuyenmai, status, ref err))
                    {
                        MessageBox.Show("Cập nhật thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                    else
                        MessageBox.Show("Cập nhật thất bại!", "", MessageBoxButton.OK, MessageBoxImage.Error);
                    loadDienThoai();
                }
                catch (Exception ex)
                {
                    err = ex.Message;
                }
            } 
            else
                MessageBox.Show("Sản phẩm không tồn tại!", "Điện Thoại", MessageBoxButton.OK, MessageBoxImage.Information);
        }
        private void EditHangDienThoai()
        {
            string idDt = txtMHDT.Text.Trim();
            string idHDT = txtHDT.Text.Trim();
            int status = statuss.IsChecked == true ? 1 : 0;
            try
            {
                if (hangDienThoai.Update(idDt, idHDT, status, ref err))
                {
                    MessageBox.Show("Cập nhật thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadHangDienThoai();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void EditNhaCungCap()
        {
            string maNCC = txtidNhaCungCap.Text.Trim();
            string tenNCC = txttenNhaCungCap.Text.Trim();
            string sdt = txtSDTNCC.Text.Trim();
            string email = txtEmailNCC.Text.Trim();
            string diaChi = txtDiaChiNCC.Text.Trim();
            string status = txtStatusNCC.Text.Trim();
            try
            {
                if (nhaCungCap.Update(maNCC, tenNCC, sdt, email, diaChi, status, ref err))
                {
                    MessageBox.Show("Cập nhật thành công!", "Khách Hàng", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadNhaCungCap();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void EditNhapKho()
        {

        }
        private void EditKhachHang()
        {
            string idKH = txtIdKH.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();
            //string diemThuong = txtEmailNCC.Text.Trim();
            //string diachiNCC = txtDiaChiNCC.Text.Trim();
            //string status = txtStatusKH.Text.Trim();
            try
            {
                if (khachHang.Update(idKH, tenKH, sdtKH, ref err))
                    MessageBox.Show("Sửa thành công!", "Khách Hàng", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadKhachHang();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void EditHoaDon()
        {

        }
        private void EditNhanVien()
        {

        }
        private void EditThongKe()
        {

        }
        #endregion

        #region Delete
        private void ClearDienThoai()
        {
            txtIdDienThoai.Clear();
            cbHangDienThoai.SelectedIndex = 0;
            txtTenDienThoai.Clear();
            txtMauSac.Clear();
            txtDungLuong.Clear();
            txtBoNho.Clear();
            txtSoLuong.Clear();
            txtGiaBan.Clear();
            txtKhuyenMai.Clear();
        }
        private void ClearHangDienThoai()
        {
            txtMHDT.Clear();
            txtHDT.Clear();
            statuss.IsChecked = false;
        }
        private void ClearNhaCungCap()
        {
            txtidNhaCungCap.Clear();
            txttenNhaCungCap.Clear();
            txtSDTNCC.Clear();
            txtEmailNCC.Clear();
            txtDiaChiNCC.Clear();
            txtStatusNCC.Clear();
        }
        private void ClearNhapKho()
        {
            txtidNhaCungCap.Clear();
            txttenNhaCungCap.Clear();
            txtSDTNCC.Clear();
            txtEmailNCC.Clear();
            txtDiaChiNCC.Clear();
            txtStatusNCC.Clear();
        }


        //ClearKhachHang

        private void ClearKhachHang()
        {
            txtIdKH.Clear();
            txtTenKH.Clear();
            statuss.Focusable = false;
        }
        private void DeleteDienThoai()
        {
            string idDt = txtIdDienThoai.Text.Trim();
            try
            {
                if (dt.Delete(idDt, ref err))
                {
                    MessageBox.Show("Xóa thành công!", "Điện Thoại", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadDienThoai();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void DeleteHangDienThoai()
        {
            string idHDt = txtMHDT.Text.Trim();
            try
            {
                if (hangDienThoai.Delete(idHDt, ref err))
                {
                    MessageBox.Show("Xóa thành công!", "Hãng Điện Thoại", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadHangDienThoai();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void DeleteNhaCungCap()
        {
            string idNCC = txtidNhaCungCap.Text.Trim();
            try
            {
                if (nhaCungCap.Delete(idNCC, ref err))
                {
                    MessageBox.Show("Xóa thành công!", "Nhà Cung Cấp", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadNhaCungCap();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void DeleteNhapKho()
        {
            string idNhapKho = txtIdNhapKho.Text.Trim();
            try
            {
                if (nhapKho.Delete(idNhapKho, ref err))

                {
                    MessageBox.Show("Xóa thành công!", "Nhà Cung Cấp", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadNhapKho();
            }
            catch(Exception ex)
            {
                err = ex.Message;
            }
        }
        //DeleteKhachHang
        private void DeleteKhachHang()
        {
            string idKH = txtIdKH.Text.Trim();
            try
            {
                if (khachHang.Delete(idKH, ref err))
                {
                    MessageBox.Show("Xóa thành công!", "Khách Hàng", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadKhachHang();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        #endregion

        #region Btn
        private void btnDienThoai_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnDienThoai, grvDienThoai);
            this.loadDienThoai();
        }

        private void btnNhanVien_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnNhanVien, grvNhanVien);
            this.loadNhanVien();
        }

        private void btnThongKe_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnThongKe, grvThongKeDT);
            this.loadThongKe();
        }
        private void btnHangDienThoai_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnHangDienThoai, grvHangDienThoai);
            this.loadHangDienThoai();
        }

        private void btnNhaCungCap_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnNhaCungCap, grvNhaCungCap);
            this.loadNhaCungCap();
        }

        private void btnNhapKho_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnNhapKho, grvNhapKho);
            this.loadNhapKho();
        }

        private void btnInHoaDon_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btnHoaDon_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnHoaDon, grvHoaDon);
            this.loadHoaDon();
        }


        private void btnKhachHang_Click(object sender, RoutedEventArgs e)
        {
            dgvTab_Capture_Action(btnKhachHang, grvKhachHang);
            this.loadKhachHang();
        }
        private void btnAdd_Click(object sender, RoutedEventArgs e)
        {

            if (grvDienThoai.Visibility == Visibility.Visible)
            {
                if (!checkAdd)
                {
                    txtIdDienThoai.Visibility = Visibility.Visible;
                    lblIdDT.Visibility = Visibility.Visible;
                    checkAdd = true;
                }
                else
                {
                    addDienThoai();
                    checkAdd = false;
                    txtIdDienThoai.Visibility = Visibility.Hidden;
                    lblIdDT.Visibility = Visibility.Hidden;
                }
            }

            if (grvHangDienThoai.Visibility == Visibility.Visible)
                addHangDienThoai();

            if (grvNhaCungCap.Visibility == Visibility.Visible)
                addNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                addNhapKho();

            if (grvKhachHang.Visibility == Visibility.Visible)
                addKhachHang();

        }
        private void btnReload_Click(object sender, RoutedEventArgs e)
        {
            if (grvDienThoai.Visibility == Visibility.Visible)
                this.loadDienThoai();
            if (grvHangDienThoai.Visibility == Visibility.Visible)
                this.loadHangDienThoai();
            if (grvNhaCungCap.Visibility == Visibility.Visible)
                this.loadNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                this.loadNhapKho();
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.loadNhanVien();
            if (grvKhachHang.Visibility == Visibility.Visible)
                this.loadKhachHang();
            if (grvThongKeDT.Visibility == Visibility.Visible)
                this.loadThongKe();
            if (grvHoaDon.Visibility == Visibility.Visible)
                this.loadHoaDon();
        }

        private void btnClose_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void btnChange_Click(object sender, RoutedEventArgs e)
        {
            if (grvDienThoai.Visibility == Visibility.Visible)
                EditDienThoai();
            if (grvHangDienThoai.Visibility == Visibility.Visible)
                EditHangDienThoai();
            if (grvNhaCungCap.Visibility == Visibility.Visible)
                EditNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                EditNhapKho();
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.loadNhanVien();
            if (grvKhachHang.Visibility == Visibility.Visible)
                this.EditKhachHang();
            if (grvThongKeDT.Visibility == Visibility.Visible)
                this.loadThongKe();
            if (grvHoaDon.Visibility == Visibility.Visible)
                this.loadHoaDon();
        }

        private void btnDelete_Click(object sender, RoutedEventArgs e)
        {
            if (grvDienThoai.Visibility == Visibility.Visible)
                DeleteDienThoai();
            if (grvHangDienThoai.Visibility == Visibility.Visible)
                DeleteHangDienThoai();
            if (grvNhaCungCap.Visibility == Visibility.Visible)
                DeleteNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                DeleteNhapKho();


            if (grvKhachHang.Visibility == Visibility.Visible)
                DeleteKhachHang();

        }

        private void btnClear_Click(object sender, RoutedEventArgs e)
        {
            if (grvDienThoai.Visibility == Visibility.Visible)
                this.ClearDienThoai();
            if (grvHangDienThoai.Visibility == Visibility.Visible)
                this.ClearHangDienThoai();
            if (grvNhaCungCap.Visibility == Visibility.Visible)
                this.ClearNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                this.ClearNhapKho();
            if (grvKhachHang.Visibility == Visibility.Visible)
                this.ClearKhachHang();
        }

        private void btnSearch_Click(object sender, RoutedEventArgs e)
        {
            if (grvDienThoai.Visibility == Visibility.Visible)
                this.SearchDienThoai();
            if (grvHangDienThoai.Visibility == Visibility.Visible)
                this.searchHangDienThoai();
            if (grvNhaCungCap.Visibility == Visibility.Visible)
                this.searchNhaCungCap();
            if (grvNhapKho.Visibility == Visibility.Visible)
                this.searchNhapKho();
        }

        #endregion

        #region SelectionChange
        private void dgDienThoai_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            try
            {
                


                DataRow row = (dgDienThoai.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {

                    cbHangDienThoai.Text = row["idHangDT"].ToString()!.Trim();
                    txtTenDienThoai.Text = row["tenDienThoai"].ToString()!.Trim();
                    txtMauSac.Text = row["mauSac"].ToString()!.Trim();
                    txtDungLuong.Text = row["dungLuong"].ToString()!.Trim();
                    txtBoNho.Text = row["boNho"].ToString()!.Trim();
                    txtSoLuong.Text = row["soLuong"].ToString()!.Trim();
                    txtGiaBan.Text = row["giaBan"].ToString()!.Trim();
                    txtKhuyenMai.Text = row["khuyenMai"].ToString()!.Trim();
                    txtIdDienThoai.Text = row["idDienThoai"].ToString()!.Trim();

                    if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 11" && row["mauSac"].ToString()!.Trim() == "Trắng")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-11-do-1-1-1-org.jpg"))));

                    Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-11-do-1-1-1-org.jpgip11_den.jpg"))));
                    if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 11" && row["mauSac"].ToString()!.Trim() == "Đen")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/ip11_den.jpg"))));
                    else if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 11" && row["mauSac"].ToString()!.Trim() == "Trắng")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-11-trang-1-2-org.jpg"))));
                    else if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 11" && row["mauSac"].ToString()!.Trim() == "Đỏ")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-11-do-1-1-1-org.jpg"))));
                    else if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 12" && row["mauSac"].ToString()!.Trim() == "Đen")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-12-den-1-1-org.jpg"))));
                    else if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 12" && row["mauSac"].ToString()!.Trim() == "Trắng")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-12-trang-1-1-org.jpg"))));
                    else if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 12" && row["mauSac"].ToString()!.Trim() == "Đỏ")
                        Anhhhh.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("F:/CNTT/N3/Ky1/Hệ quản trị CSDL/Finaly_Project/FutureWorldStore/FutureWorldStore/Images/iphone-12-do-1-1-org.jpg"))));


                }
            }
            catch
            {

            }
        }

        private void dgHangDienThoai_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            try
            {
                DataRow row = (dgHangDienThoai.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtMHDT.Text = row["idHangDT"].ToString()!.Trim();
                    txtHDT.Text = row["tenHangDT"].ToString()!.Trim();
                    statuss.IsChecked = row["status"].ToString()!.Trim() == "1" ? true : false;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dgNhaCungCap_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            try
            {
                DataRow row = (dgNhaCungCap.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtidNhaCungCap.Text = row["idNCC"].ToString()!.Trim();
                    txttenNhaCungCap.Text = row["tenNCC"].ToString()!.Trim();
                    txtSDTNCC.Text = row["sdt"].ToString()!.Trim();
                    txtEmailNCC.Text = row["email"].ToString()!.Trim();
                    txtDiaChiNCC.Text = row["diachi"].ToString()!.Trim();
                    txtStatusNCC.Text = row["status"].ToString()!.Trim();
                    //statuss.IsChecked = row["status"].ToString()!.Trim() == "1" ? true : false;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dgKhachHang_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            try
            {
                DataRow row = (dgKhachHang.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtIdKH.Text = row["idKH"].ToString()!.Trim();
                    txtTenKH.Text = row["tenKH"].ToString()!.Trim();
                    txtSoDTKH.Text = row["sdt"].ToString()!.Trim();
                    txtPoint.Text = row["diemThuong"].ToString()!.Trim();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }


        #endregion

        private void cbHangDienThoai_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }
    }


}
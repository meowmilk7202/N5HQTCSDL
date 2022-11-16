using FutureWorldStore.Controls;
using Library_Manager.BS_Layer;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;



using System.Reflection;
using System.IO.Packaging;

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
        
        private string err;
        private void dgvTab_Capture_Action(Button btn, Grid grv)
        {
            this.btnCaptured.Background = Brushes.Transparent;
            btn.Background = (SolidColorBrush)new BrushConverter().ConvertFrom(hover_color);
            this.btnCaptured = btn;

            btnChiTietHoaDon.Visibility = Visibility.Visible;

            this.grvTab.Visibility = Visibility.Hidden;
            grv.Visibility = Visibility.Visible;
            this.grvTab = grv;
            if (grvHoaDon.Visibility == Visibility.Visible)
            {
                btnChiTietHoaDon.Visibility = Visibility.Visible;

            }
            else
                btnChiTietHoaDon.Visibility = Visibility.Hidden;
            if (grvChiTietHoaDon.Visibility == Visibility.Visible)
            {
                btnAdd.Visibility = Visibility.Hidden;
                btnChange.Visibility = Visibility.Hidden;
                btnDelete.Visibility = Visibility.Hidden;
                btnSearch.Visibility = Visibility.Hidden;
                btnClear.Visibility = Visibility.Hidden;
                btnReload.Visibility = Visibility.Hidden;
            }
            else
            {
                btnAdd.Visibility = Visibility.Visible;
                btnChange.Visibility = Visibility.Visible;
                btnDelete.Visibility = Visibility.Visible;
                btnSearch.Visibility = Visibility.Visible;
                btnClear.Visibility = Visibility.Visible;
                btnReload.Visibility = Visibility.Visible;
            }
        }

        // Var check
        bool checkAdd = false;
        private string capDoQuyen;
        User usercurrent = null!;
        public string CapDoQuyen { get => capDoQuyen; set => capDoQuyen = value; }
        public Home(){}
        public Home(User user) : this()
        {
            InitializeComponent();
            this.load_firstTab();
            //truyền user vào bảng
            this.CapDoQuyen = user.PhanQuyen;
            usercurrent = user;
            this.loadTimer();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            string hours = "";
            hours += (DateTime.Now.Hour < 10) ? $"0{DateTime.Now.Hour}:" : $"{DateTime.Now.Hour}:";
            hours += (DateTime.Now.Minute < 10) ? $"0{DateTime.Now.Minute}" : $"{DateTime.Now.Minute}";
            lbHours.Content = hours;
            lbDate_N.Content = $"{DateTime.Now.DayOfWeek}";
            lbDate.Content = $"{DateTime.Now.Day}/{DateTime.Now.Month}/{DateTime.Now.Year}";
        }


        // private string err = null!;
        private DataTable dataTable = null!;
        private DienThoai dt;
        private HangDienThoai hangDienThoai;
        private NhaCungCap nhaCungCap;
        private NhapKho nhapKho;
        private HoaDon hoaDon ;
        private NhanVien nhanVien;
        private KhachHang khachHang;
        private ChiTietHoaDon inhoadon;



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
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\BoderLL_DienThoai.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header2_DienThoai.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\Body3_DienThoai.png"))));
            this.loadDienThoai();
        }
           


        private void loadDienThoai()
        {
            try
            {
                //Khởi tạo biến điện thoại và hãng điện thoại
                hangDienThoai = new HangDienThoai(CapDoQuyen);
                dt = new DienThoai(CapDoQuyen);

                //Xóa danh sách c
                dataTable = new DataTable();
                dataTable.Clear();
                cbHangDienThoai.Items.Clear();

                // Lấy data hiển thị lên DataGridView
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

        private void loadDienThoai(string tenDT)
        {
            try
            {
                //Khởi tạo biến điện thoại
                dt = new DienThoai(CapDoQuyen);

                //Xóa danh sách cũ
                dataTable = new DataTable();
                dataTable.Clear();

                //Hiển thị danh sách datagridview
                DataSet ds = dt.SearchPhone(tenDT);
                dataTable = ds.Tables[0];
                dgThongTinSearch.ItemsSource = ds.Tables[0].DefaultView;
                

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
                hoaDon = new HoaDon(CapDoQuyen);
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
                hangDienThoai = new HangDienThoai(CapDoQuyen);
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
                nhaCungCap = new NhaCungCap(CapDoQuyen);
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

        private void loadDSCTHD(string idHoaDon)
        {
            try
            {
                inhoadon = new ChiTietHoaDon(CapDoQuyen);
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = inhoadon.GetID(idHoaDon);
                dataTable = ds.Tables[0];
                dgDSCTHD.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        
        //Bị lỗi combo box
        private void loadNhapKho()
        {
            try
            {
                //Khở tạo biến nhập kho
                nhapKho = new NhapKho(CapDoQuyen);
                nhanVien = new NhanVien(CapDoQuyen);
                nhaCungCap = new NhaCungCap(CapDoQuyen);
                //Xóa danh sách cũ
                dataTable = new DataTable();
                dataTable.Clear();
                cbxIdNCC.Items.Clear();
                cbxIdNV.Items.Clear();

                // HIển thị danh sách lên datagrivdview
                DataSet ds = nhapKho.Get();
                dataTable = ds.Tables[0];
                dgNhapKho.ItemsSource = ds.Tables[0].DefaultView;

                //Hiển thị danh sách combobox Mã nhân viên
                DataSet dataSet = nhanVien.Get();
                DataTable dtable = dataSet.Tables[0];
                foreach (DataRow dt in dtable.Rows)
                {
                    //cbxIdNV.Items.Add(dt["idNV"].ToString().Trim());
                }

                //Hiển thị danh sách combobox Mã nhà cung cấp
                DataSet dsNcc = nhaCungCap.Get();
                DataTable dtNcc = dsNcc.Tables[0];
                foreach (DataRow dt in dtNcc.Rows)
                {
                    //cbxIdNCC.Items.Add(dt["idNCC"].ToString().Trim());
                }
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
                nhanVien = new NhanVien(CapDoQuyen);
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
                // Khởi tạo các biến
                hoaDon = new HoaDon(CapDoQuyen);
                dataTable = new DataTable();
                nhanVien = new NhanVien(CapDoQuyen);
                khachHang = new KhachHang(CapDoQuyen);
                //Xóa danh sách cũ
                dataTable.Clear();
                cbxNhanVien.Items.Clear();
                cbxKhachHang.Items.Clear();

                //Hiển thị danh sách lên datagrivdview
                DataSet ds = hoaDon.Get();
                dataTable = ds.Tables[0];
                dgHoaDon.ItemsSource = ds.Tables[0].DefaultView;

                //Hiển thị danh sách lên combobox Nhân viên            
                DataSet dsNV = nhanVien.Get();
                DataTable dtNV = dsNV.Tables[0];
                foreach (DataRow dt in dtNV.Rows)
                {
                    //cbxNhanVien.Items.Add(dt["idNV"].ToString().Trim());
                }
                //Hiển thị danh sách combobox Mã Khách hàng
                DataSet dsKH = khachHang.GetIdKH();
                DataTable dtKH = dsKH.Tables[0];
                foreach (DataRow dt in dtKH.Rows)
                {
                    cbxKhachHang.Items.Add(dt["idKH"].ToString().Trim());
                }


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
                khachHang = new KhachHang(CapDoQuyen);
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

        private void LoadTop1()
        {
            try
            {
                hoaDon = new HoaDon(CapDoQuyen);
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.Top1BanChay();
                dataTable = ds.Tables[0];
                dgThongKe.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadInHoaDon()
        {
            try
            {
                inhoadon = new ChiTietHoaDon(CapDoQuyen);
                string idHD = txtIdHoaDon.Text.Trim();
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = inhoadon.GetID(idHD);
                dataTable = ds.Tables[0];
                foreach (DataRow dt in dataTable.Rows)
                {
                    lblTKHCTHD.Content = "Tên khách hàng: " + dt["tenKH"].ToString().Trim();
                    lblSdt.Content = "Số điện thoại: " + dt["sdt"].ToString().Trim();
                    lblNLHD.Content = dt["ngayLapHoaDon"].ToString().Trim();
                    txttenDienThoai.Text += dt["tenDienThoai"].ToString().Trim() + Environment.NewLine;
                    txtMS.Text += dt["mauSac"].ToString().Trim() + Environment.NewLine;
                    txtDL.Text += dt["dungLuong"].ToString().Trim() + Environment.NewLine;
                    txtBN.Text += dt["boNho"].ToString().Trim() + Environment.NewLine;
                    txtSL.Text += dt["soLuong"].ToString().Trim() + Environment.NewLine;
                    txtGia.Text += dt["thanhTien"].ToString().Trim() + "$" + Environment.NewLine;

                }
                dataTable.Clear();
                DataSet ds2 = inhoadon.SumMoneyCTHD(idHD);
                dataTable = ds2.Tables[0];
                foreach (DataRow dt in dataTable.Rows)
                {
                    //MessageBox.Show(dt[0].ToString().Trim());
                    lblSum.Content = dt[0].ToString().Trim() + "$";
                }
                lblID.Content = "Mã hóa đơn: " + idHD;

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
            
            hangDienThoai = new HangDienThoai(CapDoQuyen);
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

            nhaCungCap = new NhaCungCap(CapDoQuyen);
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
        private void addHD()
        {

            DataRow row = (dgThongTinSearch.SelectedItem as DataRowView)?.Row!;
            HoaDon hdon = new HoaDon(CapDoQuyen);
            KhachHang kh = new KhachHang(CapDoQuyen);
            string idhdon = txtIDHoaDon.Text.Trim();
            string idNV = usercurrent.IdUser.Trim();
            dataTable = new DataTable();
            dataTable.Clear();
            DataSet ds = kh.SearchSDT(txtSDTInHD.Text.Trim());
            dataTable = ds.Tables[0];
            string idKH = "";
            foreach (DataRow dt in dataTable.Rows)
            {
                idKH = dt["idKH"].ToString().Trim();
            }
            DateTime dtp = DateTime.Now;



            try
            {

                //Them hoa đơn
                if (hdon.Add(idhdon, idNV, idKH ,dtp.ToString(), ref err)) 
                    MessageBox.Show("Thêm thành công!", "In Hoa Don", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void addCTHD(string idHoanDon)
        {

            DataRow row = (dgThongTinSearch.SelectedItem as DataRowView)?.Row!;
            inhoadon = new ChiTietHoaDon(CapDoQuyen);
            string idDT = row["idDienThoai"].ToString()!.Trim();
            string soLuong = txtSoLuongDT.Text.Trim();
            string giaBan = row["giaBan"].ToString()!.Trim();
            string khuyenMai = row["khuyenMai"].ToString()!.Trim();
            string status = "1";


            try
            {
                //Them chi tiet hoa don
                if (inhoadon.Add(idHoanDon, idDT, soLuong, giaBan, khuyenMai, status, ref err))
                    MessageBox.Show("Thêm thành công!", "In Hoa Don", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadDSCTHD(idHoanDon);
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void addKhachHang()
        {
            khachHang = new KhachHang(CapDoQuyen);
            string idKH = txtIdKH.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();

            try
            {
                if (khachHang.Add(idKH,tenKH, sdtKH, ref err))
                    MessageBox.Show("Thêm thành công!", "Khách Hàng", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                loadKhachHang();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        private void addDienThoai()
        {
            dt = new DienThoai(CapDoQuyen);
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
            nhapKho = new NhapKho(CapDoQuyen);
            string idNhapKho = txtIdNhapKho.Text.Trim();
            //string idNhanVien = txtMaNV.Text.Trim();
            //string idNCC = txtMaNCC.Text.Trim();
            string ngayNhapKho = dpkNgayNK.Text.Trim();
            string soLuong = txtTongSoLuong.Text.Trim();
            string thanhTien = txtTienNhapKho.Text.Trim();
            string status = checkboxStatusNhapKho.IsChecked == true ? "1" : "0";
            try
            {
                if (nhapKho.Add(idNhapKho, " ", " ", ngayNhapKho, soLuong, thanhTien,status, ref err))
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
        private void addNhanVien()
        {
            nhanVien = new NhanVien(CapDoQuyen);
            string idNV = txtIdNV.Text.Trim();
            string tenNV = txtTenNV.Text.Trim();
            string username = txtTenDangNhap.Text.Trim();
            string password = txtPassWord.Text.Trim();
            string sdt = txtsoDTNV.Text.Trim();
            string email = txtemailNV.Text.Trim();
            string phanQuyen = txtPhanQuyenNV.Text.Trim();
            string status = txtStatus.Text.Trim();

            try
            {
                if (nhanVien.Add(idNV, tenNV, username, password, sdt, email, phanQuyen, status, ref err))
                    MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                // Hiển thị lại view ncc
                loadNhanVien();
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
            dt = new DienThoai(CapDoQuyen);
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
            hangDienThoai = new HangDienThoai(CapDoQuyen);
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
            nhaCungCap = new NhaCungCap(CapDoQuyen);
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
            nhaCungCap = new NhaCungCap(CapDoQuyen);
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

        private void searchKhachHang()
        {
            khachHang = new KhachHang(CapDoQuyen);
            string idKH = txtIdKH.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string soDT = txtSoDTKH.Text.Trim();
            string diemThuong = txtPoint.Text.Trim();

            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = khachHang.Search(idKH, tenKH, soDT, diemThuong, ref err);
                dataTable = ds.Tables[0];
                dgKhachHang.ItemsSource = ds.Tables[0].DefaultView;
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
            dt = new DienThoai(CapDoQuyen);
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
            hangDienThoai = new HangDienThoai(CapDoQuyen);
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
            nhaCungCap = new NhaCungCap(CapDoQuyen);
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
            khachHang = new KhachHang(CapDoQuyen);
            string idKH = txtIdKH.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();
            string diemThuong = txtEmailNCC.Text.Trim();
            //string diachiNCC = txtDiaChiNCC.Text.Trim();
            //string status = txtStatusKH.Text.Trim();
            try
            {
                if (khachHang.Update(idKH, tenKH, sdtKH, diemThuong,ref err))
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
            nhanVien = new NhanVien(CapDoQuyen);
            string idNV = txtIdNV.Text.Trim();
            string tenNV = txtTenNV.Text.Trim();
            string username = txtTenDangNhap.Text.Trim();
            string password = txtPassWord.Text.Trim();
            string sdt = txtsoDTNV.Text.Trim();
            string email = txtemailNV.Text.Trim();
            string phanQuyen = txtPhanQuyenNV.Text.Trim();
            string status = txtStatus.Text.Trim();
            try
            {
                if (nhanVien.Update(idNV, tenNV, username, password, sdt, email, phanQuyen, status, ref err))
                  MessageBox.Show("Sửa thành công!", "Nhân viên", MessageBoxButton.OK, MessageBoxImage.Information);
                else
                    MessageBox.Show(err);
                loadNhanVien();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
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
        private void ClearNhanVien()
        {
            txtIdNV.Clear();
            txtTenNV.Clear();
            txtTenDangNhap.Clear();
            txtPassWord.Clear();
            txtsoDTNV.Clear();
            txtemailNV.Clear();
            txtPhanQuyenNV.Clear();
            txtStatus.Clear();
        }


        //ClearKhachHang

        private void ClearKhachHang()
        {
            txtIdKH.Clear();
            txtTenKH.Clear();
            txtSoDTKH.Clear();
            txtPoint.Clear();
            //statuss.Focusable = false;
        }
        private void DeleteDienThoai()
        {
            dt = new DienThoai(CapDoQuyen);
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
            hangDienThoai = new HangDienThoai(CapDoQuyen);
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
            nhaCungCap = new NhaCungCap(CapDoQuyen);
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
            nhapKho = new NhapKho(CapDoQuyen);
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
            khachHang = new KhachHang(CapDoQuyen);
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
        private void DeleteNhanVien()
        {
            nhanVien = new NhanVien(CapDoQuyen);
            string idNV = txtIdNV.Text.Trim();
            try
            {
                if (nhanVien.Delete(idNV, ref err))
                {
                    MessageBox.Show("Xóa thành công!", "Nhân viên", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadNhanVien();
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
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\BoderLL_DienThoai.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header2_DienThoai.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\Body3_DienThoai.png"))));
            this.loadDienThoai();
        }

        private void btnNhanVien_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_Nhanvien.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_nhanvien.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_nhanvien.png"))));
            dgvTab_Capture_Action(btnNhanVien, grvNhanVien);
            this.loadNhanVien();
        }

        private void btnThongKe_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_Thongke1.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_thongke.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_Thongke.png"))));
            dgvTab_Capture_Action(btnThongKe, grvThongKeDT);
            //this.loadThongKe();
            //this.LoadTop1();
        }
        private void btnHangDienThoai_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_HDT.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_HDT.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_HDT.png"))));
            dgvTab_Capture_Action(btnHangDienThoai, grvHangDienThoai);
            this.loadHangDienThoai();
        }

        private void btnNhaCungCap_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_NhaCungCap.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_NhaCungCap.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_NhaCungCap.png"))));
            dgvTab_Capture_Action(btnNhaCungCap, grvNhaCungCap);
            this.loadNhaCungCap();
        }

        private void btnNhapKho_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_NhapKho.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_NhapKho.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_NhapKho.png"))));
            dgvTab_Capture_Action(btnNhapKho, grvNhapKho);
            this.loadNhapKho();
        }

        private void btnInHoaDon_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_Hoadon.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_inhoadon.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_inhoadon.png"))));
            dgvTab_Capture_Action(btnInHoaDon, grvInHoaDon);
        }

        private void btnHoaDon_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\CTHDT1.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header_CTHD.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_hoadon.png"))));
            txttenDienThoai.Text = "";
            txtMS.Text = "";
            txtDL.Text = "";
            txtBN.Text = "";
            txtSL.Text = "";
            txtGia.Text = "";
            dgvTab_Capture_Action(btnHoaDon, grvHoaDon);
            this.loadHoaDon();
        }


        private void btnKhachHang_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_Khachhang.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_Khachhang.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_khachhang.png"))));
            dgvTab_Capture_Action(btnKhachHang, grvKhachHang);
            this.loadKhachHang();
        }
        private void btnAdd_Click(object sender, RoutedEventArgs e)
        {
            khachHang = new KhachHang(CapDoQuyen);
            HoaDon hdon = new HoaDon(CapDoQuyen);          

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
            if (grvNhanVien.Visibility == Visibility.Visible)
                addNhanVien();
            if (grvInHoaDon.Visibility == Visibility.Visible)
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = khachHang.SearchSDT(txtSDTInHD.Text.Trim());
                dataTable = ds.Tables[0];
                string tenKHCheck = "";
                foreach (DataRow dt in dataTable.Rows)
                {
                    tenKHCheck = dt["tenKH"].ToString().Trim();
                }

                string tenKH = txtTenKHInHD.Text.Trim();
                string sdtKH = txtSDTInHD.Text.Trim();
                string idHoaDon = txtIDHoaDon.Text.Trim();


                if (tenKHCheck == "")
                {
                    khachHang.AddKH(tenKH,sdtKH, ref err);
                }
                addHD();
                addCTHD(txtIDHoaDon.Text.Trim());
            }               
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
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.EditNhanVien();
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
            if (grvNhanVien.Visibility == Visibility.Visible)
                DeleteNhanVien();
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
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.ClearNhanVien();
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
            if (grvKhachHang.Visibility == Visibility.Visible)
                this.searchKhachHang();
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

                    /*if (row["tenDienThoai"].ToString()!.Trim() == "IPhone 11" && row["mauSac"].ToString()!.Trim() == "Trắng")
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
*/

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
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

        private void dgNhanVien_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            try
            {
                DataRow row = (dgNhanVien.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtIdNV.Text = row["MaNhanVien"].ToString()!.Trim();
                    txtTenNV.Text = row["TenNV"].ToString()!.Trim();
                    txtTenDangNhap.Text = row["username"].ToString()!.Trim();
                    txtPassWord.Text = row["password"].ToString()!.Trim();
                    txtsoDTNV.Text = row["SoDienThoai"].ToString()!.Trim();
                    txtemailNV.Text = row["email"].ToString()!.Trim();
                    txtPhanQuyenNV.Text = row["phanQuyen"].ToString()!.Trim();
                    txtStatus.Text = row["status"].ToString()!.Trim();

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dgNhapKho_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            //cbxIdNV.ItemsSource = dgNhapKho.SelectedCells;
        }

        private void btnLogOut_Click(object sender, RoutedEventArgs e)
        {
            this.Hide();
            loginWindow = new FutureWorldStore.Views.Login();
            loginWindow.Show();
        }


        //Load top 1 bán chạy 
        private void CheckBox_Checked(object sender, RoutedEventArgs e)
        {
            LoadTop1();
        }
        private void loadLNTN(string date)
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.LoiNhuanNgay(date);
                dataTable = ds.Tables[0];
                dgThongKe.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadDTTN(string date)
        {
            //thồng kê đt bán đc theo ngày
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.ThongKeDT(date);
                dataTable = ds.Tables[0];
                dgThongKe.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void btnCheckDate_Click(object sender, RoutedEventArgs e)
        {

            if(chkTop1BanChay.IsChecked == true)
            {
                LoadTop1();
            }  
            else if(chkLoiNhuanNgay.IsChecked ==true)
            {
                string date = dpkDateOfTK.ToString();
                if(date.Length > 5)
                {
                    loadLNTN(date);
                }
                else
                {
                    MessageBox.Show("Vui lòng chọn ngày!!!", "", MessageBoxButton.OK, MessageBoxImage.Warning);
                }    

            }
            else if(chkDTTheoNgay.IsChecked == true)
            {

                string date = dpkDateOfTK.ToString();
                if (date.Length > 5)
                {
                    loadDTTN(date);
                }
                else
                {
                    MessageBox.Show("Vui lòng chọn ngày!!!", "", MessageBoxButton.OK, MessageBoxImage.Warning);
                }
            }    
        }

        private void cbxThongKeDTNgay_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            
        }

        private void btnInChiTietHoaDon_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\CTHDT1.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header_CTHD.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\ChiTietHoaDonn.png"))));
            dgvTab_Capture_Action(btnHoaDon, grvChiTietHoaDon);
            this.loadInHoaDon();
        }
        private void loadKHSDT(string sdtKH)
        {
            try
            {
                khachHang = new KhachHang(CapDoQuyen);
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = khachHang.SearchSDT(sdtKH);
                dataTable = ds.Tables[0];
                foreach (DataRow dt in dataTable.Rows)
                {
                    txtTenKHInHD.Text = dt["tenKH"].ToString().Trim();
                }

            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }    


        //Tìm điện thoại : In hóa đơn
        private void txtSearchDT_SelectionChanged(object sender, RoutedEventArgs e)
        {
            
            loadDienThoai(txtSearchDT.Text.Trim());
        }

        private void cbxIdNV_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void frmDangNhap_Loaded(object sender, RoutedEventArgs e)
        {
            //lbltenNV.Content = usercurrent.Name.ToString();
        }

        private void Grid_Loaded(object sender, RoutedEventArgs e)
        {
            lbltenNV.Content = "Nhân viên: " + usercurrent.Name.ToString();
        }

        private void btnSearchKHInHD_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                loadKHSDT(txtSDTInHD.Text.Trim());
                khachHang = new KhachHang(CapDoQuyen);
                string tenKH = txtTenKHInHD.Text.Trim();
                string sdtKH = txtSDTInHD.Text.Trim();
                //loadKHSDT(txtSDTInHD.Text.Trim());
                //MessageBox.Show("Khách hàng không tồn tại. Bạn có muốn thêm khách hàng", "Thông Báo", MessageBoxButton.OKCancel);
                if (sdtKH != "" && tenKH == "")
                {
                    MessageBox.Show("Khách hàng không tồn tại. Vui lòng nhập tên KH", "Thông Báo", MessageBoxButton.OK);
                    
                }
                // Co the xu ly lay id Hoa Don moi nhat roi cong 1
                txtIDHoaDon.Text = "HD";
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }


    }
}
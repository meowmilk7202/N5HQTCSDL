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
using static System.Net.Mime.MediaTypeNames;

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
            PhanQuyen();
        }

        // Var check
        bool checkAdd = false;
        private string capDoQuyen;
        private int cohoadon=1;
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
            PhanQuyen();
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

        #region Khai báo
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
        #endregion


        #region Load

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
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
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
                    cbxIdNV.Items.Add(dt["idNV"].ToString().Trim());
                }

                //Hiển thị danh sách combobox Mã nhà cung cấp
                DataSet dsNcc = nhaCungCap.Get();
                DataTable dtNcc = dsNcc.Tables[0];
                foreach (DataRow dt in dtNcc.Rows)
                {
                    cbxIdNCC.Items.Add(dt["idNCC"].ToString().Trim());
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
                    cbxNhanVien.Items.Add(dt["idNV"].ToString().Trim());
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
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadInHoaDon(string idHD)
        {
            try
            {
                inhoadon = new ChiTietHoaDon(CapDoQuyen);
               // string idHD = txtIdHoaDon.Text.Trim();
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
        private void loadLNTN(string date)
        {
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.LoiNhuanNgay(date);
                dataTable = ds.Tables[0];
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
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
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
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
                if(idHDT != "" && nameHDT != "")
                {
                    if (hangDienThoai.Add(idHDT, nameHDT, status, ref err))
                    {
                        MessageBox.Show("Thêm thành công!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                    else
                        MessageBox.Show(err);
                    loadHangDienThoai();
                }
                else
                    MessageBox.Show("ID hoặc Tên Hãng Điện thoại không hợp lệ", "", MessageBoxButton.OK, MessageBoxImage.Information);
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
                hdon.Add(idhdon, idNV, idKH, dtp.ToString(), ref err);
                    //MessageBox.Show("Thêm thành công!", "In Hoa Don", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void addCTHD()
        {

            string idHoanDon = txtIDHoaDon.Text.Trim();
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
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();
            string diemthuong = txtPoint.Text.Trim();
            string status = checkboxStatusKhachHang.IsChecked == true ? "1" : "0";
            try
            {
                if (khachHang.Add(tenKH, sdtKH, diemthuong, status, ref err))
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
            string idNhanVien = cbxIdNV.Text.Trim();
            string idNCC = cbxIdNCC.Text.Trim();
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
                // Hiển thị lại view 
                loadNhapKho();
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
            string idHDT = cbHangDienThoai.Text.Trim();
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
            string idHangDT = txtMHDT.Text.Trim();
            string TenHang = txtHDT.Text.Trim();
            int status = statuss.IsChecked == true ? 1 : 0;

            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hangDienThoai.Search(idHangDT, TenHang, status, ref err);
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
            nhapKho = new NhapKho(CapDoQuyen);
            string idNhapKho = txtIdNhapKho.Text.Trim();
            string idNhanVien = cbxIdNV.Text.Trim();
            string idNCC = cbxIdNCC.Text.Trim();
            string ngayNhapKho = dpkNgayNK.Text.Trim();
            string soLuong = txtTongSoLuong.Text.Trim();
            string thanhTien = txtTienNhapKho.Text.Trim();
            string status = checkboxStatusNhapKho.IsChecked == true ? "1" : "0";
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhapKho.Search(idNhapKho, idNhanVien, idNCC, ngayNhapKho, soLuong, thanhTien,status, ref err);
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
            string idKH = txtIdKhachHang01.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string soDT = txtSoDTKH.Text.Trim();
            string diemThuong = txtPoint.Text.Trim();
            string status = checkboxStatusKhachHang.IsChecked == true ? "1" : "0";
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = khachHang.Search(idKH, tenKH, soDT, diemThuong, status, ref err);
                dataTable = ds.Tables[0];
                dgKhachHang.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        // Search Nhân viên 
        private void searchNhanVien()
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

                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = nhanVien.Search(idNV, tenNV, username, password, sdt, email, phanQuyen, status, ref err);
                dataTable = ds.Tables[0];
                dgKhachHang.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }

        //Search Hoa Don
        private void SearchHoaDon()
        {
            hoaDon = new HoaDon(CapDoQuyen);
            string idHoaDon = txtIdHoaDon.Text.Trim();
            string idNV = cbxNhanVien.Text.Trim();
            string idKH = cbxKhachHang.Text.Trim();
            string soluong = txtsoLuongDT.Text.Trim();
            string giaban = txtTongGiaBanHD.Text.Trim();
            string diem = txtDiemThuong.Text.Trim();
            string Date = DateHoaDon.Text.Trim();
            string thanhtien = txtThanhTien.Text.Trim();
            string status = checkboxStatusKhachHang.IsChecked == true ? "1" : "0";
            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.Search(idHoaDon, idNV, idKH, soluong, giaban, diem, Date, thanhtien,status, ref err);
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
            dt = new DienThoai(capDoQuyen);
            DataSet ds = dt.Get();
            dataTable = ds.Tables[0];
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
            nhapKho = new NhapKho(CapDoQuyen);
            string idNhapKho = txtIdNhapKho.Text.Trim();
            string idNhanVien = cbxIdNV.Text.Trim();
            string idNCC = cbxIdNCC.Text.Trim();
            string ngayNhapKho = dpkNgayNK.Text.Trim();
            string soLuong = txtTongSoLuong.Text.Trim();
            string thanhTien = txtTienNhapKho.Text.Trim();
            string status = checkboxStatusNhapKho.IsChecked == true ? "1" : "0";
            try
            {
                if (nhapKho.Update(idNhapKho, idNhanVien, idNCC, ngayNhapKho, soLuong, thanhTien, status, ref err))
                {
                    MessageBox.Show("Cập nhật thành công!", "Nhập kho", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show(err);
                loadNhapKho();
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
        }
        private void EditKhachHang()
        {
            khachHang = new KhachHang(CapDoQuyen);
            string idKH = txtIdKhachHang01.Text.Trim();
            string tenKH = txtTenKH.Text.Trim();
            string sdtKH = txtSoDTKH.Text.Trim();
            string diemthuong = txtPoint.Text.Trim();
            string status = checkboxStatusKhachHang.IsChecked == true ? "1" : "0";
            try
            {
                if (khachHang.Update(idKH, tenKH, sdtKH, diemthuong, status,ref err))
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

        #region CLear
        private void ClearInHoaDon()
        {
            txtSDTInHD.Clear();
            txtTenKHInHD.Clear();
            txtSoLuongDT.Clear();
            txtIDHoaDon.Clear();
            txtIdNCC2.Clear();
            txtSearchDT.Clear();
           // txtSearchDT.Text = "";
            dgThongTinSearch.ItemsSource = null;
            dgDSCTHD.ItemsSource = null;
        }
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
            txtIdNhapKho.Clear();
            cbxIdNV.SelectedIndex = 0;
            cbxIdNCC.SelectedIndex = 0;
            dpkNgayNK.Text = "";
            txtTongSoLuong.Clear();
            txtTienNhapKho.Clear();
            checkboxStatusNhapKho.IsChecked = false;
           
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
        // Clear Hóa đơn
        private void ClearHoaDon()
        {
            txtIdHoaDon.Clear();
            cbxNhanVien.Text = "";
            cbxKhachHang.Text = "";
            txtsoLuongDT.Clear();
            txtTongGiaBanHD.Clear();
            txtDiemThuong.Clear();
            DateHoaDon.Text = "";
            txtThanhTien.Clear();
        }

        //ClearKhachHang

        private void ClearKhachHang()
        {
            txtTenKH.Clear();
            txtSoDTKH.Clear();
            txtPoint.Clear();
            //statuss.Focusable = false;
        }
        #endregion

        #region delete
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
            string idKH = txtIdKhachHang01.Text.Trim();
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

        private void btnNext_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                cohoadon = 0;
                string id = txtIDHoaDon.Text.Trim();
                HoaDon hd = new HoaDon(capDoQuyen);
                hd.ThanhToan(id);
                GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\CTHDT1.png"))));
                GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header_CTHD.png"))));
                GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\ChiTietHoaDonn.png"))));
                dgvTab_Capture_Action(btnHoaDon, grvChiTietHoaDon);
                this.loadInHoaDon(txtIDHoaDon.Text.Trim());
            }
            catch(Exception ex)
            {
                MessageBox.Show("Không thêm được hóa đơn", "Có lỗi ", MessageBoxButton.OK);
            }
        }

        private void btnHuy_Click(object sender, RoutedEventArgs e)
        {
            string id = txtIDHoaDon.Text.Trim();
            HoaDon hd = new HoaDon(capDoQuyen);
            hd.HuyThanhToan(id);
            MessageBox.Show("Đã hủy hóa đơn", "Thông Báo", MessageBoxButton.OK);
            ClearInHoaDon();
            btnInHoaDon_Click(sender, e);

        }

        private void btnThanhToan_ThanhTien(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Đã thanh toán thành công. Vui lòng nhận hóa đơn", "Thông Báo", MessageBoxButton.OK);
            ClearInHoaDon();
            btnInHoaDon_Click(sender, e);

        }

        private void btnHuyTTHD(object sender, RoutedEventArgs e)
        {
            string id = txtIDHoaDon.Text.Trim();
            HoaDon hd = new HoaDon(capDoQuyen);
            hd.HuyThanhToan(id);
            MessageBox.Show("Đã hủy thanh toán hóa đơn", "Thông Báo", MessageBoxButton.OK);
            ClearInHoaDon();
            btnInHoaDon_Click(sender, e);
        }
        private void btnLogOut_Click(object sender, RoutedEventArgs e)
        {
            this.Hide();
            loginWindow = new FutureWorldStore.Views.Login();
            loginWindow.Show();
        }
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
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\L_TK.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\header_TK.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\Body_Thongke3.png"))));
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
            txttenDienThoai.Text = "";
            txtMS.Text = "";
            txtDL.Text = "";
            txtBN.Text = "";
            txtSL.Text = "";
            txtGia.Text = "";
            ClearInHoaDon();
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
        private void btnInChiTietHoaDon_Click(object sender, RoutedEventArgs e)
        {
            GDTren_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\72ppi\\CTHDT1.png"))));
            GDHeader_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\header_CTHD.png"))));
            GDbody_Border.Background = new ImageBrush(new BitmapImage(new Uri(System.IO.Path.GetFullPath("IMG\\ChiTietHoaDonn.png"))));
            cohoadon = 1;
            dgvTab_Capture_Action(btnHoaDon, grvChiTietHoaDon);
            this.loadInHoaDon(txtIdHoaDon.Text.Trim());
        }
        private void btnAdd_Click(object sender, RoutedEventArgs e)
        {
            khachHang = new KhachHang(CapDoQuyen);
            HoaDon hdon = new HoaDon(CapDoQuyen);

            if (grvDienThoai.Visibility == Visibility.Visible)
                addDienThoai();

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
                addCTHD();
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
            System.Windows.Application.Current.Shutdown();
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
            if (grvKhachHang.Visibility == Visibility.Visible)
                this.EditKhachHang();
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.EditNhanVien();
            if (grvThongKeDT.Visibility == Visibility.Visible)
                this.loadThongKe();
            /*if (grvHoaDon.Visibility == Visibility.Visible)
                this.EditHoaDon();*/

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
            if (grvHoaDon.Visibility == Visibility.Visible)
                this.ClearHoaDon();
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
            if (grvNhanVien.Visibility == Visibility.Visible)
                this.searchNhanVien();
            if (grvHoaDon.Visibility == Visibility.Visible)
                this.SearchHoaDon();
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
                    txtIdKhachHang01.Text = row["idKH"].ToString()!.Trim();
                    txtTenKH.Text = row["tenKH"].ToString()!.Trim();
                    txtSoDTKH.Text = row["sdt"].ToString()!.Trim();
                    txtPoint.Text = row["diemThuong"].ToString()!.Trim();
                    checkboxStatusKhachHang.IsChecked = row["status"].ToString()!.Trim() == "1" ? true : false;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }  
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
                    txtIdNV.Text = row["idNV"].ToString()!.Trim();
                    txtTenNV.Text = row["tenNV"].ToString()!.Trim();
                    txtTenDangNhap.Text = row["username"].ToString()!.Trim();
                    txtPassWord.Text = row["password"].ToString()!.Trim();
                    txtsoDTNV.Text = row["sdt"].ToString()!.Trim();
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
        private void dgNhapKho_SelectedCellsChanged_1(object sender, SelectedCellsChangedEventArgs e)
        {

            try
            {
                DataRow row = (dgNhapKho.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtIdNhapKho.Text = row["idNhapKho"].ToString()!.Trim();
                    cbxIdNV.Text = row["idNV"].ToString()!.Trim();
                    cbxIdNCC.Text = row["idNCC"].ToString()!.Trim();
                    dpkNgayNK.Text = row["ngayNhapKho"].ToString()!.Trim();
                    txtTongSoLuong.Text = row["tongSoLuong"].ToString()!.Trim();
                    txtTienNhapKho.Text = row["thanhTien"].ToString()!.Trim();
                    checkboxStatusNhapKho.IsChecked = row["status"].ToString()!.Trim() == "1" ? true : false;

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void dgHoaDon_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            // idHoaDon, idNV, idKH, soluong, tongGiaBan, diemThuong, ngayLapHoaDon, thanhTien
            try
            {
                DataRow row = (dgHoaDon.SelectedItem as DataRowView)?.Row!;
                if (row != null)
                {
                    txtIdHoaDon.Text = row["idHoaDon"].ToString()!.Trim();
                    cbxNhanVien.Text = row["idNV"].ToString()!.Trim();
                    cbxKhachHang.Text = row["idKH"].ToString()!.Trim();
                    txtsoLuongDT.Text = row["soluong"].ToString()!.Trim();
                    txtTongGiaBanHD.Text = row["tongGiaBan"].ToString()!.Trim();
                    txtDiemThuong.Text = row["diemThuong"].ToString()!.Trim();
                    txtThanhTien.Text = row["thanhTien"].ToString()!.Trim();
                    DateHoaDon.Text = row["ngayLapHoaDon"].ToString()!.Trim();

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void cbxThongKeDTNgay_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            
        }


        #endregion

        #region Xử lý thống kê






        //Tìm điện thoại : In hóa đơn
        private void txtSearchDT_SelectionChanged(object sender, RoutedEventArgs e)
        {
            if(txtSearchDT.Text.Trim() != "")
                loadDienThoai(txtSearchDT.Text.Trim());
            else
            {
                dgThongTinSearch.ItemsSource=null;
            }    

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




        private void chkMonth_Checked(object sender, RoutedEventArgs e)
        {
            chkDay.IsChecked = false;
            chkYear.IsChecked = false;

            hoaDon = new HoaDon(CapDoQuyen);

            dataTable = new DataTable();
            dataTable.Clear();
            DataSet ds = hoaDon.SumSoTienBanDuoc(dpkDateOfTK1.ToString(), 2);
            dataTable = ds.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongLoiNhuan.Content = dt["0"].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds1 = hoaDon.LoiNhuanTucThoi(dpkDateOfTK1.ToString(), 2);
            dataTable = ds1.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDoanhThu.Content = dt[0].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds2 = hoaDon.LoiNhuanThuDuoc(dpkDateOfTK1.ToString(), 2);
            dataTable = ds2.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDTDaKM.Content = dt[0].ToString().Trim();
            }
        }

        private void chkYear_Checked(object sender, RoutedEventArgs e)
        {
            chkDay.IsChecked = false;
            chkMonth.IsChecked = false;

            hoaDon = new HoaDon(CapDoQuyen);

            dataTable = new DataTable();
            dataTable.Clear();
            DataSet ds = hoaDon.SumSoTienBanDuoc(dpkDateOfTK1.ToString(), 3);
            dataTable = ds.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongLoiNhuan.Content = dt["0"].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds1 = hoaDon.LoiNhuanTucThoi(dpkDateOfTK1.ToString(), 3);
            dataTable = ds1.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDoanhThu.Content = dt[0].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds2 = hoaDon.LoiNhuanThuDuoc(dpkDateOfTK1.ToString(), 3);
            dataTable = ds2.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDTDaKM.Content = dt[0].ToString().Trim();
            }
        }

        private void chkDay_Checked_1(object sender, RoutedEventArgs e)
        {

            chkMonth.IsChecked = false;
            chkYear.IsChecked = false;
            hoaDon = new HoaDon(CapDoQuyen);

            dataTable = new DataTable();
            dataTable.Clear();
            DataSet ds = hoaDon.SumSoTienBanDuoc(dpkDateOfTK1.ToString(), 1);
            dataTable = ds.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongLoiNhuan.Content = dt[0].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds1 = hoaDon.LoiNhuanTucThoi(dpkDateOfTK1.ToString(), 1);
            dataTable = ds1.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDoanhThu.Content = dt[0].ToString().Trim();
            }
            dataTable.Clear();
            DataSet ds2 = hoaDon.LoiNhuanThuDuoc(dpkDateOfTK1.ToString(), 1);
            dataTable = ds2.Tables[0];
            foreach (DataRow dt in dataTable.Rows)
            {
                lblTongDTDaKM.Content = dt[0].ToString().Trim();
            }
            
        }

        private void loadDTTheoNTN(int loai)
        {
            hoaDon = new HoaDon(CapDoQuyen);

            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.TKDTTheoNTN(dpkDateOfTK1.ToString(), loai);
                dataTable = ds.Tables[0];
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void SapXepThongKeTopBanChay()
        {
            hoaDon = new HoaDon(CapDoQuyen);

            try
            {
                dataTable = new DataTable();
                dataTable.Clear();
                DataSet ds = hoaDon.SapXepThongKeTopBanChay();
                dataTable = ds.Tables[0];
                dgThongKe1.ItemsSource = ds.Tables[0].DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void chkThongKeDT_Checked(object sender, RoutedEventArgs e)
        {

            chkTop1BanChay.IsChecked = false;
            chkThongKeDTDesc.IsChecked = false;
            if(chkYear.IsChecked == true)
            {
                loadDTTheoNTN(3);
            }
            else if (chkMonth.IsChecked == true)
            {
                loadDTTheoNTN(2);
            }
            else
            {
                loadDTTheoNTN(1);
            }    
        }

        private void chkTop1BanChay_Checked(object sender, RoutedEventArgs e)
        {
            chkThongKeDTDesc.IsChecked = false;
            chkThongKeDT.IsChecked = false;
            LoadTop1();
        }

        private void chkThongKeDTDesc_Checked(object sender, RoutedEventArgs e)
        {
            chkTop1BanChay.IsChecked = false;
            chkThongKeDT.IsChecked = false;

        }
        #endregion

        #region phân quyền
        private void PhanQuyen()
        {
 
            if (grvChiTietHoaDon.Visibility == Visibility.Visible)
            {
                if (cohoadon == 0)
                {
                    btnHuy_CTHD.Visibility = Visibility.Visible;
                    btnThanhToan_InHoaDon.Visibility = Visibility.Visible;
                }
                else
                {
                    btnHuy_CTHD.Visibility = Visibility.Hidden;
                    btnThanhToan_InHoaDon.Visibility = Visibility.Hidden;
                }
            }
            if (grvInHoaDon.Visibility == Visibility.Visible)
            {
                btnAdd.Visibility = Visibility.Visible;
                btnChange.Visibility = Visibility.Hidden;
                btnDelete.Visibility = Visibility.Hidden;
                btnSearch.Visibility = Visibility.Hidden;
                btnClear.Visibility = Visibility.Hidden;
                btnReload.Visibility = Visibility.Hidden;
            }
                if (capDoQuyen == "0")
            {
                btnNhanVien.Visibility = Visibility.Hidden;
                if (grvDienThoai.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvHangDienThoai.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }

                if (grvNhaCungCap.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }    

                if (grvNhapKho.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvNhanVien.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Hidden;
                    btnClear.Visibility = Visibility.Hidden;
                    btnReload.Visibility = Visibility.Hidden;
                }

                if (grvKhachHang.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }    

                if (grvThongKeDT.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Hidden;
                    btnClear.Visibility = Visibility.Hidden;
                    btnReload.Visibility = Visibility.Hidden;
                }   
                if (grvHoaDon.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvChiTietHoaDon.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Hidden;
                    btnClear.Visibility = Visibility.Hidden;
                    btnReload.Visibility = Visibility.Hidden;
                }

            }
         else if (capDoQuyen == "1")
            {
                if (grvDienThoai.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvHangDienThoai.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }

                if (grvNhaCungCap.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }

                if (grvNhapKho.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvNhanVien.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible; ;
                }

                if (grvKhachHang.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Visible;
                    btnChange.Visibility = Visibility.Visible;
                    btnDelete.Visibility = Visibility.Visible;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }

                if (grvThongKeDT.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Hidden;
                    btnClear.Visibility = Visibility.Hidden;
                    btnReload.Visibility = Visibility.Hidden;
                }
                if (grvHoaDon.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Visible;
                    btnClear.Visibility = Visibility.Visible;
                    btnReload.Visibility = Visibility.Visible;
                }
                if (grvChiTietHoaDon.Visibility == Visibility.Visible)
                {
                    btnAdd.Visibility = Visibility.Hidden;
                    btnChange.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                    btnSearch.Visibility = Visibility.Hidden;
                    btnClear.Visibility = Visibility.Hidden;
                    btnReload.Visibility = Visibility.Hidden;
                }
            }

          
        }


        #endregion

        private void dgNhapKho_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void dgNhapKho_SelectionChanged_1(object sender, SelectionChangedEventArgs e)
        {

        }

        private void txtTongGiaBanHD_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void txtIdHoaDon_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
    }
}
﻿use PMBanDienThoai
go
---Tạo nhóm quyền
CREATE ROLE Manager
---Tạo log in 
CREATE LOGIN admin1 WITH PASSWORD = '123';
---Tạo user
CREATE USER admin1 FOR LOGIN admin1;
GO
--- Phân quyền user
sp_addRoleMember 'Manager', 'admin1'
GO
---Cấp quyền
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.CHITIETHOADON TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.CHITIETPHIEUNHAPKHO TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.DIENTHOAI TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.HANGDIENTHOAI TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.HOADON TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.KHACHHANG TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NHANVIEN TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NHACUNgCAP TO Manager WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NHAPKHO TO Manager WITH GRANT OPTION

---Xem cái view 
GRANT SELECT ON [dbo].[v_dtbanduoc] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infdienthoai] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infHangDT] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infHoaDon] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infkhachhang] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhaCungCap] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhanVien] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhapKho] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_loaddanhsachkho] TO Manager WITH GRANT OPTION

---Thực thi các Procedure
GRANT EXECUTE ON [dbo].[sp_addDienThoai] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_Changepassword]TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_DeleteHDT] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_DeleteNCC] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_deleteKhachHang] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_DeleteNhanVien] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_deletePhone]TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_ReviseHDT] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_reviseNCC] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_ReviseNhanVien] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_RevisePhone] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_themkhachhang] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_themNhanVien] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_thongKeTongDoanhThu] TO Manager WITH GRANT OPTION

---Thực thi Function
GRANT SELECT ON [dbo].[fn_Authentication] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[fn_khachhang_sdt] TO Manager WITH GRANT OPTION
GRANT SELECT ON [dbo].[fn_tinhtienhoadonkhachhang] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_checkAccount]TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_loinhuan_ngay] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_slhoadon] TO Manager WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_tonghoadon_per_day]TO Manager WITH GRANT OPTION
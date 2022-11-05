use PMBanDienThoai
go
---Tạo nhóm quyền
CREATE ROLE Seller

---Tạo log in
CREATE LOGIN seller1 WITH PASSWORD = '123';
---Tạo user
CREATE USER seller1 FOR LOGIN seller1;
GO

--- Phân quyền user
sp_addRoleMember 'Seller', 'seller1'
GO

---Cấp quyền

GRANT SELECT, INSERT, UPDATE ON [dbo].[DIENTHOAI] TO Seller WITH GRANT OPTION
GRANT SELECT,INSERT, UPDATE, DELETE ON [dbo].[CHITIETHOADON] TO Seller WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE,DELETE ON [dbo].[HOADON] TO Seller WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE ON [dbo].[KHACHHANG] TO Seller WITH GRANT OPTION

GRANT SELECT, UPDATE ON [dbo].[NHANVIEN] TO Seller WITH GRANT OPTION
GRANT SELECT, UPDATE ON [dbo].[NHACUNGCAP] TO Seller WITH GRANT OPTION

GRANT SELECT ON [dbo].[HANGDIENTHOAI] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[CHITIETPHIEUNHAPKHO] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[NHAPKHO] TO Seller WITH GRANT OPTION

---Xem cái view 
GRANT SELECT ON [dbo].[v_dtbanduoc] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infdienthoai] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infHangDT] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infHoaDon] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infkhachhang] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhaCungCap] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhanVien] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_infNhapKho] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[v_loaddanhsachkho] TO Seller WITH GRANT OPTION

---Thực thi các Procedure
GRANT EXECUTE ON [dbo].[sp_addDienThoai] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_Changepassword]TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_deleteKhachHang] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_ReviseNhanVien] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_RevisePhone] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_themkhachhang] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[sp_thongKeTongDoanhThu] TO Seller WITH GRANT OPTION

---Thực thi Function
GRANT SELECT ON [dbo].[fn_Authentication] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[fn_khachhang_sdt] TO Seller WITH GRANT OPTION
GRANT SELECT ON [dbo].[fn_tinhtienhoadonkhachhang] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_checkAccount]TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_loinhuan_ngay] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_slhoadon] TO Seller WITH GRANT OPTION
GRANT EXECUTE ON [dbo].[fn_tonghoadon_per_day]TO Seller WITH GRANT OPTION
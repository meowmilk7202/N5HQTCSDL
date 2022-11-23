USE PMBanDienThoai03
GO

--.Kiểm tra ràng buộc email cho NHACUNGCAP
create trigger tg_checkemailncc ON NHACUNGCAP
For insert, update
AS
	DECLARE @email varchar (50)
	SELECT @email = ne.email
	From inserted ne
	if (@email not like '%@%')
		BEGIN
			Print (N'Nhập sai email. Vui lòng nhập lại ')
			Rollback
		END
go
--.Kiểm tra ràng buộc email cho Nhanvien
create trigger tg_checkemailnv ON NHANVIEN
For insert, update
AS
	DECLARE @email varchar (50)
	SELECT @email = ne.email
	From inserted ne
	if (@email not like '%@%')
		BEGIN
			Print (N'Nhập sai email. Vui lòng nhập lại ')
			Rollback
		END
go

--Trigger thêm chi tiết nhập kho
create trigger tr_insertCTNK on CHITIETPHIEUNHAPKHO
for insert
as
begin 
	declare @idCTPNK varchar(10),
			@idNhapKho varchar(10),
			@idDienThoai varchar(10) ,
			@soluong int, 
			@donGiaGoc float

	select @idCTPNK = ne.idChiTietPNK,
			@idNhapKho =ne.idNhapKho,
			@idDienThoai = ne.idDienThoai,
			@soluong = ne.soLuong,
			@donGiaGoc = ne.donGiaGoc
	from inserted ne

	update DIENTHOAI
	set soLuong = soLuong + @soluong
	where idDienThoai = @idDienThoai

	update CHITIETPHIEUNHAPKHO
	set thanhTien = (@soluong * @donGiaGoc)
	where idChiTietPNK = @idCTPNK

	update NHAPKHO
	set tongSoLuong = tongSoLuong + @soluong,
		thanhTien = thanhtien + ( @soluong * @donGiaGoc )
	where idNhapKho = @idNhapKho
end
go

----Trigger thêm chi tiết Hóa đơn
create trigger tr_insertCTHD on CHITIETHOADON
for insert
as
begin 
	declare @idCTHD varchar(10),
			@idHoaDon varchar(10),			
			@idDienThoai varchar(10), 
			@soLuong int, 
			@giaBan  float,
			@khuyenMai int

	select	@idCTHD = ne.idChiTietHoaDon,
			@idHoaDon = ne.idHoaDon,
			@idDienThoai = ne.idDienThoai,
			@soluong = ne.soLuong,
			@giaBan = ne.giaBan,
			@khuyenMai = ne.khuyenMai
	from inserted ne

	update DIENTHOAI
	set soLuong = soLuong - @soluong
	where idDienThoai = @idDienThoai

	update CHITIETHOADON
	set thanhTien = (@soluong * @giaBan)
	where idChiTietHoaDon = @idCTHD

	update HOADON
	set tongGiaBan = tongGiaBan + (@soluong * @giaBan),
		soluong = soluong + @soluong,
		diemThuong = diemThuong + (@soluong * @giaBan)*0.01,
		status =1
	where idHoaDon = @idHoaDon
end
--Done
go

--Trigger cập nhật/xoá chi tiết nhập kho
create trigger tr_updateCTNK on CHITIETPHIEUNHAPKHO
for update
as
declare @statusne int, 
		@statusol int,
		@soluongthaydoi int,
		@iddt varchar(10),
		@idNhapKho varchar(10),
		@idChiTietPNK varchar(10),
		@dongia float,
		@soluongChiTietM int

	select  @statusne =ne.status, @statusol =ol.status, 
			@soluongthaydoi=ne.soLuong - ol.soLuong,
			@dongia=ne.donGiaGoc, -- nhập đơn giá mới
			@soluongChiTietM=ne.soluong,
			@iddt =ne.idDienThoai,
			@idNhapKho =ne.idNhapKho, 
			@idChiTietPNK=ne.idChiTietPNK
	from deleted ol ,inserted ne -- ol là cũ, ne là mới 
	where ol.idChiTietPNK=ne.idChiTietPNK

	if(@statusne=1 and @statusol=1) --update, 1 1 ở đây kiểu như bật cờ vậy á, 1,1 là update, giống công tắc để nhận diện
		begin
				update CHITIETPHIEUNHAPKHO
				set thanhTien = thanhTien + @dongia*(@soluongthaydoi)
				where idChiTietPNK=@idChiTietPNK

				update NHAPKHO
				set tongSoLuong = tongSoLuong + @soluongthaydoi ,-- số lượng gốc + cho lượng thay đổi đã trừ ở trên nha
				thanhTien = thanhTien + @dongia*@soluongthaydoi
				where idNhapKho = @idNhapKho
	
				update DIENTHOAI
				set soLuong = soLuong + @soluongthaydoi
				where idDienThoai=@iddt
			end
		
else if(@statusol=1 and @statusne=0) --xoa
	begin
	update CHITIETPHIEUNHAPKHO
	set thanhTien = 0,
	--soLuong = 0,
	--donGiaGoc = 0,
	status = 0
	where idChiTietPNK=@idChiTietPNK

	update NHAPKHO
	set tongSoLuong = tongSoLuong - @soluongChiTietM ,
		thanhTien = thanhTien - @dongia*@soluongChiTietM
	where idNhapKho = @idNhapKho

	update DIENTHOAI
	set soLuong = soLuong - @soluongChiTietM
	where idDienThoai=@iddt
	end
else if(@statusol=0 and @statusne=1) 
begin
	update DIENTHOAI
	set soLuong = soLuong + @soluongChiTietM
	where idDienThoai = @iddt

	update CHITIETPHIEUNHAPKHO
	set thanhTien = (@soluongChiTietM * @dongia)
	where idChiTietPNK = @idChiTietPNK

	update NHAPKHO
	set tongSoLuong = tongSoLuong + @soluongChiTietM,
		thanhTien = thanhtien + ( @soluongChiTietM * @dongia )
	where idNhapKho = @idNhapKho
end
go

--Trigger cập nhật/xoá chi tiết hóa đơn
create trigger tr_updateCTHD on CHITIETHOADON
for update
as
declare @statusne int, 
		@statusol int,
		@soLuongThayDoi int,
		@idDienThoai varchar(10),
		@idHoaDon varchar(10),
		@idChiTietHoaDon varchar(10),
		@giaBan float,
		@soLuong int,
		@khuyenmai int

select	@statusne = ne.status, 
		@statusol = ol.status, 
		@soLuongThayDoi = ne.soLuong - ol.soLuong,
		@giaBan = ne.giaBan,
		@soLuong = ne.soLuong,
		@idDienThoai = ne.idDienThoai,
		@idHoaDon = ne.idHoaDon, 
		@idChiTietHoaDon = ne.idChiTietHoaDon,
		@khuyenmai = ne.khuyenMai
		from deleted ol ,inserted ne
where ol.idChiTietHoaDon = ne.idChiTietHoaDon

if(@statusne = 1 and @statusol = 1) --update
	begin
				update CHITIETHOADON
				set thanhTien = thanhTien + @giaBan*( @soLuongThayDoi)
				where idChiTietHoaDon = @idChiTietHoaDon

				update HOADON
				set tongGiaBan = tongGiaBan + @giaBan * @soLuongThayDoi,
					diemthuong = diemthuong + (@giaBan* @soLuongThayDoi)*0.01,
					soluong = soluong + @soLuongThayDoi
				where idHoaDon = @idHoaDon

				update DIENTHOAI
				set soLuong = soLuong - @soLuongThayDoi
				where idDienThoai = @idDienThoai
	end
else if(@statusol=1 and @statusne=0) --xoa
	begin
	update CHITIETHOADON
	set thanhTien = 0,
	--soLuong = 0,
	--giaBan = 0,
	--khuyenMai =0
	status=0
	where idChiTietHoaDon=@idChiTietHoaDon

	update HOADON
	set soLuong = soLuong - @soLuong ,
		tongGiaBan =tongGiaBan - (@soluong * @giaBan),
		diemThuong = diemThuong -(@giaBan* @soLuong)*0.01
	where idHoaDon = @idhoadon

	update DIENTHOAI
	set soLuong = soLuong + @soLuong
	where idDienThoai=@idDienThoai
	end
else if(@statusol=0 and @statusne=1) --Không cho khôi phục
	begin
	update DIENTHOAI
	set soLuong = soLuong - @soluong
	where idDienThoai = @idDienThoai

	update CHITIETHOADON
	set thanhTien = (@soluong * @giaBan)
	where idChiTietHoaDon = @idChiTietHoaDon

	update HOADON
	set tongGiaBan = tongGiaBan + (@soluong * @giaBan),
		soluong = soluong + @soluong,
		diemThuong = diemThuong + (@soluong * @giaBan)*0.01,
		status =1
	where idHoaDon = @idHoaDon
	end
go

--6.Kiểm tra tên điện thoại nhập có bị trùng với điện thoại cũ không--
create trigger tg_kttendienthoai on DIENTHOAI
for insert, update
as
declare @tenDienThoai nvarchar(150),
		@mau nvarchar(50),
		@dungluong int,
		@bonho int

select @tenDienThoai = ne.tenDienThoai,
		@mau = ne.mauSac,
		@dungluong = ne.dungLuong,
		@bonho = ne.boNho
		from inserted ne
declare @d int
set @d =(select count(tenDienThoai) from DIENTHOAI 
where tenDienThoai = @tenDienThoai AND mauSac = @mau AND dungLuong  =@dungluong AND boNho = @bonho)
if(@d > 1)
BEGIN
print(N'Sản phẩn đã tồn tại')
rollback
End
go


-- Kiểm tra mật khẩu có hợp lệ không.Mật khẩu hợp lệ khi độ dài lớn hơn 6
create trigger trg_pw on dbo.NHANVIEN
for insert , update 
as
declare @password varchar(50)
select @password = ins.password
from inserted ins
if(LEN(@password) < 6)
begin
print(N'Password phải có nhiều hơn 6 ký tự ')
Rollback
End
go

-- Kiểm tra khuyến mãi có phù hợp không
create trigger trg_voucher on DIENTHOAI
for insert , update 
as
declare @Khuyenmai int
select @Khuyenmai = ins.khuyenMai
from inserted ins
if(@Khuyenmai >100 OR @Khuyenmai <0)
begin
print(N'Khuyến mãi không hợp lệ.')
Rollback
end
go
-- Check status điện thoại
create trigger tg_checkStatus on DIENTHOAI
after insert, update
as
begin transaction
	Update DIENTHOAI
	set status = 0
	where soLuong = 0
	Update DIENTHOAI
	set status = 1
	where soLuong > 0
commit transaction
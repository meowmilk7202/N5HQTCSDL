/****** Object:  Database [PMBanDienThoai03]    Script Date: 11/23/2022 1:53:49 PM ******/
CREATE DATABASE [PMBanDienThoai03]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PMBanDienThoai03', FILENAME = N'D:\SQL2016\MSSQL13.MSSQLSERVER\MSSQL\DATA\PMBanDienThoai03.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PMBanDienThoai03_log', FILENAME = N'D:\SQL2016\MSSQL13.MSSQLSERVER\MSSQL\DATA\PMBanDienThoai03_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [PMBanDienThoai03] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PMBanDienThoai03].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PMBanDienThoai03] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET ARITHABORT OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PMBanDienThoai03] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PMBanDienThoai03] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PMBanDienThoai03] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PMBanDienThoai03] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET RECOVERY FULL 
GO
ALTER DATABASE [PMBanDienThoai03] SET  MULTI_USER 
GO
ALTER DATABASE [PMBanDienThoai03] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PMBanDienThoai03] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PMBanDienThoai03] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PMBanDienThoai03] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PMBanDienThoai03] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'PMBanDienThoai03', N'ON'
GO
ALTER DATABASE [PMBanDienThoai03] SET QUERY_STORE = OFF
GO
USE [PMBanDienThoai03]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
create function [dbo].[fn_checkAccount](@idNV varchar(10)) returns int
as
begin
	declare @status int
	set @status= (select status from NHANVIEN where idNV = @idNV) 
	--return(select status from NHANVIEN where idNV = @idNV)
	return @status
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Login]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Login] (@user varchar(50), @password varchar(500) )
RETURNS @table TABLE (idNV varchar(10) not null, tenNV NVARCHAR(150) not null,
username varchar(50) not null , passw varchar(500) not null, sdt VARCHAR(20) not
null, email nvarchar(150) not null ,phanQuyen int not null, status int)
AS
BEGIN
if EXISTS (select idNV from NHANVIEN where idNV = @user and password =
@password)
begin
insert @table select * from NHANVIEN where idNV = @user and password
= @password
end
if EXISTS (select idNV from NHANVIEN where sdt = @user and password =
@password )
begin
insert @table select * from NHANVIEN where sdt = @user and password =
@password
end
if EXISTS(select idNV from NHANVIEN where email = @user and password =
@password )
begin
insert @table select * from NHANVIEN where email = @user and password
= @password 
end

if EXISTS(select idNV from NHANVIEN where username = @user and password = @password )
begin
insert @table select * from NHANVIEN where username = @user and password = @password 
end
return
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_loinhuan_ngay]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_loinhuan_ngay] (@ngayban date)
returns float
as
begin
declare @soluongdtban int ,@giaban float,@gianhap float,@loinhuan float,@tongloinhuan float

select @soluongdtban =cthd.soLuong ,@giaban = cthd.giaBan,@gianhap=ctnk.donGiaGoc
from CHITIETPHIEUNHAPKHO as ctnk ,CHITIETHOADON as cthd ,HOADON as hd
where cthd.idHoaDon=hd.idHoaDon and hd.ngayLapHoaDon = @ngayban and cthd.status=0

set @loinhuan = @soluongdtban * (@giaban -@gianhap)
set @tongloinhuan =SUM(@loinhuan)
return @tongloinhuan
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_slhoadon]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_slhoadon]()
returns int
as
begin
declare @sl int 
set @sl = (select COUNT(idHoaDon) from HOADON)
return @sl
end 
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SumMoneyCTHD]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_SumMoneyCTHD] (@idHD varchar(10))
Returns float
as
begin
DECLARE @Thanhtien float
select @Thanhtien = sum(tb.thanhTien)
from (
select hd.thanhTien
from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and
h.idKH = kh.idKH and hd.idHoaDon = @idHD 
) tb
RETURN @Thanhtien
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SumSoTienBanDuoc]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Tổng tiền bán điện thoại bán theo ngày, tháng, năm
create function [dbo].[fn_SumSoTienBanDuoc] (@ngay varchar(30), @int int)
RETURNS float
as
begin
DECLARE @total float 
if (@int = 1)
	begin
		select @total = Sum (hd.thanhTien) 
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay)
	
	end
if (@int = 2)
	begin
		select @total = Sum (hd.thanhTien)
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay)
	
	end
if (@int = 3)
	begin
		
		select @total=Sum (hd.thanhTien) 
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay) and DAY(h.ngayLapHoaDon)=DAY(@ngay)
	
	end
	return @total
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TKDTTheoNTN]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Liệt kê những điện thoại bán theo ngày, tháng hoặc năm
CREATE FUNCTION [dbo].[fn_TKDTTheoNTN] (@ngay varchar(30) , @int int)
RETURNS  @table table (idKH varchar(10) not null, idHoaDon varchar(10) not null ,tenKH nvarchar(150) not null, sdt varchar(20) null, idDienThoai varchar(10) not null ,tenDienThoai nvarchar(150) not null, mauSac nvarchar(20) not null, dungLuong int not null, boNho int not null ,soLuong int not null, khuyenMaiGiamGia int null, thanhTien float null, khuyenMaiDienThoai int null)
as  
begin
if(@int=1)
	begin
		insert @table select kh.idKH, hd.idHoaDon, tenKH, sdt, dt.idDienThoai, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien,dt.khuyenMai
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay)
	end
else if(@int = 2)
	begin
	
		insert @table select kh.idKH, hd.idHoaDon, tenKH, sdt, dt.idDienThoai, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien,dt.khuyenMai
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay)

	end
else if (@int = 3)
	begin
	insert @table
		select kh.idKH, hd.idHoaDon, tenKH, sdt, dt.idDienThoai, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien,dt.khuyenMai
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay) and DAY(h.ngayLapHoaDon)=DAY(@ngay)
	
	end
	return 
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_tonghoadon_per_day]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_tonghoadon_per_day] (@day date)
returns int
as
begin
declare @tonghoadon int
select @tonghoadon =COUNT(idHoaDon) from HOADON where HOADON.ngayLapHoaDon = @day
return @tonghoadon
end
GO
/****** Object:  UserDefinedFunction [dbo].[sp_LoiNhuanThuDuoc]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Tính lợi nhận theo ngày tháng năm trừ tiền giá gốc đã tính khuyến mãi
create function [dbo].[sp_LoiNhuanThuDuoc] (@ngay varchar(30), @int int)
returns float
as
BEGIN
DECLARE @total float 
		select @total = (sum (tk.thanhTien )-sum( ctpn.donGiaGoc) 
		-((sum(tk.khuyenMaiDienThoai)/100)*sum (tk.thanhTien ))
		-((sum(tk.khuyenMaiGiamGia)/100)*sum (tk.thanhTien )))
		from CHITIETPHIEUNHAPKHO ctpn, (Select * from fn_TKDTTheoNTN( @ngay, @int)) Tk
		Where ctpn.idDienThoai=Tk.idDienThoai
	return @total
END
GO
/****** Object:  UserDefinedFunction [dbo].[sp_LoiNhuanTucThoi]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Tính lợi nhận theo ngày, tháng, năm trừ tiền giá gốc nhưng chưa tính khuyến mãi
create function [dbo].[sp_LoiNhuanTucThoi] (@ngay varchar(30), @int int)
returns float
as
BEGIN
DECLARE @total float 
		select @total = (sum (tk.thanhTien )-sum( ctpn.donGiaGoc))
		from CHITIETPHIEUNHAPKHO ctpn, (Select * from fn_TKDTTheoNTN( @ngay, @int)) Tk
		Where ctpn.idDienThoai=Tk.idDienThoai
	return @total
END
GO
/****** Object:  Table [dbo].[HANGDIENTHOAI]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HANGDIENTHOAI](
	[idHangDT] [varchar](10) NOT NULL,
	[tenHangDT] [nvarchar](150) NOT NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idHangDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIENTHOAI]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIENTHOAI](
	[idDienThoai] [varchar](10) NOT NULL,
	[idHangDT] [varchar](10) NULL,
	[tenDienThoai] [nvarchar](150) NOT NULL,
	[mauSac] [nvarchar](20) NOT NULL,
	[dungLuong] [int] NOT NULL,
	[boNho] [int] NOT NULL,
	[soLuong] [int] NULL,
	[giaBan] [float] NULL,
	[khuyenMai] [int] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idDienThoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_LoadFirm]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Xuất thông tin điện thoại theo id hãng điện thoại hoặc là tên hãng điện thoại
CREATE FUNCTION [dbo].[fn_LoadFirm](@id varchar(10), @name nvarchar(50))
RETURNS TABLE
AS RETURN
	(SELECT idDienThoai , tenDienThoai as TenDienThoai, mauSac, boNho, giaBan
	FROM DIENTHOAI INNER JOIN HANGDIENTHOAI ON DIENTHOAI.idHangDT = HANGDIENTHOAI.idHangDT
	WHERE HANGDIENTHOAI.idHangDT = @id OR HANGDIENTHOAI.tenHangDT = @name
		AND HANGDIENTHOAI.status = 1)
GO
/****** Object:  Table [dbo].[CHITIETHOADON]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETHOADON](
	[idChiTietHoaDon] [int] IDENTITY(1,1) NOT NULL,
	[idHoaDon] [varchar](10) NULL,
	[idDienThoai] [varchar](10) NULL,
	[soLuong] [int] NULL,
	[giaBan] [float] NOT NULL,
	[khuyenMai] [int] NULL,
	[thanhTien] [float] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idChiTietHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ThongKe]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ThongKe]()
RETURNS table
AS
	RETURN (
		select idDienThoai, SUM(soLuong) as SL
		from CHITIETHOADON CTHD
		group by idDienThoai
		)
GO
/****** Object:  UserDefinedFunction [dbo].[ThongKeDienThoai]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Drop PROC SapXepThongKeTopBanChay
CREATE FUNCTION [dbo].[ThongKeDienThoai]()
RETURNS table
AS
	RETURN (
		select DIENTHOAI.idDienThoai , DIENTHOAI.tenDienThoai, DIENTHOAI.dungLuong, DIENTHOAI.boNho, DIENTHOAI.mauSac , Tk.SL
		from DIENTHOAI, (select * from ThongKe()) Tk
		where DIENTHOAI.idDienThoai = tk.idDienThoai
		)
GO
/****** Object:  UserDefinedFunction [dbo].[ThongKeTop1BanChay]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ThongKeTop1BanChay]()
RETURNS table
AS
	RETURN (
		select * 
		from (select * from ThongKeDienThoai()) M
		where M.SL = (select Max(M.SL) from (select * from ThongKe()) M)

		)
GO
/****** Object:  Table [dbo].[NHAPKHO]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHAPKHO](
	[idNhapKho] [varchar](10) NOT NULL,
	[idNV] [varchar](10) NULL,
	[idNCC] [varchar](10) NULL,
	[ngayNhapKho] [varchar](30) NULL,
	[tongSoLuong] [int] NULL,
	[thanhTien] [float] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idNhapKho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_infNhapKho]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infNhapKho]
as
	select * from NHAPKHO
GO
/****** Object:  Table [dbo].[CHITIETPHIEUNHAPKHO]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETPHIEUNHAPKHO](
	[idChiTietPNK] [int] IDENTITY(1,1) NOT NULL,
	[idNhapKho] [varchar](10) NULL,
	[idDienThoai] [varchar](10) NULL,
	[soLuong] [int] NOT NULL,
	[donGiaGoc] [float] NOT NULL,
	[thanhTien] [float] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idChiTietPNK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_infCTPNK]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infCTPNK]
as
	select * from CHITIETPHIEUNHAPKHO
GO
/****** Object:  View [dbo].[v_infHangDT]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infHangDT]
as
select idHangDT,tenHangDT, status
from HANGDIENTHOAI
GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHACUNGCAP](
	[idNCC] [varchar](10) NOT NULL,
	[tenNCC] [nvarchar](150) NOT NULL,
	[sdt] [varchar](20) NOT NULL,
	[email] [varchar](150) NULL,
	[diaChi] [nvarchar](250) NOT NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_infNhaCungCap]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_infNhaCungCap]
AS
SELECT        idNCC, tenNCC, diaChi, sdt, email, status
FROM            dbo.NHACUNGCAP
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[idKH] [int] IDENTITY(1,1) NOT NULL,
	[tenKH] [nvarchar](150) NOT NULL,
	[sdt] [varchar](20) NULL,
	[diemThuong] [float] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_khachhang_sdt]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_khachhang_sdt](@sdt varchar(20))
returns table
as
return(select * from KHACHHANG where sdt =@sdt)
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON](
	[idHoaDon] [varchar](10) NOT NULL,
	[idNV] [varchar](10) NULL,
	[idKH] [int] NULL,
	[soluong] [int] NULL,
	[tongGiaBan] [float] NULL,
	[diemThuong] [float] NULL,
	[ngayLapHoaDon] [varchar](30) NULL,
	[thanhTien] [float] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_tinhtienhoadonkhachhang]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--6. Tính tổng số tiền tiền khách hàng đã mua ở cửa hàng
create function [dbo].[fn_tinhtienhoadonkhachhang]()
returns table
as
return (SELECT KHACHHANG.tenKH, sum(HOADON.tongGiaBan) as tongtienkhachhang  From KHACHHANG,HOADON 
		where  KHACHHANG.idKH = HOADON.idKH
		group by KHACHHANG.tenKH)
GO
/****** Object:  View [dbo].[v_loaddanhsachkho]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------
--3.Load danh sach kho
create view [dbo].[v_loaddanhsachkho] 
as
	select *
	from NHAPKHO
	where NHAPKHO.status=1
	
--select distinct * from v_loaddanhsachkho
GO
/****** Object:  View [dbo].[v_infkhachhang]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*4.Hien thi thong tin khach hang đã mua sản phẩm tại cửa hàng
select distinct * from v_infkhachhang
drop view v_infkhachhang
-----------------------------------------------------------------*/
CREATE VIEW [dbo].[v_infkhachhang]
AS
SELECT        idKH, tenKH, sdt, diemThuong, status
FROM            dbo.KHACHHANG
GO
/****** Object:  View [dbo].[v_dtbanduoc]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*select distinct * from v_dtbanduoc*/
CREATE VIEW [dbo].[v_dtbanduoc]
AS
SELECT        dt.idDienThoai, dt.tenDienThoai, hd.soLuong, dt.mauSac, dt.dungLuong, dt.boNho, dt.khuyenMai, dt.giaBan, hd.thanhTien, dt.status
FROM            dbo.CHITIETHOADON AS hd INNER JOIN
                         dbo.DIENTHOAI AS dt ON hd.idDienThoai = dt.idDienThoai INNER JOIN
                         dbo.HANGDIENTHOAI AS hdt ON dt.idHangDT = hdt.idHangDT
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[idNV] [varchar](10) NOT NULL,
	[tenNV] [nvarchar](150) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](500) NOT NULL,
	[sdt] [varchar](20) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[phanQuyen] [int] NULL,
	[status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Authentication]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Login
CREATE FUNCTION [dbo].[fn_Authentication](@username varchar(50),@password varchar(500) )
RETURNS TABLE -- dataset
AS RETURN
	(SELECT *
	FROM NHANVIEN
	WHERE NHANVIEN.username = @username and NHANVIEN.password = @password
		and NHANVIEN.status = 1)
GO
/****** Object:  View [dbo].[v_infdienthoai]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_infdienthoai]
AS
SELECT        DT.idDienThoai, DT.idHangDT, HDT.tenHangDT, DT.tenDienThoai, DT.mauSac, DT.dungLuong, DT.boNho, DT.khuyenMai, DT.giaBan, DT.soLuong
FROM            dbo.DIENTHOAI AS DT INNER JOIN
                         dbo.HANGDIENTHOAI AS HDT ON DT.idHangDT = HDT.idHangDT
GO
/****** Object:  View [dbo].[v_infHoaDon]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* View : Thông tin hóa đơn*/
CREATE VIEW [dbo].[v_infHoaDon]
AS
SELECT        idHoaDon, idNV, idKH, soluong, tongGiaBan, diemThuong, ngayLapHoaDon, thanhTien, status
FROM            dbo.HOADON
GO
/****** Object:  View [dbo].[v_infNhanVien]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* view: Thông tin nhân viên*/
CREATE VIEW [dbo].[v_infNhanVien]
AS
SELECT        idNV, tenNV, username, password, sdt AS SoDienThoai, email, phanQuyen, status
FROM            dbo.NHANVIEN
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SearchPhone]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- function: Tìm thông tin điện thoại khi nhập tên điện thoại gần đúng
CREATE FUNCTION [dbo].[fn_SearchPhone](@Name NVARCHAR(100))
RETURNS TABLE
AS RETURN SELECT * FROM DIENTHOAI WHERE tenDienThoai LIKE '%'+@Name+'%'
GO
/****** Object:  UserDefinedFunction [dbo].[sp_ViewCTHD02]    Script Date: 11/23/2022 1:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_ViewCTHD02](@idHD varchar(10) null)
RETURNS table
AS
RETURN (
select kh.idKH, hd.idHoaDon, tenKH, sdt, tenDienThoai, mauSac, dungLuong,
boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien, h.ngayLapHoaDon
from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH 
= kh.idKH and hd.idHoaDon = @idHD)
GO
SET IDENTITY_INSERT [dbo].[CHITIETHOADON] ON 

INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (1, N'HD01', N'DT01', 1, 900, 0, 900, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (2, N'HD02', N'DT12', 2, 600, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (3, N'HD03', NULL, 1, 700, 0, 700, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (4, N'HD04', N'DT32', 3, 800, 0, 2400, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (5, N'HD05', N'DT11', 5, 400, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (6, N'HD06', N'DT23', 4, 500, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (7, N'HD07', N'DT54', 2, 1000, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (8, N'HD08', N'DT21', 1, 1200, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (11, N'HD08', N'DT23', 1, 1200, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (12, N'HD08', N'DT23', 1, 1200, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (13, N'HD10', N'DT21', 1, 1200, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (14, N'HD10', N'DT22', 2, 1200, 0, 2400, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (30, N'HD120', N'DT01', 1, 800, 0, 800, 1)
SET IDENTITY_INSERT [dbo].[CHITIETHOADON] OFF
GO
SET IDENTITY_INSERT [dbo].[CHITIETPHIEUNHAPKHO] ON 

INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (1, N'NK01', N'DT21', 20, 700, 14000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (2, N'NK02', N'DT57', 10, 1000, 10000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (3, N'NK03', N'DT32', 14, 500, 0, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (4, N'NK01', NULL, 30, 1200, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (5, N'NK01', N'DT55', 4, 200, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (6, N'NK04', N'DT24', 100, 1000, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (7, N'NK04', N'DT54', 20, 800, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (8, N'NK03', N'DT06', 20, 500, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (9, N'NK02', N'DT09', 20, 850, 0, 0)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (10, N'NK03', N'DT63', 20, 900, 0, 0)
SET IDENTITY_INSERT [dbo].[CHITIETPHIEUNHAPKHO] OFF
GO
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT01', N'HDT01', N'IPhone 11', N'Đen', 6, 64, 9, 800, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT04', N'HDT01', N'IPhone 11', N'Đen', 6, 256, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT05', N'HDT01', N'IPhone 11', N'Trắng', 6, 64, 10, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT06', N'HDT01', N'IPhone 23', N'Trắng', 6, 128, 10, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT07', N'HDT01', N'IPhone 11', N'Trắng', 6, 256, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT08', N'HDT01', N'IPhone 11', N'Trắng', 6, 512, 10, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT09', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 64, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT10', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 128, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT11', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 256, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT12', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 512, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT13', N'HDT01', N'IPhone 11', N'Đỏ', 6, 64, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT14', N'HDT01', N'IPhone 11', N'Đỏ', 6, 128, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT15', N'HDT01', N'IPhone 11', N'Đỏ', 6, 256, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT16', N'HDT01', N'IPhone 11', N'Đỏ', 6, 512, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT17', N'HDT01', N'IPhone 12', N'Đen', 6, 64, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT18', N'HDT01', N'IPhone 12', N'Đen', 6, 128, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT19', N'HDT01', N'IPhone 12', N'Đen', 6, 256, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT20', N'HDT01', N'IPhone 12', N'Đen', 6, 512, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT21', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 64, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT22', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 128, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT23', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 256, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT24', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 512, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT25', N'HDT01', N'IPhone 12', N'Đỏ', 6, 64, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT26', N'HDT01', N'IPhone 12', N'Đỏ', 6, 128, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT27', N'HDT01', N'IPhone 12', N'Đỏ', 6, 256, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT28', N'HDT01', N'IPhone 12', N'Đỏ', 6, 512, 10, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT29', N'HDT01', N'IPhone 13', N'Đen', 6, 64, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT30', N'HDT01', N'IPhone 13', N'Đen', 6, 128, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT31', N'HDT01', N'IPhone 13', N'Đen', 6, 256, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT32', N'HDT01', N'IPhone 13', N'Đen', 6, 512, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT33', N'HDT01', N'IPhone 13', N'Trắng', 6, 64, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT34', N'HDT01', N'IPhone 13', N'Trắng', 6, 128, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT35', N'HDT01', N'IPhone 13', N'Trắng', 6, 256, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT36', N'HDT01', N'IPhone 13', N'Trắng', 6, 512, 10, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT37', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 64, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT38', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 128, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT39', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 256, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT40', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 512, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT41', N'HDT01', N'IPhone 13', N'Đỏ', 6, 64, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT42', N'HDT01', N'IPhone 13', N'Đỏ', 6, 128, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT43', N'HDT01', N'IPhone 13', N'Đỏ', 6, 256, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT44', N'HDT01', N'IPhone 13', N'Đỏ', 6, 512, 10, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT45', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 64, 9, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT46', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 128, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT47', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 256, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT48', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Trắng', 6, 64, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT49', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 128, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT50', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Xanh', 6, 256, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT51', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đỏ', 6, 512, 10, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT52', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Trắng', 6, 64, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT53', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Đen', 6, 128, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT54', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Xanh', 6, 256, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT55', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Xanh lá', 6, 512, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT56', N'HDT02', N'Samsung Galaxy A53 5G', N'Trắng', 6, 64, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT57', N'HDT02', N'Samsung Galaxy A53 5G', N'Đen', 6, 128, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT58', N'HDT02', N'Samsung Galaxy A53 5G', N'Xanh', 6, 256, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT59', N'HDT02', N'Samsung Galaxy A53 5G', N'Đỏ', 6, 512, 10, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT60', N'HDT02', N'Samsung Galaxy M53', N'Trắng', 6, 64, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT61', N'HDT02', N'Samsung Galaxy M53', N'Đen', 6, 128, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT62', N'HDT02', N'Samsung Galaxy M53', N'Xanh', 6, 256, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT63', N'HDT02', N'Samsung Galaxy M53', N'Đỏ', 6, 512, 10, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT64', N'HDT02', N'Samsung Galaxy M73', N'Đen', 6, 512, 10, 1000, 0, 0)
GO
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT01', N'IPhone', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT02', N'SamSung', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT03', N'Oppo', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT04', N'Xiaomi', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT05', N'Realme', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT06', N'adsd', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT070', N'Toan', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT190', N'MK', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT20', N'RealPhone', 0)
GO
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD01', N'NV03', 1, 1, 900, 9, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD02', N'NV03', 2, 2, 1200, 12, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD03', N'NV03', 3, 1, 700, 7, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD04', N'NV03', 4, 3, 2400, 24, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD05', N'NV04', 3, 5, 2000, 20, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD06', N'NV04', 3, 4, 2000, 20, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD07', N'NV04', 1, 4, 4000, 40, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD08', N'NV04', 2, 2, 2400, 24, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD09', N'NV01', 1, 1, 1200, 0, N'Nov 13 2022  5:03PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD10', N'NV02', 2, 3, 3600, 36, N'Nov 13 2022 10:47PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD120', N'NV02', 10, 1, 800, 8, N'GETDATE', 0, 1)
GO
SET IDENTITY_INSERT [dbo].[KHACHHANG] ON 

INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (1, N'Nguyễn Văn A', N'0326526984', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (2, N'Nguyễn Thị B', N'0962333621', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (3, N'Trần Văn C', N'0946312497', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (4, N'Trần Đào Trang', N'0389421573', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (5, N'Toàn', N'0974734350', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (6, N'Huy Ngô', N'0923120120', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (7, N'Huy', N'0923123123', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (8, N'Huy Ngô', N'0923102122', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (9, N'Chí', N'0923102120', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (10, N'KH100', N'0923102111', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (11, N'Chí Khang', N'0909230230', 0, 0)
SET IDENTITY_INSERT [dbo].[KHACHHANG] OFF
GO
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC01', N'Apple Vi?t Nam', N'043 9743 488', N'applevn@avn.com.vn', N'T?ng 12, s? 29 Nguy?n Ðình Chi?u, Phu?ng Lê Ð?i Hành, Qu?n Hai Bà Trung, Hà N?i', 1)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC02', N'SamSung Việt Nam', N'028 3256 523', N'samsungvn@ssvn.com.vn', N'Tầng 6, Tòa nhà Sài Gòn Royal, 91 Pasteur, P.Bến Nghé, Q.1, TP Hồ Chí Minh', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC03', N'Oppo Việt Nam', N'032 1800 080', N'oppovn@opvn.vn', N'879 Nguyễn Kiệm, P.3, Gò Vấp, HCM', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC04', N'Xiaomi Vi?t Nam', N'0898 516 156', N'xiaomi.vn@gmail.com', N'TP H? Chí Minh', 0)
GO
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV01', N'Nguyễn Hoàng Toàn', N'admin01', N'admin01', N'035 3131 225', N'admin01@shoestore.com', 1, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV02', N'Nguyễn Công Thành', N'admin02', N'admin02', N'097 8764 222', N'admin02@shoestore.com', 1, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV03', N'Ngô Quang Huy', N'user01', N'user01', N'01231312120', N'user01@shoestore.com', 0, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV04', N'Phan Hoàng Thanh Sơn', N'user02', N'user02', N'01231312920', N'user02@shoestore.com', 0, 1)
GO
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK01', N'NV01', N'NCC01', N'26/09/2022', 0, 0, 0)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK02', N'NV02', N'NCC02', N'26/09/2022', 0, 0, 0)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK03', N'NV03', N'NCC03', N'Oct 26 2022  5:58PM', 0, 0, 0)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK04', N'NV01', N'NCC04', N'Oct 26 2022  5:58PM', 0, 0, 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [unique_dt]    Script Date: 11/23/2022 1:53:49 PM ******/
ALTER TABLE [dbo].[DIENTHOAI] ADD  CONSTRAINT [unique_dt] UNIQUE NONCLUSTERED 
(
	[idDienThoai] ASC,
	[mauSac] ASC,
	[dungLuong] ASC,
	[boNho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__NHACUNGC__AFCF872A42370EB1]    Script Date: 11/23/2022 1:53:49 PM ******/
ALTER TABLE [dbo].[NHACUNGCAP] ADD UNIQUE NONCLUSTERED 
(
	[tenNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CHITIETHOADON] ADD  DEFAULT ((0)) FOR [soLuong]
GO
ALTER TABLE [dbo].[CHITIETHOADON] ADD  DEFAULT ((0)) FOR [khuyenMai]
GO
ALTER TABLE [dbo].[CHITIETHOADON] ADD  DEFAULT ((0)) FOR [thanhTien]
GO
ALTER TABLE [dbo].[CHITIETHOADON] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAPKHO] ADD  DEFAULT ((0)) FOR [thanhTien]
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAPKHO] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[DIENTHOAI] ADD  DEFAULT ((0)) FOR [soLuong]
GO
ALTER TABLE [dbo].[DIENTHOAI] ADD  DEFAULT ((0)) FOR [giaBan]
GO
ALTER TABLE [dbo].[DIENTHOAI] ADD  DEFAULT ((0)) FOR [khuyenMai]
GO
ALTER TABLE [dbo].[DIENTHOAI] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[HANGDIENTHOAI] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [soluong]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [tongGiaBan]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [diemThuong]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT (getdate()) FOR [ngayLapHoaDon]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [thanhTien]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  DEFAULT ((0)) FOR [diemThuong]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[NHACUNGCAP] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  DEFAULT ((0)) FOR [phanQuyen]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  DEFAULT (getdate()) FOR [ngayNhapKho]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  DEFAULT ((0)) FOR [tongSoLuong]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  DEFAULT ((0)) FOR [thanhTien]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[CHITIETHOADON]  WITH CHECK ADD FOREIGN KEY([idDienThoai])
REFERENCES [dbo].[DIENTHOAI] ([idDienThoai])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[CHITIETHOADON]  WITH CHECK ADD FOREIGN KEY([idHoaDon])
REFERENCES [dbo].[HOADON] ([idHoaDon])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAPKHO]  WITH CHECK ADD FOREIGN KEY([idDienThoai])
REFERENCES [dbo].[DIENTHOAI] ([idDienThoai])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAPKHO]  WITH CHECK ADD FOREIGN KEY([idNhapKho])
REFERENCES [dbo].[NHAPKHO] ([idNhapKho])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DIENTHOAI]  WITH CHECK ADD FOREIGN KEY([idHangDT])
REFERENCES [dbo].[HANGDIENTHOAI] ([idHangDT])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([idKH])
REFERENCES [dbo].[KHACHHANG] ([idKH])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([idNV])
REFERENCES [dbo].[NHANVIEN] ([idNV])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[NHAPKHO]  WITH CHECK ADD FOREIGN KEY([idNCC])
REFERENCES [dbo].[NHACUNGCAP] ([idNCC])
GO
ALTER TABLE [dbo].[NHAPKHO]  WITH CHECK ADD FOREIGN KEY([idNV])
REFERENCES [dbo].[NHANVIEN] ([idNV])
GO
/****** Object:  StoredProcedure [dbo].[insert_CTHD]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insert_CTHD] @idHD varchar(10), @idDienThoai varchar(10), @soLuong int, @giaBan int, @khuyenMai int, @status int
as
	insert into CHITIETHOADON(idHoaDon, idDienThoai, soLuong, giaBan, khuyenMai, status) values (@idHD, @idDienThoai, @soLuong, @giaBan, @khuyenMai, @status)
GO
/****** Object:  StoredProcedure [dbo].[SapXepThongKeTopBanChay]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Thống kê điện thoại được bán chạy giảm dần
CREATE PROC [dbo].[SapXepThongKeTopBanChay] 
AS
BEGIN
	select * 
	from ThongKeDienThoai() Tk
	Order by Tk.SL Desc
END
GO
/****** Object:  StoredProcedure [dbo].[sp_addDienThoai]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_addDienThoai] 
@idDienThoai varchar(10), @tenDienThoai varchar(150), @mauSac nvarchar(20), @dungLuong int, @boNho int, @soLuong int, @giaBan float
AS
BEGIN
	IF EXISTS(SELECT * FROM DIENTHOAI WHERE DIENTHOAI.idDienThoai = @idDienThoai)
	BEGIN
		UPDATE DIENTHOAI SET soLuong = soLuong + @soLuong
		where idDienThoai = @idDienThoai
	end
	ELSE 
		INSERT INTO DIENTHOAI(idDienThoai, tenDienThoai, mauSac, dungLuong, boNho,soLuong, giaBan) 
			VALUES(@idDienThoai, @tenDienThoai, @mauSac, @dungLuong, @boNho, @soLuong, @giaBan)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Changepassword]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_Changepassword]
@username varchar(50), @password varchar(500), @newpassword varchar(500), @repassword varchar(500)
as
begin
	declare @old varchar(500) = (Select password from NHANVIEN
												where username = @username and password = @password);
	if(@password !='' and @newpassword !='' and @repassword !='')
	begin
		if(@password = @old and @newpassword != @password)
			if(@newpassword = @repassword)
				begin
					update NHANVIEN
					set password = @newpassword
					where username = @username
					return 1;
				end
			else
				return 0;
				rollback
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCTHDforHD]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DeleteCTHDforHD] @idHoaDon varchar(10)
as
	begin transaction

	Delete CHITIETHOADON where idHoaDon = @idHoaDon

	Delete HOADON where idHoaDon = @idHoaDon

	commit transaction
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteHDT]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DeleteHDT](@idHDT varchar(10))
as
begin
	delete HANGDIENTHOAI
	where idHangDT = @idHDT
end
GO
/****** Object:  StoredProcedure [dbo].[sp_deleteKhachHang]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Xóa khách hàng ,Tran
CREATE proc [dbo].[sp_deleteKhachHang] @idKH varchar(10)
as
BEGIN TRANSACTION
DELETE KHACHHANG
WHERE idKH =  @idKH
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteNCC]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DeleteNCC](@idNCC varchar(10))
as
begin
	delete NHACUNGCAP
	where idNCC = @idNCC
end

--exec sp_DeleteNCC'NCC100'

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteNhanVien]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DeleteNhanVien] @idNV nvarchar(10)
as 
begin
	declare @status int = dbo.fn_checkAccount(@idNV)
	if(@status = 0)
		begin
			delete NHANVIEN where idNV = @idNV
		end
	else
		rollback
end
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteNhapKho]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- Xóa Nhập kho
	create proc [dbo].[sp_DeleteNhapKho] @idNK varchar(10)
	as
		DELETE NHAPKHO where idNhapKho = @idNK
GO
/****** Object:  StoredProcedure [dbo].[sp_deletePhone]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_deletePhone] @idDT varchar(10)
as 
begin tran
	delete DIENTHOAI
	where idDienThoai = @idDT
commit
GO
/****** Object:  StoredProcedure [dbo].[sp_Payment]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_Payment] @idHoaDon varchar(10)
as
begin transaction
	update CHITIETHOADON set status = 1 where idHoaDon = @idHoaDon
	update HOADON set status = 1 where idHoaDon = @idHoaDon
	declare @TongTien float = (select dbo.fn_SumMoneyCTHD(@idHoaDon))
	update HOADON set thanhTien = @TongTien where idHoaDon = @idHoaDon
commit transaction
GO
/****** Object:  StoredProcedure [dbo].[sp_revise_HoaDon]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Thủ tục thêm hóa đơn
create proc [dbo].[sp_revise_HoaDon] @idHD varchar(10),
							@idNV varchar(10),
							@idKH varchar(10),
							@ngayLapHoaDon varchar(30) ='',
							@soLuong int = 0,
							@tongGiaBan float = 0,
							@diemThuong float = 0,
							@thanhTien float = 0,
							@status int = 0,
							@StatementType NVARCHAR(20) = 'Insert'
as
	begin
	IF @StatementType = 'Insert'
        BEGIN
		insert HOADON values(@idHD ,
							@idNV ,
							@idKH ,
							@soLuong ,
							@tongGiaBan ,
							@diemThuong ,
							@ngayLapHoaDon , 
							@thanhTien ,
							@status);
	END
--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE HOADON
			SET
				idHoaDon= @idHD ,
							idNV=@idNV ,
							idKH = @idKH ,
							soLuong = @soLuong ,
							tongGiaBan = @tongGiaBan ,
							diemThuong= @diemThuong ,
							ngayLapHoaDon = @ngayLapHoaDon , 
							thanhTien = @thanhTien ,
							status = @status
			where idHoaDon = @idHD
		END 
	end
GO
/****** Object:  StoredProcedure [dbo].[sp_reviseCTNK]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--BẢNG NHÀ CUNG CẤP
CREATE PROC [dbo].[sp_reviseCTNK](@idCTPNK int,
								  @idNhapKho nvarchar(10),
								  @idDienThoai varchar(10),
								  @soLuong int,
								  @donGiaGoc float,
								  @thanhTien float,
								  @status int = 1,
							      @StatementType NVARCHAR(20) = 'Insert')
as
	begin
	IF @StatementType = 'Insert'
        BEGIN
		insert CHITIETPHIEUNHAPKHO values(
								  @idNhapKho ,
								  @idDienThoai ,
								  @soLuong ,
								  @donGiaGoc ,
								  @thanhTien ,
								  @status);
	END
--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE CHITIETPHIEUNHAPKHO
			SET
				idNhapKho = @idNhapKho ,
				idDienThoai = @idDienThoai ,
				soLuong = @soLuong ,
				donGiaGoc = @donGiaGoc ,
				thanhTien = @thanhTien ,
				status = @status 		
			where idChiTietPNK = @idCTPNK
		END 
	end
GO
/****** Object:  StoredProcedure [dbo].[sp_ReviseHDT]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ReviseHDT] (@idHangDT varchar(10), @tenHangDT nvarchar(150), @status int = 1, @StatementType NVARCHAR(20) = 'Insert')
as
begin
	IF @StatementType = 'Insert'
        BEGIN
			insert HANGDIENTHOAI values(@idHangDT, @tenHangDT, @status);
		END
	--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE HANGDIENTHOAI
			SET 
				idHangDT = @idHangDT,
				tenHangDT = @tenHangDT,
				status = @status
			WHERE idHangDT = @idHangDT
		END 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_reviseNCC]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--BẢNG NHÀ CUNG CẤP
CREATE PROC [dbo].[sp_reviseNCC](@idNCC varchar(10),
			@tenNCC nvarchar(150),
			@sdt varchar(20),
			@email varchar(150),
			@diachi nvarchar(250),
			@status int = 1,
			@StatementType NVARCHAR(20) = 'Insert')
as
	begin
	IF @StatementType = 'Insert'
        BEGIN
		insert NHACUNGCAP values(@idNCC, @tenNCC, @sdt, @email ,@diachi, @status);
	END
--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE NHACUNGCAP
			SET 
				idNCC = @idNCC,
				tenNCC = @tenNCC,
				sdt = @sdt,
				email = @email,
				diaChi = @diachi,
				status = @status
			WHERE idNCC = @idNCC
		END 
	end

GO
/****** Object:  StoredProcedure [dbo].[sp_ReviseNhanVien]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ReviseNhanVien] (@idNV varchar(10),					
						@tenNV nvarchar(150),
						@usename varchar(50),
						@password varchar(500), 
						@sdt varchar(20),
						@email varchar(150),
						@pq int =0,
						@status int = 1, 
						@StatementType NVARCHAR(20) = 'Insert')
as
begin
	IF @StatementType = 'Insert'
		BEGIN
			insert NHANVIEN values(@idNV, @tenNV, @usename, @password ,@sdt, @email, @pq, @status);
		END
	--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE NHANVIEN
			SET 			
				tenNV =@tenNV,
				username =@usename,
				password  =@password,
				sdt =@sdt,
				email =@email,
				phanQuyen = @pq,
				status = @status
			WHERE idNV =@idNV
		END 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_ReviseNhapKho]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--BẢNG NHÀ CUNG CẤP
create PROC [dbo].[sp_ReviseNhapKho](@idNK varchar(10),
								  @idNV nvarchar(10),
								  @idNCC varchar(10),
								  @ngayNhapKho varchar(30),
								  @tongSoLuong int,
								  @thanhTien float,
								  @status int = 0,
							      @StatementType NVARCHAR(20) = 'Insert')
as
	begin
	IF @StatementType = 'Insert'
        BEGIN
		insert NHAPKHO values(
								  @idNK ,
								  @idNV ,
								  @idNCC ,
								  @ngayNhapKho ,
								  @tongSoLuong ,
								  @thanhTien ,
								  @status );
	END
--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE NHAPKHO
			SET
				idNhapKho = @idNK ,
				idNV = @idNV ,
				idNCC = @idNCC ,
				ngayNhapKho = @ngayNhapKho ,
				thanhTien = @thanhTien ,
				status = @status 		
			where idNhapKho = @idNK
		END 
	end
GO
/****** Object:  StoredProcedure [dbo].[sp_RevisePhone]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_RevisePhone] (@idDT varchar(10),
						@idHDT varchar(10),
						@tenDT nvarchar(150),
						@ms nvarchar(20),
						@dl int, 
						@bonho int,
						@sl int =0,
						@gia float=0,
						@khuyenmai int =0,
						@status int=1,
						@StatementType NVARCHAR(20) = '')
as
	begin
	IF @StatementType = 'Insert'
        BEGIN
		insert DIENTHOAI values(@idDT, @idHDT, @tenDT, @ms ,@dl, @bonho, @sl, @gia, @khuyenmai, @status);
	END

--cập nhập điện thoại theo mã điện thoại
	IF @StatementType = 'Update'
		BEGIN
			UPDATE DIENTHOAI
			SET 
				idHangDT =@idHDT,
				tenDienThoai =@tenDT,
				mauSac =@ms,
				dungLuong =@dl,
				boNho =@bonho,
				soLuong =@sl,
				giaBan =@gia,
				khuyenMai =@khuyenmai,
				status = @status
			WHERE idDienThoai =@idDT
		END 
--loại bỏ điện thoại theo mã điện thoại
	ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM DIENTHOAI
            WHERE  DIENTHOAI.idDienThoai = @idDT
        END
-- ngừng kinh doanh or hết hàng
	ELSE IF @StatementType = 'SoldOut'
		BEGIN
			UPDATE DIENTHOAI
			SET status = 0
			where idDienThoai = @idDT 
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_SumSoTienBanDuoc]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Thống kê tổng tiền bán điện thoại bán theo ngày tháng năm chưa trừ liền giá gốc
create proc [dbo].[sp_SumSoTienBanDuoc] @ngay varchar(30), @int int
as
begin
if (@int = 1)
	begin
		select Sum (hd.thanhTien) [Tổng Thu]
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay)
	end
if (@int = 2)
	begin
		select  Sum (hd.thanhTien) [Tổng Thu]
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay)
	end
if (@int = 3)
	begin
		select Sum (hd.thanhTien) [Tổng Thu]
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay) and DAY(h.ngayLapHoaDon)=DAY(@ngay)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_themkhachhang]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_themkhachhang]

@idKH varchar(10), @tenkh nvarchar(50),@sdt varchar(20)
as
begin
	insert into KHACHHANG(idKH,tenKH,sdt) values (@idKH,@tenkh,@sdt)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_themNhanVien]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_themNhanVien]

	@idNV varchar(10), @tenNV nvarchar(150), @taikhoan varchar(50), @matkhau varchar(500), @sdt varchar(20), @mail varchar(150), @phanquyen int, @status int
as
begin 
	insert into NHANVIEN 
	values (@idNV, @tenNV ,@taikhoan ,@matkhau, @sdt, @mail, @phanquyen, @status)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_thongKeTongDoanhThu]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--10.Thống kê tổng doanh thu
create proc [dbo].[sp_thongKeTongDoanhThu]
as
begin
select ngayLapHoaDon, sum(soLuong) as TongSoLuong, sum(tongGiaBan) as TongThanhTien from HOADON where status=1 group by ngayLapHoaDon
end
GO
/****** Object:  StoredProcedure [dbo].[sp_TKDTTheoNTN]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Thống kê những điện thoại bán trong ngày3, tháng2, năm1,
create proc [dbo].[sp_TKDTTheoNTN] @ngay varchar(30), @int int
as
begin
if (@int = 1)
	begin
		select kh.idKH, hd.idHoaDon, tenKH, sdt, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay)
	end
if (@int = 2)
	begin
		select kh.idKH, hd.idHoaDon, tenKH, sdt, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay)
	end
if (@int = 3)
	begin
		select kh.idKH, hd.idHoaDon, tenKH, sdt, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien
		from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
		where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and YEAR(h.ngayLapHoaDon)=YEAR(@ngay) and MONTH(h.ngayLapHoaDon)=MONTH(@ngay) and DAY(h.ngayLapHoaDon)=DAY(@ngay)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ViewCTHD]    Script Date: 11/23/2022 1:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Chi tiết 1 hóa đơn khi nhấn vào 1 id hóa đơn trên from hóa đơn
create proc [dbo].[sp_ViewCTHD] @idHD varchar(10)
as
begin
	select kh.idKH, hd.idHoaDon, tenKH, sdt, tenDienThoai, mauSac, dungLuong, boNho,hd.soLuong, hd.khuyenMai, hd.thanhTien
	from CHITIETHOADON hd, DIENTHOAI dt, HOADON h, KHACHHANG kh
	where hd.idDienThoai = dt.idDienThoai and hd.idHoaDon =h.idHoaDon and h.idKH = kh.idKH and hd.idHoaDon = @idHD
end
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "hd"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dt"
            Begin Extent = 
               Top = 6
               Left = 256
               Bottom = 136
               Right = 426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "hdt"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 251
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dtbanduoc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dtbanduoc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HDT"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infdienthoai'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infdienthoai'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[25] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HOADON"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infHoaDon'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infHoaDon'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "KHACHHANG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infkhachhang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infkhachhang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "NHACUNGCAP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infNhaCungCap'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infNhaCungCap'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "NHANVIEN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infNhanVien'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_infNhanVien'
GO
ALTER DATABASE [PMBanDienThoai03] SET  READ_WRITE 
GO

use [PMBanDienThoai03]
go
ALTER TABLE NHANVIEN
ADD UNIQUE (username);
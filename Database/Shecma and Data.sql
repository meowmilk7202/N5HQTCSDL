USE [master]
GO
/****** Object:  Database [PMBanDienThoai]    Script Date: 04/11/2022 16:18:07 ******/
CREATE DATABASE [PMBanDienThoai]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PMBanDienThoai', FILENAME = N'D:\SQL2016\MSSQL13.MSSQLSERVER\MSSQL\DATA\PMBanDienThoai.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PMBanDienThoai_log', FILENAME = N'D:\SQL2016\MSSQL13.MSSQLSERVER\MSSQL\DATA\PMBanDienThoai_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [PMBanDienThoai] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PMBanDienThoai].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PMBanDienThoai] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET ARITHABORT OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PMBanDienThoai] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PMBanDienThoai] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PMBanDienThoai] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PMBanDienThoai] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET RECOVERY FULL 
GO
ALTER DATABASE [PMBanDienThoai] SET  MULTI_USER 
GO
ALTER DATABASE [PMBanDienThoai] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PMBanDienThoai] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PMBanDienThoai] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PMBanDienThoai] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PMBanDienThoai] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'PMBanDienThoai', N'ON'
GO
ALTER DATABASE [PMBanDienThoai] SET QUERY_STORE = OFF
GO
USE [PMBanDienThoai]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [PMBanDienThoai]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_checkAccount]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  UserDefinedFunction [dbo].[fn_loinhuan_ngay]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_slhoadon]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_tonghoadon_per_day]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  Table [dbo].[HANGDIENTHOAI]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infHangDT]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infHangDT]
as
select idHangDT,tenHangDT, status
from HANGDIENTHOAI
GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infNhaCungCap]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_infNhaCungCap]
AS
SELECT        idNCC, tenNCC, diaChi, sdt, email, status
FROM            dbo.NHACUNGCAP
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[idKH] [varchar](10) NOT NULL,
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
/****** Object:  UserDefinedFunction [dbo].[fn_khachhang_sdt]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_khachhang_sdt](@sdt varchar(20))
returns table
as
return(select * from KHACHHANG where sdt =@sdt)
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON](
	[idHoaDon] [varchar](10) NOT NULL,
	[idNV] [varchar](10) NULL,
	[idKH] [varchar](10) NULL,
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
/****** Object:  UserDefinedFunction [dbo].[fn_tinhtienhoadonkhachhang]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  Table [dbo].[NHAPKHO]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infNhapKho]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infNhapKho]
AS
(
	select * from NHAPKHO
	where status = 1
)
GO
/****** Object:  View [dbo].[v_infHoaDon]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infHoaDon]
as
	select idHoaDon as MaHoaDon, idNV as MaNV, idKH as MaKH, soluong as SoLuong, tongGiaBan as TongGiaBan, diemThuong as DiemThuong, ngayLapHoaDon as NgayLapHD, thanhTien
	from HOADON
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infNhanVien]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infNhanVien]
as
	select idNV as MaNhanVien, tenNV as TenNV, username, password, sdt as SoDienThoai, email, phanQuyen, status
	from NHANVIEN
GO
/****** Object:  View [dbo].[v_loaddanhsachkho]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infkhachhang]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--4.Hien thi thong tin khach hang đã mua sản phẩm tại cửa hàng
create view [dbo].[v_infkhachhang]
as
	select hd.idHoaDon, kh.tenKH, kh.sdt, hd.thanhTien,hd.ngayLapHoaDon
	from KHACHHANG as KH, HOADON as HD
	where hd.idKH =kh.idKH 

--select distinct * from v_infkhachhang
--drop view v_infkhachhang

-------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[DIENTHOAI]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  Table [dbo].[CHITIETHOADON]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETHOADON](
	[idChiTietHoaDon] [varchar](10) NOT NULL,
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
/****** Object:  View [dbo].[v_dtbanduoc]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_dtbanduoc]
as 
	select dt.idDienThoai ,dt.tenDienThoai,hd.soLuong,dt.mauSac,dt.dungLuong,dt.boNho,dt.khuyenMai,dt.giaBan,hd.thanhTien, dt.status
	from CHITIETHOADON as hd ,HANGDIENTHOAI as hdt ,DIENTHOAI as dt
	where hd.idDienThoai = dt.idDienThoai and dt.idHangDT = hdt.idHangDT
--select distinct * from v_dtbanduoc
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Authentication]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  View [dbo].[v_infdienthoai]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_infdienthoai]
as
	select  DT.idHangDT,DT.idDienThoai,HDT.tenHangDT, DT.tenDienThoai, DT.mauSac, DT.dungLuong,DT.boNho,DT.khuyenMai,DT.giaBan,DT.soLuong
	from DIENTHOAI as DT, HANGDIENTHOAI as HDT
	where DT.idHangDT = HDT.idHangDT
GO
/****** Object:  Table [dbo].[CHITIETPHIEUNHAPKHO]    Script Date: 04/11/2022 16:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETPHIEUNHAPKHO](
	[idChiTietPNK] [varchar](10) NOT NULL,
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
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD01', N'HD01', N'DT01', 1, 900, 10, 900, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD02', N'HD02', N'DT12', 2, 600, 0, 1200, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD03', N'HD03', N'DT03', 1, 700, 0, 700, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD04', N'HD04', N'DT32', 3, 800, 0, 2400, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD05', N'HD05', N'DT11', 5, 400, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD06', N'HD06', N'DT23', 4, 500, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD07', N'HD07', N'DT54', 2, 1000, 0, 2000, 1)
INSERT [dbo].[CHITIETHOADON] ([idChiTietHoaDon], [idHoaDon], [idDienThoai], [soLuong], [giaBan], [khuyenMai], [thanhTien], [status]) VALUES (N'CTHD08', N'HD08', N'DT21', 1, 1200, 0, 1200, 1)
GO
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK01', N'NK01', N'DT21', 20, 700, 14000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK02', N'NK02', N'DT57', 10, 1000, 10000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK03', N'NK03', N'DT32', 14, 500, 7000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK04', N'NK01', N'DT03', 30, 1200, 36000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK05', N'NK01', N'DT55', 4, 200, 800, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK06', N'NK04', N'DT24', 100, 1000, 100000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK07', N'NK04', N'DT54', 20, 800, 16000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK08', N'NK03', N'DT06', 20, 500, 10000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK09', N'NK02', N'DT09', 20, 850, 17000, 1)
INSERT [dbo].[CHITIETPHIEUNHAPKHO] ([idChiTietPNK], [idNhapKho], [idDienThoai], [soLuong], [donGiaGoc], [thanhTien], [status]) VALUES (N'PNK10', N'NK03', N'DT63', 20, 900, 18000, 1)
GO
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT01', N'HDT01', N'IPhone 11', N'Đen', 6, 64, 1, 800, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT03', N'HDT01', N'IPhone 11', N'Đen', 6, 128, 32, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT04', N'HDT01', N'IPhone 11', N'Đen', 6, 256, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT05', N'HDT01', N'IPhone 11', N'Trắng', 6, 64, 1, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT06', N'HDT01', N'IPhone 11', N'Trắng', 6, 128, 20, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT07', N'HDT01', N'IPhone 11', N'Trắng', 6, 256, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT08', N'HDT01', N'IPhone 11', N'Trắng', 6, 512, 1, 700, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT09', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 64, 20, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT10', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 128, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT11', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 256, 5, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT12', N'HDT01', N'IPhone 11', N'Xanh lá', 6, 512, 2, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT13', N'HDT01', N'IPhone 11', N'Đỏ', 6, 64, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT14', N'HDT01', N'IPhone 11', N'Đỏ', 6, 128, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT15', N'HDT01', N'IPhone 11', N'Đỏ', 6, 256, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT16', N'HDT01', N'IPhone 11', N'Đỏ', 6, 512, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT17', N'HDT01', N'IPhone 12', N'Đen', 6, 64, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT18', N'HDT01', N'IPhone 12', N'Đen', 6, 128, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT19', N'HDT01', N'IPhone 12', N'Đen', 6, 256, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT20', N'HDT01', N'IPhone 12', N'Đen', 6, 512, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT21', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 64, 19, 950, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT22', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 128, 0, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT23', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 256, 4, 950, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT24', N'HDT01', N'IPhone 12', N'Xanh lá', 6, 512, 100, 950, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT25', N'HDT01', N'IPhone 12', N'Đỏ', 6, 64, 0, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT26', N'HDT01', N'IPhone 12', N'Đỏ', 6, 128, 0, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT27', N'HDT01', N'IPhone 12', N'Đỏ', 6, 256, 0, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT28', N'HDT01', N'IPhone 12', N'Đỏ', 6, 512, 0, 950, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT29', N'HDT01', N'IPhone 13', N'Đen', 6, 64, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT30', N'HDT01', N'IPhone 13', N'Đen', 6, 128, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT31', N'HDT01', N'IPhone 13', N'Đen', 6, 256, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT32', N'HDT01', N'IPhone 13', N'Đen', 6, 512, 11, 1200, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT33', N'HDT01', N'IPhone 13', N'Trắng', 6, 64, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT34', N'HDT01', N'IPhone 13', N'Trắng', 6, 128, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT35', N'HDT01', N'IPhone 13', N'Trắng', 6, 256, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT36', N'HDT01', N'IPhone 13', N'Trắng', 6, 512, 0, 1200, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT37', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 64, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT38', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 128, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT39', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 256, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT40', N'HDT01', N'IPhone 13', N'Xanh lá', 6, 512, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT41', N'HDT01', N'IPhone 13', N'Đỏ', 6, 64, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT42', N'HDT01', N'IPhone 13', N'Đỏ', 6, 128, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT43', N'HDT01', N'IPhone 13', N'Đỏ', 6, 256, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT44', N'HDT01', N'IPhone 13', N'Đỏ', 6, 512, 0, 1300, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT45', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 64, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT46', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 128, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT47', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 256, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT48', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Trắng', 6, 64, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT49', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đen', 6, 128, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT50', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Xanh', 6, 256, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT51', N'HDT02', N'Samsung Galaxy Z Flip4 5G', N'Đỏ', 6, 512, 0, 700, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT52', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Trắng', 6, 64, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT53', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Đen', 6, 128, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT54', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Xanh', 6, 256, 18, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT55', N'HDT02', N'Samsung Galaxy S22 Ultra 5G', N'Xanh lá', 6, 512, 4, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT56', N'HDT02', N'Samsung Galaxy A53 5G', N'Trắng', 6, 64, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT57', N'HDT02', N'Samsung Galaxy A53 5G', N'Đen', 6, 128, 10, 720, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT58', N'HDT02', N'Samsung Galaxy A53 5G', N'Xanh', 6, 256, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT59', N'HDT02', N'Samsung Galaxy A53 5G', N'Đỏ', 6, 512, 0, 720, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT60', N'HDT02', N'Samsung Galaxy M53', N'Trắng', 6, 64, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT61', N'HDT02', N'Samsung Galaxy M53', N'Đen', 6, 128, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT62', N'HDT02', N'Samsung Galaxy M53', N'Xanh', 6, 256, 0, 900, 0, 0)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT63', N'HDT02', N'Samsung Galaxy M53', N'Đỏ', 6, 512, 20, 900, 0, 1)
INSERT [dbo].[DIENTHOAI] ([idDienThoai], [idHangDT], [tenDienThoai], [mauSac], [dungLuong], [boNho], [soLuong], [giaBan], [khuyenMai], [status]) VALUES (N'DT64', N'HDT02', N'Samsung Galaxy M73', N'Đen', 6, 512, 0, 1000, 0, 0)
GO
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT01', N'Vivo', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT02', N'Poco', 0)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT022', N'IPhone', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT023', N'IPhone', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT03', N'Oppo', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT04', N'Xiaomi', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT05', N'Realme', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT070', N'Toan', 1)
INSERT [dbo].[HANGDIENTHOAI] ([idHangDT], [tenHangDT], [status]) VALUES (N'HDT20', N'RealPhone', 1)
GO
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD01', N'NV03', N'KH01', 1, 900, 9, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD02', N'NV03', N'KH02', 2, 1200, 12, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD03', N'NV03', N'KH03', 1, 700, 7, N'2022-11-9', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD04', N'NV03', N'KH04', 3, 2400, 24, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD05', N'NV04', N'KH03', 5, 2000, 20, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD06', N'NV04', N'KH03', 4, 2000, 20, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD07', N'NV04', N'KH01', 2, 2000, 20, N'Oct 26 2022  5:58PM', 0, 1)
INSERT [dbo].[HOADON] ([idHoaDon], [idNV], [idKH], [soluong], [tongGiaBan], [diemThuong], [ngayLapHoaDon], [thanhTien], [status]) VALUES (N'HD08', N'NV04', N'KH02', 1, 1200, 12, N'Oct 26 2022  5:58PM', 0, 1)
GO
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (N'KH01', N'Nguyễn Văn A', N'0326526984', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (N'KH02', N'Nguyễn Thị B', N'0962333621', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (N'KH03', N'Trần Văn C', N'0946312497', 0, 0)
INSERT [dbo].[KHACHHANG] ([idKH], [tenKH], [sdt], [diemThuong], [status]) VALUES (N'KH04', N'Trần Đào Trang', N'0389421573', 0, 0)
GO
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC01', N'Apple Việt Nam', N'043 9743 488', N'applevn@avn.com.vn', N'Tầng 12, số 29 Nguyễn Đình Chiểu, Phường Lê Đại Hành, Quận Hai Bà Trưng, Hà Nội', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC02', N'SamSung Việt Nam', N'028 3256 523', N'samsungvn@ssvn.com.vn', N'Tầng 6, Tòa nhà Sài Gòn Royal, 91 Pasteur, P.Bến Nghé, Q.1, TP Hồ Chí Minh', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC03', N'Oppo Việt Nam', N'032 1800 080', N'oppovn@opvn.vn', N'879 Nguyễn Kiệm, P.3, Gò Vấp, HCM', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC04', N'Xiaomi Việt Nam', N'0898 516 156', N'xiaomi.vn@gmail.com', N'TP Hồ Chí Minh', 0)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC05', N'LG Việt Nam', N'032 1800 080', N'lgvn@lg.vn', N'879 Nguyễn Kiệm, P.3, Gò Vấp, HCM', 1)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC06', N'Vivo Việt Nam', N'032 1800 080', N'vivo@lg.vn', N'879 Nguyễn Kiệm, P.3, Gò Vấp, HCM', 1)
INSERT [dbo].[NHACUNGCAP] ([idNCC], [tenNCC], [sdt], [email], [diaChi], [status]) VALUES (N'NCC07', N'klgklvndklnxv', N'032 1800 080', N'vivo@lg.vn', N'879 Nguyễn Kiệm, P.3, Gò Vấp, HCM', 1)
GO
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV01', N'Nguyễn Hoàng Toàn', N'admin01', N'admin01', N'035 3131 225', N'admin01@shoestore.com', 1, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV02', N'Nguyễn Công Thành', N'admin02', N'admin02', N'097 8764 222', N'admin02@shoestore.com', 1, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV03', N'Ngô Quang Huy', N'user01', N'user01', N'01231312120', N'user01@shoestore.com', 0, 1)
INSERT [dbo].[NHANVIEN] ([idNV], [tenNV], [username], [password], [sdt], [email], [phanQuyen], [status]) VALUES (N'NV04', N'Phan Hoàng Thanh Sơn', N'user02', N'user02', N'01231312920', N'user02@shoestore.com', 0, 1)
GO
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK01', N'NV01', N'NCC01', N'26/09/2022', 54, 50800, 1)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK02', N'NV02', N'NCC02', N'26/09/2022', 30, 27000, 1)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK03', N'NV03', N'NCC03', N'Oct 26 2022  5:58PM', 54, 35000, 1)
INSERT [dbo].[NHAPKHO] ([idNhapKho], [idNV], [idNCC], [ngayNhapKho], [tongSoLuong], [thanhTien], [status]) VALUES (N'NK04', N'NV01', N'NCC04', N'Oct 26 2022  5:58PM', 120, 116000, 1)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [unique_dt]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  Index [UQ__NHACUNGC__AFCF872ABCF4EEBA]    Script Date: 04/11/2022 16:18:07 ******/
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
ON UPDATE CASCADE
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
/****** Object:  StoredProcedure [dbo].[sp_addDienThoai]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Changepassword]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_DeleteHDT]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_DeleteNCC]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_DeleteNhanVien]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_deletePhone]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ReviseHDT]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_reviseNCC]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ReviseNhanVien]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_RevisePhone]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_themkhachhang]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_themNhanVien]    Script Date: 04/11/2022 16:18:07 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_thongKeTongDoanhThu]    Script Date: 04/11/2022 16:18:07 ******/
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
USE [master]
GO
ALTER DATABASE [PMBanDienThoai] SET  READ_WRITE 
GO

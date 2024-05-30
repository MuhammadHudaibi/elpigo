import 'package:get/get.dart';

import 'package:elpigo/app/modules/customer/home_customer/bindings/home_customer_binding.dart';
import 'package:elpigo/app/modules/customer/home_customer/views/home_customer_view.dart';
import 'package:elpigo/app/modules/customer/layout_customer/bindings/layout_customer_binding.dart';
import 'package:elpigo/app/modules/customer/layout_customer/views/layout_customer_view.dart';
import 'package:elpigo/app/modules/owner/home_owner/bindings/home_owner_binding.dart';
import 'package:elpigo/app/modules/owner/home_owner/views/home_owner_view.dart';
import 'package:elpigo/app/modules/owner/layout_owner/bindings/layout_owner_binding.dart';
import 'package:elpigo/app/modules/owner/layout_owner/views/layout_owner_view.dart';
import 'package:elpigo/app/modules/owner/riwayat_pembelian/bindings/riwayat_penjualan_binding.dart';
import 'package:elpigo/app/modules/owner/riwayat_pembelian/views/riwayat_penjualan_view.dart';
import 'package:elpigo/app/modules/customer/riwayat_pemesanan/bindings/riwayat_pemesanan_binding.dart';
import 'package:elpigo/app/modules/customer/riwayat_pemesanan/views/riwayat_pemesanan_view.dart';

import '../modules/customer/Profile/bindings/profile_binding.dart';
import '../modules/customer/Profile/views/profile_view.dart';
import '../modules/confirm/bindings/confirm_binding.dart';
import '../modules/confirm/views/confirm_view.dart';
import '../modules/customer/loginCustomer/bindings/login_customer_binding.dart';
import '../modules/customer/loginCustomer/views/login_customer_view.dart';
import '../modules/customer/registerCustomer/bindings/register_customer_binding.dart';
import '../modules/customer/registerCustomer/views/register_costumer.dart';
import '../modules/customer/registerCustomer/views/uplode_data_rt.dart';
import '../modules/customer/registerCustomer/views/uplode_data_um.dart';
import '../modules/owner/loginOwner/bindings/login_owner_binding.dart';
import '../modules/owner/loginOwner/views/login_owner_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM,
      page: () => const ConfirmView(),
      binding: ConfirmBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_OWNER,
      page: () => LoginOwnerView(),
      binding: LoginOwnerBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_CUSTOMER,
      page: () => const LoginCustomerView(),
      binding: LoginCustomerBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_CUSTOMER,
      page: () => const RegisterCustomerView(),
      binding: RegisterCustomerBinding(),
    ),
    GetPage(
      name: Routes.UPLOAD_UMKM_DATA,
      page: () => UploadUMKMDataView(),
    ),
    GetPage(
      name: Routes.UPLOAD_RT_DATA,
      page: () => UploadRTDataView(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => Profileview(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HOME_OWNER,
      page: () => HomeOwnerView(),
      binding: HomeOwnerBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT_OWNER,
      page: () => LayoutOwnerView(),
      binding: LayoutOwnerBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_PENJUALAN,
      page: () => RiwayatPenjualanView(),
      binding: RiwayatPenjualanBinding(),
    ),
    GetPage(
      name: _Paths.HOME_CUSTOMER,
      page: () => HomeCustomerView(),
      binding: HomeCustomerBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT_CUSTOMER,
      page: () => LayoutCustomerView(),
      binding: LayoutCustomerBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_PEMESANAN,
      page: () => RiwayatPemesananView(),
      binding: RiwayatPemesananBinding(),
    ),
  ];
}

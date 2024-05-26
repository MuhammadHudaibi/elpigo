part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const CONFIRM = _Paths.CONFIRM;
  static const LOGIN_OWNER = _Paths.LOGIN_OWNER;
  static const LOGIN_CUSTOMER = _Paths.LOGIN_CUSTOMER;
  static const REGISTER_CUSTOMER = _Paths.REGISTER_CUSTOMER;
  static const UPLOAD_UMKM_DATA = _Paths.UPLOAD_UMKM_DATA;
  static const UPLOAD_RT_DATA = _Paths.UPLOAD_RT_DATA;
  static const PROFILE = _Paths.PROFILE;
  static const HOME_OWNER = _Paths.HOME_OWNER;
  static const LAYOUT_OWNER = _Paths.LAYOUT_OWNER;
  static const RIWAYAT_PEMBELIAN = _Paths.RIWAYAT_PEMBELIAN;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const CONFIRM = '/confirm';
  static const LOGIN_OWNER = '/login-owner';
  static const LOGIN_CUSTOMER = '/login-customer';
  static const REGISTER_CUSTOMER = '/register-customer';
  static const UPLOAD_UMKM_DATA = '/upload-umkm';
  static const UPLOAD_RT_DATA = '/upload-rt';
  static const PROFILE = '/profile';
  static const HOME_OWNER = '/home-owner';
  static const LAYOUT_OWNER = '/layout-owner';
  static const RIWAYAT_PEMBELIAN = '/riwayat-pembelian';
}

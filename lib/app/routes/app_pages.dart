import 'package:get/get.dart';

import '../modules/confirm/bindings/confirm_binding.dart';
import '../modules/confirm/views/confirm_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loginCustomer/bindings/login_customer_binding.dart';
import '../modules/loginCustomer/views/login_customer_view.dart';
import '../modules/loginOwner/bindings/login_owner_binding.dart';
import '../modules/loginOwner/views/login_owner_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
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
  ];
}

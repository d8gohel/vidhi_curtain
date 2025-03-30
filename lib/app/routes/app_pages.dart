// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/views/auth_view.dart';
import '../modules/Bills/bindings/bills_binding.dart';
import '../modules/Bills/views/bills_view.dart';
import '../modules/Orders/bindings/orders_binding.dart';
import '../modules/Orders/views/orders_view.dart';
import '../modules/Presentation/bindings/presentation_binding.dart';
import '../modules/Presentation/views/presentation_view.dart';
import '../modules/Products/bindings/products_binding.dart';
import '../modules/Products/views/products_view.dart';
import '../modules/User/bindings/user_binding.dart';
import '../modules/User/views/user_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/window/bindings/window_binding.dart';
import '../modules/window/views/window_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => UserListScreen(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.PRESENTATION,
      page: () => const PresentationView(),
      binding: PresentationBinding(),
    ),
    GetPage(
      name: _Paths.BILLS,
      page: () => BillsView(),
      binding: BillsBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.WINDOW,
      page: () => WindowListScreen(userId: 0),
      binding: WindowBinding(),
    ),
  ];
}

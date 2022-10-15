import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:news_app/views/home_page.dart';
import 'package:news_app/views/splash_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const initial = '/splashScreen';
  static final routes = [
    GetPage(
        name: '/splashScreen',
        page: () => const SplashScreen(),
        transition: Transition.zoom),
    GetPage(
        name: '/homePage',
        page: () => HomePage(),
        transition: Transition.fadeIn),
  ];
}

import 'package:chakulalink/presentation/ngo_dashboard_screen/ngo_dashboard_screen.dart';
import 'package:chakulalink/presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import 'package:chakulalink/presentation/distributor_dashboard_screen/distributor_dashboard_screen.dart';
import 'package:chakulalink/presentation/donor_dashboard_screen/donor_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:chakulalink/presentation/request_order/request_order.dart';
import 'package:chakulalink/presentation/location_screen/location_screen.dart';
import 'package:chakulalink/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:chakulalink/presentation/login_screen/login_screen.dart';
import 'package:chakulalink/presentation/splash_screen/splash_screen.dart';
import 'package:chakulalink/presentation/donation_categories/donation_categories.dart';
import 'package:chakulalink/presentation/wishlist/wishlist.dart';
import 'package:chakulalink/presentation/orders_to_donor/orders_to_donor.dart';
import 'package:chakulalink/presentation/donate_order/donate_order.dart';
import 'package:chakulalink/presentation/donation_reports/donation_reports.dart';
import 'package:chakulalink/presentation/available_orders/available_orders.dart';
import 'package:chakulalink/presentation/orders_in_transit/orders_in_transit.dart';
import 'package:chakulalink/presentation/orders_reports/orders_reports.dart';
import 'package:chakulalink/presentation/ngo_reports/ngo_reports.dart';
import 'package:chakulalink/presentation/delivered_orders/delivered_orders.dart';
import 'package:chakulalink/presentation/ngo_orders_in_transit/ngo_orders_in_transit.dart';


class AppRoutes {

  static const String requestOrderScreen = '/user_profile_screen';

  static const String ngoDashboardScreen = '/ngo_dashboard_screen';

  static const String adminDashboardScreen = '/admin_dashboard_screen';

  static const String donorDashboardScreen = '/donor_dashboard_screen';

  static const String distributorDashboardScreen = '/distributor_dashboard_screen';

  static const String locationScreen = '/location_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String loginScreen = '/login_screen';

  static const String splashScreen = '/splash_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String ngoManagement = '/ngo_management';

  static const String donationCategories = '/donation_categories';

  static const String wishListScreen = '/wishlist';

  static const String ordersToDonorScreen = '/orders_to_donor';

  static const String donateOrderScreen = '/donate_order';

  static const String donationReports = '/donation_reports';

  static const String availableOrdersScreen = '/available_orders';

  static const String ordersInTransitScreen = '/orders_in_transit';

  static const String orderReportsScreen = '/orders_reports';
  static const String ngoReportsScreen = '/ngo_reports';
  static const String deliveredOrdersScreen = '/delivered_orders';
  static const String ngoOrdersInTransitScreen = '/ngo_orders_in_transit';

  static Map<String, WidgetBuilder> routes = {
    requestOrderScreen: (context) => RequestOrder(),
    ngoDashboardScreen: (context) => NGODashboardScreen(),
    adminDashboardScreen: (context) => AdminDashboardScreen(),
    donorDashboardScreen: (context) => DonorDashboardScreen(),
    distributorDashboardScreen: (context) => DistributorDashboardScreen(),
    locationScreen: (context) => LocationScreen(),
    signUpScreen: (context) => SignUpScreen(),
    loginScreen: (context) => LoginScreen(),
    splashScreen: (context) => SplashScreen(),
    donationCategories: (context) => DonationCategory(),
    wishListScreen: (context) => WishList(),
    ordersToDonorScreen: (context) => OrdersToDonorScreen(),
    donateOrderScreen: (context) => DonateOrder(),
    donationReports: (context) => DonationReports(),
    availableOrdersScreen: (context) => AvailableOrders(),
    ordersInTransitScreen: (context) => OrdersInTransit(),
    orderReportsScreen: (context) => OrderReports(),
    ngoReportsScreen: (context) => NgoReports(),
    deliveredOrdersScreen: (context) => DeliveredOrders(),
    ngoOrdersInTransitScreen: (context) => NgoOrdersInTransit(),
  };
}

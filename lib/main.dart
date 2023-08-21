import 'package:ecommerce/pages/launcher_page.dart';
import 'package:ecommerce/pages/notification_page.dart';
import 'package:ecommerce/pages/order_details.dart';
import 'package:ecommerce/providers/notification_provider.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'pages/add_product_page.dart';
import 'pages/category_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/product_repurchase_page.dart';
import 'pages/report_page.dart';
import 'pages/settings_page.dart';
import 'pages/user_list_page.dart';
import 'pages/view_product_page.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=>ProductProvider()),
    ChangeNotifierProvider(create: (context)=>OrderProvider()),
    ChangeNotifierProvider(create: (context)=>UserProvider()),
    ChangeNotifierProvider(create: (context)=>NotificationProvider())
  ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData.light(useMaterial3: true,).copyWith(scaffoldBackgroundColor: Colors.white,primaryColor: Colors.deepPurpleAccent,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white,foregroundColor: Colors.black54)),

      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName : (_) => const LauncherPage(),
        LoginPage.routeName : (_) => const LoginPage(),
        DashboardPage.routeName : (_) => const DashboardPage(),
        AddProductPage.routeName : (_) => const AddProductPage(),
        ViewProductPage.routeName : (_) => const ViewProductPage(),
        ProductDetailsPage.routeName : (_) => const ProductDetailsPage(),
        CategoryPage.routeName : (_) => const CategoryPage(),
        OrderPage.routeName : (_) => const OrderPage(),
        OrderDetails.routeName : (_) => const OrderDetails(),
        Notification_page.routeName : (_) => const Notification_page(),

        ReportPage.routeName : (_) => const ReportPage(),
        SettingsPage.routeName : (_) => const SettingsPage(),
        ProductRepurchasePage.routeName : (_) => const ProductRepurchasePage(),
        UserListPage.routeName : (_) => const UserListPage(),
      },
    );
  }
}


import 'package:ecommerce/customWidget/dashboard_item_view.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/authentication.dart';
import '../models/dashboard_model.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    Provider.of<ProductProvider>(context,listen: false).getAllProduct();
    Provider.of<ProductProvider>(context,listen: false).getAllPurchase();
    Provider.of<OrderProvider>(context,listen: false).getOrderConstant();
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'),actions: [
        IconButton(onPressed: (){
          AuthService.logout().then((value) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
        }, icon: const Icon(Icons.logout))
      ],),
      body: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2
      ),
          itemCount: dashboardModelList.length,
          itemBuilder: (context,index)=>DashboardItemView(model: dashboardModelList[index])),
    );
  }
}

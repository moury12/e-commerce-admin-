import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_details.dart';

class OrderPage extends StatelessWidget {
  static const String routeName = '/order';
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id= ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemBuilder:(context, index) {
            final order= provider.orderList[index];
            return ListTile(
              tileColor: id==null? null : id==order.orderId?Colors.deepPurple.shade100:null ,
              onTap: (){
                Navigator.pushNamed(context, OrderDetails.routeName,arguments: order.orderId);
              },
              title: Text('${getFormattedDate(order.orderDate.timestamp.toDate()
                  ,pattern: 'dd/MM/yyyy')}'),
              subtitle: Text(order.orderStatus),
            trailing: Text('${order.grandTotal.toString()}BDT'),
           
            );
          },
          itemCount:provider.orderList.length ,
        ),
      ),
    );
  }
}

import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../utils/helper_function.dart';
class OrderDetails extends StatelessWidget {
  static const String routeName='/orderDetails';
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider=Provider.of<OrderProvider>(context);
    final orderID=ModalRoute.of(context)!.settings.arguments as String;
    final orderModel =orderProvider.getOrderById(orderID);
    return Scaffold(
      appBar: AppBar(title: Text(orderID),),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          buildHeader('Product Info'),
          buildProductInfoSection(orderModel),
          buildHeader('Order Summery'),
          buildOrderSummerySection(orderModel),
          buildHeader('Order Status'),
          buildOrderStatusSection(orderModel, orderProvider),
        ], 
      ),
    );
  }

  Padding buildHeader(String s) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        s,
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget buildProductInfoSection(OrderModel orderModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: orderModel.productDetails
              .map((cartModel) => ListTile(
            title: Text(cartModel.productName),
            trailing:
            Text('${cartModel.quantity}x${cartModel.salePrice}'),
          ))
              .toList(),
        ),
      ),
    );
  }

 Widget buildOrderSummerySection(OrderModel orderModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text('Discount'),
              trailing: Text('${orderModel.discount}%'),
            ),
            ListTile(
              title: Text('VAT'),
              trailing: Text('${orderModel.VAT}%'),
            ),
            ListTile(
              title: Text('Delivery Charge'),
              trailing: Text('${orderModel.deliveryCharge}BDT'),
            ),
            ListTile(
              title: Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '${orderModel.grandTotal}BDT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildOrderStatusSection(OrderModel orderModel, OrderProvider orderProvider) {
    ValueNotifier<bool> updateBtnNotifier=ValueNotifier(true);
    ValueNotifier<String> statusNotifier=ValueNotifier(orderModel.orderStatus);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              ValueListenableBuilder<String>(valueListenable: statusNotifier, builder: (context, value, child) => Radio<String>(value: OrderStatus.pending, groupValue: value, onChanged: (value){statusNotifier.value=value!;
                updateBtnNotifier.value=isEnabled(orderModel,statusNotifier.value);
                
              }),),
              Text(OrderStatus.pending)
            ],),
            Row(children: [
              ValueListenableBuilder<String>(valueListenable: statusNotifier, builder: (context, value, child) => Radio<String>(value: OrderStatus.processing, groupValue: value, onChanged: (value){statusNotifier.value=value!;
              updateBtnNotifier.value=isEnabled(orderModel,statusNotifier.value);

              }),),
              Text(OrderStatus.processing)
            ],),
            Row(children: [
              ValueListenableBuilder<String>(valueListenable: statusNotifier, builder: (context, value, child) => Radio<String>(value: OrderStatus.delivered, groupValue: value, onChanged: (value){statusNotifier.value=value!;
              updateBtnNotifier.value=isEnabled(orderModel,statusNotifier.value);

              }),),
              Text(OrderStatus.delivered)
            ],),
            Row(children: [
              ValueListenableBuilder<String>(valueListenable: statusNotifier, builder: (context, value, child) => Radio<String>(value: OrderStatus.cancelled, groupValue: value, onChanged: (value){statusNotifier.value=value!;
              updateBtnNotifier.value=isEnabled(orderModel,statusNotifier.value);

              }),),
              Text(OrderStatus.cancelled)
            ],),
            Row(children: [
              ValueListenableBuilder<String>(valueListenable: statusNotifier, builder: (context, value, child) => Radio<String>(value: OrderStatus.returned, groupValue: value, onChanged: (value){statusNotifier.value=value!;
              updateBtnNotifier.value=isEnabled(orderModel,statusNotifier.value);

              }),),
              Text(OrderStatus.returned)
            ],),


            ValueListenableBuilder<bool>(valueListenable: updateBtnNotifier, builder: (context, value, child) => ElevatedButton(onPressed: value?null:(){
              EasyLoading.show(status: 'Updating..');
              orderProvider.updateOrderStatus(orderModel.orderId,statusNotifier.value).then((value) {EasyLoading.dismiss();
              showMsg(context, 'Updated');} ).catchError((error) {
                EasyLoading.dismiss();
                showMsg(context, 'Failed to update');
              });
            }, child: Text('Update')),)
          ],
        ),
      ),
    );
  }

  bool isEnabled(OrderModel orderModel, String value) {
    return orderModel.orderStatus == value;

  }
}

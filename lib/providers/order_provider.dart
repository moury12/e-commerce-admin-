import 'package:ecommerce/db/db_helper.dart';
import 'package:ecommerce/models/order_constant_model.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:flutter/material.dart';
class OrderProvider extends ChangeNotifier{
  OrderConstantModel orderConstantModel=OrderConstantModel();
  List<OrderModel>orderList=[];
  OrderModel getOrderById(String id){
    return orderList.firstWhere((element) => element.orderId==id);
  }
  getOrders(){
    DbHelper.getAllOrders().listen((snapshot) {
      orderList=List.generate(snapshot.docs.length, (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  getOrderConstant(){
DbHelper.getOrderConstants().listen((snapshot) {
  if(snapshot.exists){
orderConstantModel=OrderConstantModel.fromMap(snapshot.data()!);
notifyListeners();
  }
});
}

  Future<void> updatedOrderConstant(OrderConstantModel model) {
    return DbHelper.updateOrderConstant(model);
  }

  Future<void> updateOrderStatus(String orderId, String status) {
    return DbHelper.updateOrderStatus(orderId,status);
  }
}
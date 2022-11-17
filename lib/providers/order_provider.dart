import 'package:ecommerce/db/db_helper.dart';
import 'package:ecommerce/models/order_constant_model.dart';
import 'package:flutter/material.dart';
class OrderProvider extends ChangeNotifier{
  OrderConstantModel orderConstantModel=OrderConstantModel();
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
}
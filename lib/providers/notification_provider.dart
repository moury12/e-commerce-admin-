import 'package:ecommerce/models/notification.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
 class NotificationProvider extends ChangeNotifier{
List <NotificationModel>  notificationList =[];
getAllNotification(){
 DbHelper.getAllNotification().listen((snapshot) {
  notificationList=List.generate(snapshot.docs.length, (index) => NotificationModel.fromMap(snapshot.docs[index].data()));
  notifyListeners();
 });
}
Future<void> updateNotificationStatus(String notId, bool status)async {
 DbHelper.updateNotificationStatus(notId,status);
}
 }
import 'package:ecommerce/models/notification.dart';
import 'package:ecommerce/pages/order_details.dart';
import 'package:ecommerce/pages/order_page.dart';
import 'package:ecommerce/pages/product_details_page.dart';
import 'package:ecommerce/pages/user_list_page.dart';
import 'package:ecommerce/providers/notification_provider.dart';
import 'package:ecommerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Notification_page extends StatelessWidget {
  static const String routeName ='/noti';
  const Notification_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification'),),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.notificationList.length,
          itemBuilder: (context, index) {
            final notification =provider.notificationList[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  leading: Icon(Icons.notifications_none),
                  tileColor: notification.status? null :Colors.deepPurple.shade100,
                  onTap: (){
                    _navigate(context,notification,provider);
                  },
                  title:Text(notification.type) ,
                  subtitle:Text(notification.message) ,

                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigate(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    String routeName='';
    String id='';
    switch(notification.type){
      case NotificationType.user:
routeName= UserListPage.routeName;
id= notification.userModel!.userId!;
        break;

      case NotificationType.comment:
        routeName = ProductDetailsPage.routeName;
        id= notification.commentModel!.productId;
        break;
      case NotificationType.order:
        routeName = OrderPage.routeName;
        id = notification.orderModel!.orderId;
        break;

    }
    provider.updateNotificationStatus(notification.id, notification.status);
      Navigator.pushNamed(context, routeName, arguments: id);

  }
}

import 'package:ecommerce/models/dashboard_model.dart';
import 'package:flutter/material.dart';
class DashboardItemView extends StatelessWidget {
  final DashboardModel model;
  const DashboardItemView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, model.routeName),
      child: Card(
        /*color: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),*/
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(model.iconData, size: 30, color: Theme.of(context).primaryColor,),
              const SizedBox(height: 10,),
              Text(model.title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }
}

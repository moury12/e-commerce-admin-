import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatelessWidget {
  static const String routeName = '/users';
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemBuilder:(context, index) {
            final user = provider.userList[index];
            return ListTile(
              leading: Container(   width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180)

                ),
                child:user.imageUrl==null?Image.asset('assets/m.png',fit: BoxFit.cover,)
                    : CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: user.imageUrl ?? '',
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
              title: Text(
                user.displayName??'No Display Name'
              ),
              subtitle: Text(user.email),
              trailing: Text('Joined on \n ${getFormattedDate(user.userCreationTime!.toDate(),pattern:'dd/MM/yyyy')}'),
            );
          }, 
          itemCount:provider.userList.length ,
        ),
      ),
    );
  }
}

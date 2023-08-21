import 'package:ecommerce/db/db_helper.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);
  List<UserModel> userList = [];

  getAllUSer() {
    DbHelper.getAllUsers().listen((snapshot) {
      userList = List.generate(snapshot.docs.length,
          (index) => UserModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}

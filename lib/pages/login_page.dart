
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/auth/authentication.dart';
import 'package:ecommerce/pages/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
final _fromkey= GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController =TextEditingController();
String _errmsg='';

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _fromkey,
              child:ListView(shrinkWrap: true,padding: const EdgeInsets.all(24),
                children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration:const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'E-Mail'
                    ),
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Provide a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password'
                    ),
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Provide a valid password';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(onPressed: _authentication, child: const Text('Login as Admin')),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_errmsg,style: const TextStyle(fontSize: 10,color: Colors.red),),
                ),
                  TextButton(onPressed: (){
                    AuthService.forgetPassword();
                  }, child: Text('Forget Password?',style: TextStyle(color: Colors.red),))
              ],),
            ),
          ),
        )


    );
  }

  void _authentication() async{
    if(_fromkey.currentState!.validate()){
      EasyLoading.show(status: 'Please Wait',dismissOnTap: false);
      final email=_emailController.text;
      final password=_passwordController.text;
      try{
final status= await AuthService.login(email, password);
EasyLoading.dismiss();

if(status){
  if(mounted){
    Navigator.pushReplacementNamed(context, DashboardPage.routeName);
  }
}else{
  await AuthService.logout();
  setState(() {
    _errmsg='This Account not valid';
  });
}
      }on FirebaseAuthException catch(error){
        EasyLoading.dismiss();
        setState(() {
          _errmsg=error.message!;
        });
      }
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';

showSingleInputDialogBox({required BuildContext context,
required String title,
String positiveButtonText ='ok',
  String negativeButtonText ='cancel',
  required Function(String) onSubmit,
}){
final txtController=TextEditingController();
showDialog(context: context, builder: (context)=>AlertDialog(
  title: Text(title),
  content: TextFormField(
    controller: txtController,
    decoration: InputDecoration(
      labelText: 'Enter $title',
    ),
  ),
  actions: [
TextButton(onPressed: (){
  Navigator.pop(context);
}, child: Text(negativeButtonText)),
    TextButton(onPressed: (){
      if(txtController.text.isEmpty) return;
        onSubmit(txtController.text);
        Navigator.pop(context);
      }
  , child: Text(positiveButtonText))
  ],
));
}
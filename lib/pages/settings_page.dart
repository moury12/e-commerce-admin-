import 'package:ecommerce/models/order_constant_model.dart';
import 'package:ecommerce/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _discountController = TextEditingController();
  final _vatController = TextEditingController();
  final _deliveryChargeController = TextEditingController();
  late OrderProvider orderProvider;
  @override
  void didChangeDependencies() {
    orderProvider =Provider.of<OrderProvider>(context);
    _discountController.text=orderProvider.orderConstantModel.discount.toString();
    _vatController.text=orderProvider.orderConstantModel.vat.toString();
    _deliveryChargeController.text=orderProvider.orderConstantModel.deliveryCharge.toString();
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _discountController.dispose();
    _deliveryChargeController.dispose();
    _vatController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
                key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
            TextFormField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Discount %',
                prefixIcon: Icon(Icons.discount),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _vatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vat %',
                prefixIcon: Icon(Icons.discount),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _deliveryChargeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Delevary Charge',
                prefixIcon: Icon(Icons.discount),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ), const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _saveInfo,
              child: const Text('Update'),
            )
          ],),
        ),
      ),
    );
  }

  void _saveInfo() {
    if(_formKey.currentState!.validate()){
final model =OrderConstantModel(
  discount: num.parse(_discountController.text),
  vat: num.parse(_vatController.text),
  deliveryCharge: num.parse(_deliveryChargeController.text)
);
orderProvider.updatedOrderConstant(model).then((value) {
  EasyLoading.dismiss();
showMsg(context, 'Updated');}
).catchError((error){
EasyLoading.dismiss();
showMsg(context, 'Update Failed');
});
    }
  }
}
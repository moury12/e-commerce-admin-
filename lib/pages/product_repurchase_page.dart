import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/date_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/purchase_model.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:ecommerce/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ProductRepurchasePage extends StatefulWidget {
  static const String routeName = '/repurchase';
  const ProductRepurchasePage({Key? key}) : super(key: key);

  @override
  State<ProductRepurchasePage> createState() => _ProductRepurchasePageState();
}

class _ProductRepurchasePageState extends State<ProductRepurchasePage> {
  final _fromkey = GlobalKey<FormState>();
  final _purchasePriceController = TextEditingController();
  final _purchaseQuantityController = TextEditingController();
  DateTime? dateTime;
  late ProductModel productModel;
  @override
  void didChangeDependencies() {
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _purchasePriceController.dispose();
    _purchaseQuantityController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Re-Purchase'),
          backgroundColor: Colors.deepPurpleAccent.shade100,
          toolbarHeight: 50,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _fromkey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(productModel.productName, style: Theme.of(context).textTheme.headline5,),
                  const Divider(height: 2, color: Colors.grey,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _purchasePriceController,
                      decoration: InputDecoration(

                          filled: true, labelText: 'Purchase Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          showMsg(context, 'Filed Required');
                        }
                        if (num.parse(value!) <= 0) {
                          return 'Price should be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _purchaseQuantityController,
                      decoration: InputDecoration(
                          filled: true, labelText: 'Purchase Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          showMsg(context, 'Filed Required');
                        }
                        if (num.parse(value!) <= 0) {
                          return 'quantity should be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        dateTime == null
                            ? Text('Choose a date')
                            : Text(getFormattedDate(dateTime!))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: _repurchase,
                        child: const Text('Re-purchase'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _repurchase() {
    if (dateTime == null) {
      showMsg(context, 'Please provide a date');
    }
    if (_fromkey.currentState!.validate()) {
      EasyLoading.show(status: 'please wait');
      final purchaseModel = PurchaseModel(
          productId: productModel.productId,
          purchaseQuantity: num.parse(_purchaseQuantityController.text),
          purchasePrice: num.parse(_purchasePriceController.text),
          dateModel: DateModel(timestamp: Timestamp.fromDate(dateTime!), day: dateTime!.day,
              month: dateTime!.month,year: dateTime!.year
          ));
      Provider.of<ProductProvider>(context,listen: false).rePurchase(purchaseModel,productModel).then((value) {
        EasyLoading.dismiss();
        showMsg(context, 'Saved');
        _reset();
      }).catchError((error){
        EasyLoading.dismiss();
        showMsg(context, 'failed to save');
      });
    }
  }

  void _selectDate() async {
    final datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now());
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
      });
    }
  }

  void _reset() {
    setState(() {
      _purchaseQuantityController.clear();
      _purchasePriceController.clear();
      dateTime=null;
    });
  }
}

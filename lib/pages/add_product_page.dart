import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce/models/date_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/purchase_model.dart';
import 'package:ecommerce/pages/view_product_page.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../utils/helper_function.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/addproduct';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late ProductProvider productProvider;
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? thumbnailImageLocalPath;
  CategoryModel? categoryModel;
  DateTime? purchaseDate;
  late StreamSubscription<ConnectivityResult> subscription;
  bool _isConnected = true;
  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _salePriceController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    isConnectedToInternet().then((value) {
      setState(() {
        _isConnected = value;
      });
    });
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
          actions: [
            TextButton(
                onPressed: _saveProduct,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              if (!_isConnected)
                const ListTile(
                  tileColor: Colors.red,
                  title: Text(
                    'No internet connectivity',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Consumer<ProductProvider>(
                builder: (context, provider, child) =>
                    DropdownButtonFormField<CategoryModel>(
                        hint: const Text('Select Category'),
                        value: categoryModel,
                        isExpanded: true,
                        validator: (value) {
                          if (value == null) {
                            return 'please select a category';
                          }
                          return null;
                        },
                        items: provider.categorelist
                            .map((catModel) => DropdownMenuItem(
                                value: catModel,
                                child: Text(catModel.categoryName)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            categoryModel = value;
                          });
                        }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Product Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  maxLines: 2,
                  controller: _shortDescriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Short Description(optional)',
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: _longDescriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter cake weight',
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _purchasePriceController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Purchase Price',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _salePriceController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Sale Price',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Quantity',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) <= 0) {
                      return 'Quantity should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _discountController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Discount',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) < 0) {
                      return 'Discount should not be a negative value';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Select Purchase Date'),
                      ),
                      Text(purchaseDate == null
                          ? 'No date chosen'
                          : getFormattedDate(purchaseDate!)),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        child: thumbnailImageLocalPath == null
                            ? const Icon(
                                Icons.photo,
                                size: 100,
                              )
                            : Image.file(
                                File(thumbnailImageLocalPath!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _getImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera),
                            label: const Text('Open Camera'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              _getImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo_album),
                            label: const Text('Open Gallery'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        purchaseDate = date;
      });
    }
  }

  void _getImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 70,
    );
    if (pickedImage != null) {
      setState(() {
        thumbnailImageLocalPath = pickedImage.path;
      });
    }
  }

  void _saveProduct() async {
    if (thumbnailImageLocalPath == null) {
      showMsg(context, 'Please select a product image');
      return;
    }

    if (purchaseDate == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }

    if (_formKey.currentState!.validate()) {
      String? downloadurl;
      EasyLoading.show(status: 'Please wait');
      try {
        downloadurl =
        await productProvider.uploadImage(thumbnailImageLocalPath!);
        final productmodel = ProductModel(
            productName: _nameController.text,
            shortDescription: _shortDescriptionController.text.isEmpty
                ? null
                : _shortDescriptionController.text,
            longDescription: _longDescriptionController.text.isEmpty
                ? null
                : _longDescriptionController.text,
            category: categoryModel!,
            productDiscount: num.parse(_discountController.text),
            salePrice: num.parse(_salePriceController.text),
            stock: num.parse(_quantityController.text),
            additionalImages: ['', '', ''],
            thumbnailImageUrl: downloadurl);
        final purchasemodel = PurchaseModel(
            purchaseQuantity: num.parse(_quantityController.text),
            purchasePrice: num.parse(_salePriceController.text),
            dateModel: DateModel(
                timestamp: Timestamp.fromDate(purchaseDate!),
                day: purchaseDate!.day,
                month: purchaseDate!.month,
                year: purchaseDate!.year));
        await productProvider.addNewProduct(productmodel,purchasemodel);
        EasyLoading.dismiss();
if(mounted){
  showMsg(context, 'saved');
}

_resetFeilds();

      } catch (error) {
        if (downloadurl == null) {
          await productProvider.deleteImage(downloadurl);
        }
        //showMsg(context, 'Something went wrong');
        EasyLoading.dismiss();
      }
    }
  }

  void _resetFeilds() {
    setState(() {
      _nameController.clear();
      _shortDescriptionController.clear();
      _longDescriptionController.clear();
      _purchasePriceController.clear();
      _quantityController.clear();
      _discountController.clear();
      _salePriceController.clear();
      subscription.cancel();
      categoryModel=null;
      purchaseDate=null;
      thumbnailImageLocalPath=null;

    });
  }
}

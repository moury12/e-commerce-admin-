import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/customWidget/image_holder_view.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/pages/product_repurchase_page.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:ecommerce/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(productModel.productName),
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            imageUrl: productModel.thumbnailImageUrl,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageHolderView(url: productModel.additionalImages[0],
                    onImagePressed: () { _showImageDialog(0); },
                    child: IconButton(
                  onPressed: (){
                    _addImage(0);
                  },
                  icon: Icon(Icons.add),
                ),
                ),
                ImageHolderView(url: productModel.additionalImages[1],
                    onImagePressed: () { _showImageDialog(1); },
                    child: IconButton(
                  onPressed:() {_addImage(1);},
                  icon: Icon(Icons.add),
                ),),
                ImageHolderView(url: productModel.additionalImages[2],
                    onImagePressed: () { _showImageDialog(2); },
                    child: IconButton(
                  onPressed:() {_addImage(2);},
                  icon: Icon(Icons.add),
                ),)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, ProductRepurchasePage.routeName,
                        arguments: productModel);
                  },
                  child: Text('Re-Purchase')),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  onPressed: _showPurchaseHistory,
                  child: Text('Purchase History')),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: ${productModel.salePrice}BDT'),
            subtitle: Text('Stock: ${productModel.stock}'),
          ),
          SwitchListTile(
            value: productModel.available,
            onChanged: (value) {
              setState(() {
                productModel.available = !productModel.available;
              });
              ProductProvider.updateProductField(
                  productModel.productId!, productFieldAvailable, value);
            },
            title: Text('Available'),
          ),
          SwitchListTile(
            value: productModel.featured,
            onChanged: (value) {
              setState(() {
                productModel.featured = !productModel.featured;
              });
              ProductProvider.updateProductField(
                  productModel.productId!, productFieldFeatured, value);
            },
            title: Text('Featured'),
          ),
          OutlinedButton(
            onPressed: _notifyUser,
            child: const Text('Notify Users'),
          )
        ],
      ),
    );
  }

  void _showPurchaseHistory() {
    showModalBottomSheet(
        backgroundColor: Colors.purple.shade100,
        constraints: BoxConstraints(maxHeight: 400),
        context: context,
        builder: (context) {
          final purchaseList =
              productProvider.getPurchaseByProductId(productModel.productId!);
          return Container(
            margin: EdgeInsets.all(9),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: purchaseList.length,
              itemBuilder: (context, index) {
                final purchaseModel = purchaseList[index];
                return ListTile(
                  title: Text(getFormattedDate(
                      purchaseModel.dateModel.timestamp.toDate())),
                  subtitle: Text('${purchaseModel.purchasePrice}BDT'),
                  trailing: Text('Qty:${purchaseModel.purchaseQuantity}'),
                );
              },
            ),
          );
        });
  }

  void _addImage(int index) async{
    final selectedImage= await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality: 70 );
    if(selectedImage!=null){
      EasyLoading.show(status: 'Uploading');
      try{
final downloadUrl=await productProvider.uploadImage(selectedImage.path);
final previousList = productModel.additionalImages;
previousList[index]=downloadUrl;
//previousList.add(downloadUrl);
await ProductProvider.updateProductField(productModel.productId!,productFieldImages,previousList);
setState(() {
  productModel.additionalImages[index]=downloadUrl;
});
EasyLoading.dismiss();
if(mounted)showMsg(context, 'Upload Successfully');
      }catch(error){
EasyLoading.dismiss();
if(mounted)showMsg(context, 'Upload Failed');
rethrow;
      }
    }
  }

  void _showImageDialog( int index) {
    final url =productModel.additionalImages[index];
    showDialog(context: context, builder: (context)=>AlertDialog(
      content:CachedNetworkImage(imageUrl: url,fit: BoxFit.contain,height: MediaQuery.of(context).size.height / 2,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),),actions: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.cancel)),
      IconButton(onPressed: () async{
        Navigator.pop(context);
        try{
         EasyLoading.show(status: 'Deleting..') ;
         await productProvider.deleteImage(url);
         setState(() {
           productModel.additionalImages[index]='';
         });
         await ProductProvider.updateProductField( productModel.productId!,productFieldImages,productModel.additionalImages);
         EasyLoading.dismiss();
        }catch(error){
          showMsg(context, 'Cannot Delete');
          EasyLoading.dismiss();
        }
      }, icon: Icon(Icons.delete))
    ] ,
    ));
  }
  void _notifyUser() async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final body = {
      "to": "/topics/promo",
      "notification": {
        "title": "New arrival!!!",
        "body": "Checkout this new Product ${productModel.productName}"
      },
      "data": {"key": "product", "value": productModel.productId}
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode(body),
      );

    } catch (error) {
      print(error.toString());
    }
  }
}

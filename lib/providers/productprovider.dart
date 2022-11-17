import 'dart:io';

import 'package:ecommerce/db/db_helper.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/purchase_model.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier{
  List<CategoryModel> categorelist=[];
  List<ProductModel> productlist=[];
  List<PurchaseModel> purchaselist=[];
 Future<void> addNewCategory(String category){
   final categoryModel =CategoryModel(categoryName: category);
return DbHelper.addCategory(categoryModel);
 }
getAllCategories(){
   DbHelper.getAllCategories().listen((snapshot) {
     categorelist=List.generate(snapshot.docs.length, (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
     categorelist.sort((cat1, cat2)=>cat1.categoryName.compareTo(cat2.categoryName));
     notifyListeners();
   });
}
  getAllProduct(){
    DbHelper.getAllProduct().listen((snapshot) {
      productlist=List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  getAllPurchase(){
    DbHelper.getAllPurchase().listen((snapshot) {
      purchaselist=List.generate(snapshot.docs.length, (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  List<CategoryModel> getAllProductByCategoryAll(){
   return <CategoryModel>[
     CategoryModel(categoryName: 'All'),...categorelist,
  ];
}
  getAllProductsProductByCategory(CategoryModel categoryModel){
    DbHelper.getAllProductsProductByCategory(categoryModel).listen((snapshot) {
      productlist=List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
Future<String> uploadImage(String? thumbnailImageLocalPath)async {
final photoRef= FirebaseStorage.instance.ref().child('productImages/${DateTime.now().microsecondsSinceEpoch}');
final uploadTask=photoRef.putFile(File(thumbnailImageLocalPath!));
final snapshot= await uploadTask.whenComplete(() => const Text('Upload Sucessfully'));
return snapshot.ref.getDownloadURL();
}

 Future<void> deleteImage(String? downloadurl) async {
   FirebaseStorage.instance.refFromURL(downloadurl!).delete();
 }
  static Future<void>updateProductField(String productId,String filed,dynamic value){
   return DbHelper.updateProductField(productId, {filed:value});
  }
 Future<void> addNewProduct(ProductModel productmodel, PurchaseModel purchasemodel) {
   return DbHelper.addNewProduct(productmodel,purchasemodel);
  }

  Future<void> rePurchase(PurchaseModel purchaseModel, ProductModel productModel) {
   return DbHelper.rePurchase(purchaseModel,productModel);
  }
  List<PurchaseModel> getPurchaseByProductId(String productId){
   List<PurchaseModel> list=[];
   list=purchaselist.where((model) => model.productId == productId).toList();
   return list;
  }
}
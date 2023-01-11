import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/notification.dart';
import 'package:ecommerce/models/order_constant_model.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/purchase_model.dart';

import '../models/user_model.dart';

class DbHelper{
  static final _db=FirebaseFirestore.instance;
  static Future<bool> isAdmin(String uid)async{
    final snapshot= await _db.collection('Admin').doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final doc =_db.collection(collectionCategory).doc();
    categoryModel.categoryId=doc.id;
    return doc.set(categoryModel.toMap());
  }
  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllCategories()=>
  _db.collection(collectionCategory).snapshots();
  static Stream<DocumentSnapshot<Map<String,dynamic>>>getOrderConstants()=>
  _db.collection(collectionOrderConstant).doc(documentOrderConstant).snapshots();
  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllProduct()=>
      _db.collection(collectionProduct).snapshots();
  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllProductsProductByCategory(CategoryModel categoryModel)=>
      _db.collection(collectionProduct).where('$productFieldCategory.$categoryFieldId' ,isEqualTo: categoryModel.categoryId).snapshots();
  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllPurchase()=>
    _db.collection(collectionPurchase).snapshots();
static Future<void>updateProductField(String productId,Map<String,dynamic> map){
  return _db.collection(collectionProduct).doc(productId).update(map);
}
  static Future<void> addNewProduct(ProductModel productmodel, PurchaseModel purchasemodel) {
    final wb=_db.batch();
    final productdoc= _db.collection(collectionProduct).doc();
    final purchasedoc =_db.collection(collectionPurchase).doc();
    final categorydoc=_db.collection(collectionCategory).doc(productmodel.category.categoryId);
    productmodel.productId=productdoc.id;
    purchasemodel.productId=productdoc.id;
    purchasemodel.purchaseId=purchasedoc.id;
    wb.set(productdoc, productmodel.toMap());
    wb.set(purchasedoc, purchasemodel.toMap());
    wb.update(categorydoc, {categoryFieldProductCount: productmodel.category.productCount+ purchasemodel.purchaseQuantity});
    return wb.commit();
  }

  static Future<void> rePurchase(PurchaseModel purchaseModel, ProductModel productModel) async {
    final wb=_db.batch();
    final purdoc=_db.collection(collectionPurchase).doc();
    purchaseModel.purchaseId=purdoc.id;
    wb.set(purdoc, purchaseModel.toMap());
    final prodoc=_db.collection(collectionProduct).doc(productModel.productId);
    wb.update(prodoc, {
      productFieldStock:(productModel.stock+purchaseModel.purchaseQuantity)
    });
    final snapshots=await _db.collection(collectionCategory).doc(productModel.category.categoryId).get();
    final prevCount=snapshots.data()![categoryFieldProductCount];
    final catdoc=_db.collection(collectionCategory).doc(productModel.category.categoryId);
    wb.update(catdoc, {categoryFieldProductCount:(prevCount+purchaseModel.purchaseQuantity)});
    return wb.commit();
  }

  static Future<void> updateOrderConstant(OrderConstantModel model) {
  return _db.collection(collectionOrderConstant).doc(documentOrderConstant).update(model.toMap());
  }
static Stream<QuerySnapshot<Map<String,dynamic>>>getAllOrders()=>
    _db.collection(collectionOrder).snapshots();

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllUsers() =>
      _db.collection(collectionUser).snapshots();

  static Future<void> updateOrderStatus(String orderId, String status) async{
    return _db.collection(collectionOrder).doc(orderId).update({orderFieldOrderStatus: status});
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllNotification()=>
      _db.collection(collectionNotification).snapshots();

  static Future <void> updateNotificationStatus(String notId, bool status) {
    return _db.collection(collectionNotification).doc(notId).update({notificationFieldStatus: status});
  }
}
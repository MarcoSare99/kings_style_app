import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kings_style_app/models/product_model.dart';

class ProductFireBase {
  Future create({required ProductModel productModel}) async {
    try {
      final docProduct = FirebaseFirestore.instance.collection('products');

      final productJson = productModel.toJson();
      await docProduct.add(productJson);
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}

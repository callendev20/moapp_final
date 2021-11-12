import 'dart:async';
import 'dart:collection';

import 'package:get/get.dart';

import '../model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _productListener;

  @override
  onInit() {
    _getProductInfo();
    super.onInit();
  }

  late List<Product> _allProducts;
  List<Product> get products => _allProducts;

  Future _getProductInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final completer = Completer<bool>();

    _productListener = firestore
        // .collection("product")
        .collection("test")
        .doc("products")
        .snapshots()
        .listen((event) {
      final doc = event.data();
      // print(doc);
      _allProducts = (doc as LinkedHashMap).keys.map((item) {
        // print(item);
        return Product(
          id: doc![item]["id"],
          createdTime: doc[item]["createdtime"] as Timestamp,
          modifiedTime: doc[item]["modifiedtime"] as Timestamp,
          creator: doc[item]["creator"],
          name: doc[item]["name"],
          price: doc[item]["price"].toDouble(),
          desc: doc[item]["desc"],
          like: doc[item]["like"],
          likedUser: doc[item]["likeduser"],
        );
      }).toList();
      if (!completer.isCompleted) completer.complete(true);
    });
    await completer.future;
  }
}

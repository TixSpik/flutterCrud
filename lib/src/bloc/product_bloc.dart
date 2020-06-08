import 'dart:io';

import 'package:provider_example/src/models/product_model.dart';
import 'package:provider_example/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productController = BehaviorSubject<List<ProductModel>>();
  final _fetchingController = BehaviorSubject<bool>();

  final _productsProvider = ProductProvider();

  Stream<List<ProductModel>> get productsStream => _productController.stream;
  Stream<bool> get fetching => _fetchingController.stream;

  void fetchProducts() async {
    final products = await _productsProvider.fetchProducts();
    _productController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _fetchingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _fetchingController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _fetchingController.sink.add(true);
    final imageUrl = await _productsProvider.uploadImage(image);
    _fetchingController.sink.add(false);

    return imageUrl;
  }

  void editProduct(ProductModel product) async {
    _fetchingController.sink.add(true);
    await _productsProvider.editProduct(product);
    _fetchingController.sink.add(false);
  }

  Future<int> deleteProduct(String id) async {
    return await _productsProvider.deleteProductById(id);
  }

  dispose() {
    _fetchingController?.close();
    _productController?.close();
  }
}

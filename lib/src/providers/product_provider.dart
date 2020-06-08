import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:provider_example/src/models/product_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider_example/src/shared/shared_preferences.dart';

class ProductProvider {
  final String _url = 'https://fluttercrud-d7d4f.firebaseio.com';
  final _pref = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/productos.json?auth=${_pref.token}';

    final response = await http.post(url, body: productModelToJson(product));

    final decodeData = json.decode(response.body);

    print(decodeData);

    return true;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json?auth=${_pref.token}';

    final response = await http.put(url, body: productModelToJson(product));

    final decodeData = json.decode(response.body);

    print(decodeData);

    return true;
  }

  Future<List<ProductModel>> fetchProducts() async {
    final url = '$_url/productos.json?auth=${_pref.token}';

    final response = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(response.body);

    final List<ProductModel> products = List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, product) {
      final prodTemp = ProductModel.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    print(products);

    return products;
  }

  Future<int> deleteProductById(String id) async {
    final url = '$_url/productos/$id.json?auth=${_pref.token}';

    final response = await http.delete(url);

    print(json.decode(response.body));

    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dycxesufw/image/upload?upload_preset=nic1sckz');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);

    print(responseData);

    return responseData['secure_url'];
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider_example/src/bloc/product_bloc.dart';
import 'package:provider_example/src/bloc/provider.dart';
import 'package:provider_example/src/models/product_model.dart';
import 'package:provider_example/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel product = new ProductModel();
  ProductBloc productBloc = ProductBloc();

  bool buttonState = true;

  File foto;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    productBloc = Provider.productBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectImage,
          ),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showImage(),
                _createName(),
                _createPrice(),
                SizedBox(
                  height: 20.0,
                ),
                _createAvalible(),
                _createButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
        initialValue: product.titulo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Producto'),
        onSaved: (value) => product.titulo = value,
        validator: (value) {
          if (value.length < 3) {
            return 'Ingrese el nombre del producto';
          } else {
            return null;
          }
        });
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.number,
      onSaved: (value) => product.valor = double.parse(value),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumber(value)) {
          return null;
        } else {
          return 'Sólo numeros';
        }
      },
    );
  }

  Widget _createAvalible() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.disponible = value;
      }),
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(
        Icons.save,
      ),
      label: Text('Guardar'),
      onPressed: buttonState ? _submitForm : null,
    );
  }

  void _submitForm() async {
    setState(() {
      buttonState = false;
    });

    if (!formKey.currentState.validate())
      return setState(() {
        buttonState = true;
      });

    formKey.currentState.save();

    if (foto != null) {
      await productBloc
          .uploadImage(foto)
          .then((value) => product.fotoUrl = value);
    }

    if (product.id != null) {
      productBloc.editProduct(product);
      _showSnackBar('Registro editado correctamente');
    } else {
      productBloc.createProduct(product);
      _showSnackBar('Registro guardado correctamente');
    }

    Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);

  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _selectImage() async {
    _getImage(ImageSource.gallery);
  }

  void _takePhoto() async {
    _getImage(ImageSource.camera);
  }

  Future _getImage(ImageSource origen) async {
    final pickedFile = await picker.getImage(source: origen);
    if (pickedFile == null) {
      return print('no image selected');
    }
    setState(() {
      foto = File(pickedFile.path);
      print(foto);
    });
    if (foto != null) {
      product.fotoUrl = null;

      setState(() {});
    }
  }

  Widget _showImage() {
    
    if (product.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(product.fotoUrl),
        placeholder: AssetImage('assets/original.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.contain,
          height: 300.0,
        );
      }
      return Image.asset('assets/original.png');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider_example/src/bloc/provider.dart';
import 'package:provider_example/src/models/product_model.dart';
import 'package:provider_example/src/shared/shared_preferences.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pref = UserPreferences();

  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productBloc(context);
    productsBloc.fetchProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                pref.deletePreferences();
                Navigator.of(context).pushReplacementNamed('login');
              })
        ],
      ),
      body: _createListProducts(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  FloatingActionButton _createButton(BuildContext ctx) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(ctx, 'product'),
    );
  }

  Widget _createListProducts(ProductBloc productBloc) {
    return StreamBuilder(
      stream: productBloc.productsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, i) =>
                _createItem(ctx, productBloc, products[i], products, i),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext ctx, ProductBloc productBloc,
      ProductModel product, List<ProductModel> prod, int position) {
    return Dismissible(
        key: Key(product.id),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          productBloc.deleteProduct(product.id)
          .then((value) => setState(() {
            prod.removeAt(position);
          }));
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (product.fotoUrl == null)
                  ? Image(image: AssetImage('assets/original.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/original.gif'),
                      image: NetworkImage(product.fotoUrl),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
              ListTile(
                title: Text('${product.titulo} - ${product.valor}'),
                subtitle: Text(product.id),
                onTap: () =>
                    Navigator.pushNamed(ctx, 'product', arguments: product)
                        .then((value) => setState(() {})),
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider_example/src/bloc/login_bloc.dart';
export 'package:provider_example/src/bloc/login_bloc.dart';
import 'package:provider_example/src/bloc/product_bloc.dart';
export 'package:provider_example/src/bloc/product_bloc.dart';


class Provider extends InheritedWidget {
  static Provider _instance;

  final loginBloc = LoginBloc();
  final _productsBloc = ProductBloc();

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }

    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext ctx) {
    return ctx.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductBloc productBloc (BuildContext ctx) {
    return ctx.dependOnInheritedWidgetOfExactType<Provider>()._productsBloc;
  }
}

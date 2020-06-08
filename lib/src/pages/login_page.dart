import 'package:flutter/material.dart';
import 'package:provider_example/src/bloc/provider.dart';
import 'package:provider_example/src/providers/user_provider.dart';
import 'package:provider_example/src/shared/shared_preferences.dart';
import 'package:provider_example/src/utils/utils.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatelessWidget {
  final userProvider = UserProvider();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_crearFondo(ctx), _loginForm(ctx)],
    ));
  }

  Widget _crearFondo(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;

    final purpleBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    final logoCenter = Container(
      padding: EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Luis Ramirez',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            )
          ],
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        purpleBackground,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Positioned(bottom: -40.0, right: 20.0, child: circle),
        Positioned(left: 20.0, bottom: -60, child: circle),
        logoCenter
      ],
    );
  }

  Widget _loginForm(BuildContext ctx) {
    final bloc = Provider.of(ctx);
    final size = MediaQuery.of(ctx).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 240.0,
          )),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.only(bottom: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30,
                ),
                _createEmail(bloc),
                SizedBox(
                  height: 20.0,
                ),
                _createPassword(bloc),
                SizedBox(
                  height: 40.0,
                ),
                _createButton(bloc)
              ],
            ),
          ),
          FlatButton(
              onPressed: () => Navigator.pushReplacementNamed(ctx, 'register'),
              child: Text('Crear una cuenta')),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Colors.deepPurple,
                ),
                hintText: 'Ejemplo@hotmail.com',
                labelText: 'Correo electronico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: (val) => bloc.changeEmail(val),
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.deepPurple,
                ),
                hintText: '******',
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: (val) => bloc.changePassword(val),
          ),
        );
      },
    );
  }

  Widget _createButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar')),
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext ctx) async {
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');

    Map info = await userProvider.authUser(bloc.email, bloc.password);

    if (info['ok']) {
      final pref = UserPreferences();
      pref.userAuth = true;
      Navigator.pushReplacementNamed(ctx, 'home');
    } else {
      showAlert(ctx, info['message']);
    }
  }
}

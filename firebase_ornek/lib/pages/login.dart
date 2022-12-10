import 'package:firebase_ornek/service/auth_service.dart';
import 'package:firebase_ornek/pages/home.dart';
import 'package:firebase_ornek/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: _buildBodyContainer()),
    );
  }

  Widget _buildBodyContainer() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .7,
      width: size.width * .85,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.75),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.75),
                blurRadius: 10,
                spreadRadius: 2)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFieldColumns(size),
              SizedBox(
                height: size.height * .1,
              ),
              _buildButtonsColumn(size),
              _buildRegisterTextBody()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldColumns(dynamic size) {
    return Column(
      children: [
        _buildEmailTextField(),
        _buildSpace(size),
        _buildPasswordTextField(),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
        controller: _emailController,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.white,
          ),
          hintText: 'E-Mail',
          prefixText: ' ',
          hintStyle: TextStyle(color: Colors.white),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.white,
          )),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.white,
          )),
        ));
  }

  Widget _buildPasswordTextField() {
    return TextField(
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Colors.white,
          ),
          hintText: 'Parola',
          prefixText: ' ',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.white,
          )),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.white,
          )),
        ));
  }

  Widget _buildButtonsColumn(dynamic size) {
    return Column(
      children: [
        _buildLoginButton(),
        _buildSpace(size),
        _buildLoginWithEmailButton(),
        _buildSpace(size),
        _buildLoginWithOtherButton('Google ile giriş', FontAwesomeIcons.google,
            Colors.red, _loginWithGoogleButtonFunction),
        _buildSpace(size),
        _buildLoginWithOtherButton(
            'Facebook ile giriş',
            FontAwesomeIcons.facebook,
            Colors.indigo,
            _loginWithFacebookButtonFunction),
        _buildSpace(size),
      ],
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
        onTap: () => _loginFunction(), child: _buildLoginButtonContainer());
  }

  Widget _buildLoginWithEmailButton() {
    return InkWell(
        onTap: () => _loginWithEmailAndLink(),
        child: _buildLoginButtonContainerEmail());
  }

  Widget _buildLoginButtonContainerEmail() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(child: _buildLoginButtonText()),
      ),
    );
  }

  Widget _buildLoginButtonContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(child: _buildLoginButtonTextEmail()),
      ),
    );
  }

  Widget _buildLoginButtonText() {
    return Text(
      "Giriş yap",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  Widget _buildLoginButtonTextEmail() {
    return Text(
      "E-mail ile giriş yap",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  void _loginFunction() {
    _authService
        .signIn(_emailController.text, _passwordController.text)
        .then((value) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((dynamic error) {
      if (error.code.contains('invalid-email')) {
        _buildErrorMessage("Mail adresi geçersizdir");
      }
      if (error.code.contains('user-not-found')) {
        _buildErrorMessage("Kullanıcı bulunamadı");
      }
      if (error.code.contains('wrong-password')) {
        _buildErrorMessage("Parola yanlıştır");
      }

      //  _buildErrorMessage(error.message);

      print(error.message);
    });
  }

  void _buildErrorMessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 14);
  }

  Widget _buildLoginWithOtherButton(
      String text, dynamic icon, dynamic color, Function function) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(child: _buildLoginWithGoogleButtonRow(text, icon)),
        ),
      ),
    );
  }

  void _loginWithGoogleButtonFunction() async {
    return _authService.signInWithGoogle().then((value) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  void _loginWithFacebookButtonFunction() async {
    _authService.signInWithFacebook().then((value) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Widget _buildLoginWithGoogleButtonRow(String text, dynamic icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFaIcon(icon),
        SizedBox(
          width: 10,
        ),
        _buildButtonText(text)
      ],
    );
  }

  Widget _buildFaIcon(IconData icon) {
    return FaIcon(
      icon,
      color: Colors.white,
    );
  }

  Widget _buildButtonText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildRegisterTextBody() {
    return InkWell(
      onTap: () => _registerFunction(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildDivider(), _buildRegisterText(), _buildDivider()],
      ),
    );
  }

  void _registerFunction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: 75,
      color: Colors.white,
    );
  }

  Widget _buildRegisterText() {
    return Text(
      "Kayıt ol",
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildSpace(dynamic size) {
    return SizedBox(
      height: size.height * 0.02,
    );
  }

  void _loginWithEmailAndLink() async {
    return _authService.sendEmailAndLink(_emailController.text);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
      if (initialLink != null) {
        handleLink(initialLink.link);
      }

      // This will handle incoming links if the application is already opened
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        handleLink(dynamicLinkData.link);
      }).onError((error) {
        // Handle errors
      });
    }
  }

  void handleLink(Uri link) async {
    _authService
        .signInWithEmailLink(_emailController.text, link.data.toString())
        .then((value) {
      if (value != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }
}

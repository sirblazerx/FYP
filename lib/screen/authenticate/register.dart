import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth.dart';
import 'package:app/template/template.dart';

import 'package:app/template/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {


    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return loading
        ? Loading()
        : Container(

      decoration: BoxDecoration(
        color: Colors.white,
       // image: DecorationImage(image: AssetImage('lib/img/logo-gwcqp.png') , alignment: Alignment.bottomCenter , fit: BoxFit.none),

      ) ,

          child: SafeArea(
            child: Scaffold(

                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.pinkAccent[400],
                  elevation: 0.0,
                  title: Text('Sign Up to GWCP'),
                  actions: <Widget>[

                  ],
                ),
                body: ListView(
                  children: [
                            Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                      child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[


                                SizedBox(height: 20.0),

                                Image.asset('lib/img/logo-gwcqp.png'),


                                SizedBox(height: 20.0),
                                TextFormField(
                                    decoration:
                                        textInputDecoration.copyWith(hintText: 'Email'),
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter your email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    }),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Password'),
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password 6 Characters or longer'
                                      : null,
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                RaisedButton(
                                    color: Colors.amberAccent[400],
                                    child: Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await _auth.regEmailPass(email, password);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error = 'Please supply a valid email and password';
                                          });
                                        }
                                      }
                                    }),
                                SizedBox(height: 20.0),
                                Text(
                                  error,
                                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                                ),
                                SizedBox(height: 20.0),
                                RichText(
                                  text: TextSpan(
                                    style: defaultStyle,
                                    children: <TextSpan>[
                                      TextSpan(text: 'Already have an account ? '),
                                      TextSpan(
                                        text: ' Log In',
                                        style: linkStyle,
                                        recognizer: TapGestureRecognizer()..onTap = () {

                                          widget.toggleView();
                                        },



                                      )

                                    ]

                                  ),


                                ),


                              ],
                            ))),
                          ],
                )),
          ),
        );
  }
}

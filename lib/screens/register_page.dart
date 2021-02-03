import 'package:e_commerce/constants.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //Built an Dialog to Build some Errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
                child: Text(error)
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  //Default form loading State
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });
    String _createAccountFeedBack = await _createAccount();
    if (_createAccountFeedBack != null) {
      _alertDialogBuilder(_createAccountFeedBack);

      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  //Default Form Loading State
  bool _registerFormLoading = false;

  //Form Input Field Values
  String _registerEmail = "";
  String _registerPassword = "";

  //Focus Node for Input Fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                padding: EdgeInsets.only(
                    top: 24.0
                ),
                child:
                Text("Create A New Account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText:"Email...",
                    onChanged: (value){
                      _registerEmail = value;
                    },
                    onSubmitted: (value){
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                      hintText:"Password...",
                    onChanged: (value){
                      _registerPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value){
                        _submitForm();
                      },
                  ),
                  CustomBtn(
                    text:"Create New Account",
                    onPressed: (){
                      _submitForm();
                    },
                    isLoading : _registerFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomBtn(
                  text: "Back To Login",
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  outlineBtn:true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

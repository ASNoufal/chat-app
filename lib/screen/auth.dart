import 'dart:io';

import 'package:chatapp/widget/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  File? currentImage;
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  String emailid = '';
  String passid = '';
  String username = '';
  bool isAuthenticating = false;
  void submit() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    if (!_isLogin && currentImage == null) {
      return;
    }

    _form.currentState!.save();
    print(emailid);
    print(passid);
    try {
      setState(() {
        isAuthenticating = true;
      });
      if (_isLogin) {
        final UserCredential = await _firebase.signInWithEmailAndPassword(
            email: emailid, password: passid);
      } else {
        final UserCredential = await _firebase.createUserWithEmailAndPassword(
            email: emailid, password: passid);

        final imagestorage = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child('${UserCredential.user!.uid}.jpg');

        await imagestorage.putFile(currentImage!);
        final imageurl = await imagestorage.getDownloadURL();

        FirebaseFirestore.instance
            .collection('user')
            .doc(UserCredential.user!.uid)
            .set({
          'username': username,
          'email': emailid,
          'userimage': imageurl
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //throw error
      }
      setState(() {
        isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication problems")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 20),
                  width: 200,
                  child: Image.asset('assets/images/chat.png')),
              Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              ongetimage: (image) {
                                currentImage = image;
                              },
                            ),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "UserName is incorrect";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              emailid = newValue!;
                            },
                            decoration: const InputDecoration(
                              label: Text('Email Id'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text("username")),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Too shoot";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                username = newValue!;
                              },
                            ),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return "Password is Too short";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              passid = newValue!;
                            },
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!isAuthenticating)
                            ElevatedButton(
                                onPressed: submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLogin ? "Login" : "Sign up")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? "Create an account"
                                  : "Already have Existing account"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

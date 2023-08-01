import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  String emailid = '';
  String passid = '';
  void submit() {
    final validate = _form.currentState!.validate();

    if (validate) {
      _form.currentState!.save();
      print(emailid);
      print(passid);
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
                          ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

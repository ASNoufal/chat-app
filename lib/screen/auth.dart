import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
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
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Email Id'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                            obscureText: true,
                          ),
                          ElevatedButton(
                              onPressed: () {},
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

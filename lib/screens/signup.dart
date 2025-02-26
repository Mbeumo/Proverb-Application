import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:proverbapp/services/translation.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

  class _SignUpPageState extends State<SignUpPage> {
    final AuthService objauthservice = AuthService();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final String imagePath='assets/Auth/register.jpeg';

    @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('sign_up')!,)),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('email')!,),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('password')!,),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  await objauthservice.signUp(
                      context:context, email:_emailController.text, password:_passwordController.text);
                  await objauthservice.signIn(
                      context: context, email:_emailController.text, password:_passwordController.text
                  );
                },
                child: Text( AppLocalizations.of(context)!.translate('sign_up')!,),
              ),
            ],
          ),
        ),
      );
    }
  }

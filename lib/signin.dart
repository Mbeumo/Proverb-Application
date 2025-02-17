import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService objauthservice = AuthService();
  final String imagePath='assets/Auth/login.jpeg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
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
              decoration: InputDecoration(labelText: 'Email'),
              style: Theme.of(context).textTheme.labelSmall
            //InputDecoration(
              //                 labelText: 'Email',
              //                 labelStyle: Theme.of(context).textTheme.labelSmall,
              //                 hintStyle: TextStyle(
              //                   color: Theme.of(context).brightness == Brightness.dark
              //                       ? Colors.grey[400]
              //                       : Colors.grey[600],
              //                 ),
              //                 enabledBorder: UnderlineInputBorder(
              //                   borderSide: BorderSide(
              //                     color: Theme.of(context).brightness == Brightness.dark
              //                         ? Colors.grey[400]!
              //                         : Colors.grey[600]!,
              //                   ),
              //                 ),
              //                 focusedBorder: UnderlineInputBorder(
              //                   borderSide: BorderSide(
              //                     color: Theme.of(context).brightness == Brightness.dark
              //                         ? Colors.grey[400]!
              //                         : Colors.grey[600]!,
              //                   ),
              //                 ),
              //               ),
              //               style: TextStyle(
              //                 color: Theme.of(context).brightness == Brightness.dark
              //                     ? Colors.white
              //                     : Colors.black, // Set text color based on theme
              //               ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              style: Theme.of(context).textTheme.labelSmall,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
               await objauthservice.signIn(
                   context: context, email:_emailController.text, password:_passwordController.text
               );

              },
              child: Text(
                'Sign In',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

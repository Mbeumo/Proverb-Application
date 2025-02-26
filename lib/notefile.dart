import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:proverbapp/services/translation.dart';
class NotefilePage extends StatefulWidget {
  const NotefilePage({super.key});

  @override
  _NotefilePageState createState() => _NotefilePageState();
}
class _NotefilePageState extends State<NotefilePage> {
  final AuthService objauthservice = AuthService();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('notes')!,)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,//chnge email to the correspknding json key
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('email')!,),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                //await objauthservice.signUp(
                   // context:context, email:_emailController.text, password:_passwordController.text);
               // );
                //await objauthservice.signIn(
                  //  context: context, email:_emailController.text, password:_passwordController.text
               // );

              },
              //this is to validate the note
              child: Text( AppLocalizations.of(context)!.translate('sign_up')!,),
            ),
          ],
        ),
      ),
    );
  }
}

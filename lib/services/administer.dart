import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
class administer{
  Future<void> grantAdminRole(context ,String targetUserId) async {
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('makeAdmin');
      await callable.call({'userId': targetUserId});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin role granted')),
      );
    } on FirebaseFunctionsException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.code} - ${e.message}')),
      );

    }
  }
}
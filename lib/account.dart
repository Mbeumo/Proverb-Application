import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';
class AccountView extends StatelessWidget {
  final AuthService authService;

  const AccountView({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    // Fetch user data (replace with your actual user data fetching logic)
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex:3,
              // Profile Picture
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                  child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // User Name
            Text(
              user?.displayName ?? 'Guest User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              user?.email ?? 'No email provided',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Account Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Account Creation Date
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.blue),
                      title: const Text('Account Created'),
                      subtitle: Text(
                        user?.metadata.creationTime?.toString() ?? 'Unknown',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Divider(),

                    // Last Sign-In
                    ListTile(
                      leading: const Icon(Icons.access_time, color: Colors.blue),
                      title: const Text('Last Sign-In'),
                      subtitle: Text(
                        user?.metadata.lastSignInTime?.toString() ?? 'Unknown',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editProfile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';

class HomeView extends StatelessWidget {
  HomeView({
    super.key,
  });
  final AuthService objauthservice = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proverbus'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              objauthservice.signOut(
                  context);

              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false // This removes all previous routes
              );

            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Biblical Proverbs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.notes),
              title: Text('notes'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),
            /*Icons.restore
            Icons.info
            Achievement: Icons.emoji_events

            Notification: Icons.notifications*/
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Back up'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.restore),
              title: Text('restore'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the settings navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle the home navigation
              },
            ),
            // Add more items here as needed
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to the Home View!'),
      ),
    );
  }
}

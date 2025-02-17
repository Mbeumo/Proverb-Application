
import 'package:flutter/material.dart';
import 'package:proverbapp/feeding%20data/verses.dart';
import 'package:proverbapp/services/administer.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:proverbapp/services/databaseservice.dart';

import 'feeding data/chapters.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService objauthservice = AuthService();
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  final List<Widget> _pages = [
    HomeContentView(),
    AchievementsView(),
    NotificationsView(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.animateToPage(
      selectedIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proverbus'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              objauthservice.signOut(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (Route<dynamic> route) => false, // Remove all previous routes
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
      drawer: AppDrawer(), //call the drawer function
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Achievements'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
      ),
    );
  }
}

// Extracted Home Content
class HomeContentView extends StatelessWidget {
  final Verses verse = Verses();
  final chapters chapter = chapters();

  final FirestoreService database = FirestoreService();
  final administer _admin=administer();
  final _user = AuthService().currentUser;


  HomeContentView({super.key});
  @override
  Widget build(BuildContext context) {
    Future<void> addverse() async{
      for (final verse in verse.proverbsChapter3Verses) {
        await database.addVerse(context,verse);
      }
    }
    Future<void> addchapters() async{
      for (final Chapter in chapter.chaptersproverb) {
        await database.addChapter(context,Chapter);
       /* await FirebaseFirestore.instance
            .collection('chapters')
            .doc(Chapter.id)
            .delete();*/ //This is to delete a particular document added to the collection
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chapters added succesfully')),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: database.getDailyVerse(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? "No verse available",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            Text('Welcome to the Home View!', style: TextStyle(fontSize: 24)),
            Flexible(
              flex:2,
              child:SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed:() => addverse(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'add verses to chapter 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            Flexible(
                flex:3,
                child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: addchapters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'add chapters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),

    );

  }


}
class AchievementsView extends StatefulWidget {
  const AchievementsView({super.key});

  @override
  State<AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<AchievementsView> {
  List<String> earnedAchievements = []; // Load from database
  List<String> allAchievements = [
    "First Steps",
    "Daily Devotee",
    "Chapter Champion",
    "Note Novice",
    "Sharing is Caring"
  ];

  @override
  void initState() {
    super.initState();
    // Load earned achievements from database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: allAchievements.length,
        itemBuilder: (context, index) {
          final achievement = allAchievements[index];
          final isEarned = earnedAchievements.contains(achievement);
          return ListTile(
            leading: Icon(isEarned ? Icons.check_circle : Icons.circle_outlined),
            title: Text(achievement),
            subtitle: Text(isEarned ? "Earned" : "Not Earned"),
          );
        },
      ),
    );
  }
}
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Notifications View', style: TextStyle(fontSize: 24)),
    );
  }
}

// Extracted Drawer for better readability
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(context, Icons.account_circle, 'Account', '/account'),
          _drawerItem(context, Icons.book, 'Biblical Proverbs', '/proverbchap'),
          _drawerItem(context, Icons.notes, 'Notes', null),
          _drawerItem(context, Icons.backup, 'Back up', null),
          _drawerItem(context, Icons.restore, 'Restore', null),
          _drawerItem(context, Icons.settings, 'Settings', '/settings'),
          _drawerItem(context, Icons.info, 'About', '/about'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, String? route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:proverbapp/feeding%20data/verses.dart';
import 'package:proverbapp/services/administer.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:proverbapp/services/databaseservice.dart';
import 'package:proverbapp/services/translation.dart';
import 'package:url_launcher/url_launcher.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label:AppLocalizations.of(context)!.translate('home')!,),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label:  AppLocalizations.of(context)!.translate('achievements')!,),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: AppLocalizations.of(context)!.translate('notifications')!,),
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
//return container instead of scaffold because i want to design the internal page of this view
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Verse of the Day Card
          FutureBuilder<String>(
            future: database.getDailyVerse(),
            builder: (context, snapshot) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                      AppLocalizations.of(context)!.translate('verse of today')!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 10),
                      snapshot.connectionState == ConnectionState.waiting
                      ? CircularProgressIndicator()
                      : Text(
                        snapshot.data ?? AppLocalizations.of(context)!.translate('verse_unavailable')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Social media display
          _buildLinksSection(context),
          const SizedBox(height: 30),

          // Action Buttons
          ElevatedButton.icon(
            onPressed: () {
              addverse();
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.translate('add_verse')!, style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(context) {
    return Column(
      children: [
        Divider(),
        Text("${AppLocalizations.of(context)!.translate('follow_us_on')!}:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialMediaCard(Icons.video_library, "YouTube", "https://youtube.com"),
            SizedBox(width: 20),
            _buildSocialMediaCard(Icons.facebook, "Facebook", "https://facebook.com"),
            SizedBox(width: 20),
            _buildSocialMediaCard(Icons.web, "Website", "https://jw.org"),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialMediaCard(IconData icon, String name, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 5),
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
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
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        //use the same gradient as the home page
        /*decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),*/
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
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
            ),
            //_buildLinksSection(),
          ],
        ),
      ),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text('Notifications View', style: TextStyle(fontSize: 24)),
        )
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
          _drawerItem(context, Icons.account_circle, AppLocalizations.of(context)!.translate('account')!, '/account'),
          _drawerItem(context, Icons.book, AppLocalizations.of(context)!.translate('biblical_proverbs')!, '/proverbchap'),
          _drawerItem(context, Icons.notes, AppLocalizations.of(context)!.translate('notes')!, null),
          _drawerItem(context, Icons.backup, AppLocalizations.of(context)!.translate('backup')!, null),
          _drawerItem(context, Icons.restore, AppLocalizations.of(context)!.translate('restore')!, null),
          _drawerItem(context, Icons.settings, AppLocalizations.of(context)!.translate('setting')!, '/settings'),
          _drawerItem(context, Icons.info, AppLocalizations.of(context)!.translate('about')!, '/about'),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proverbapp/firebase_options.dart';
import 'package:proverbapp/initial_page.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:proverbapp/services/storageservice.dart';
import 'package:proverbapp/services/translation.dart';
import 'package:proverbapp/settings.dart';
import 'package:proverbapp/signin.dart';
import 'package:proverbapp/signup.dart';
import 'package:proverbapp/homepage.dart';
import 'package:proverbapp/account.dart';
import 'package:proverbapp/editprofile.dart';
import 'package:proverbapp/biblesproverb.dart';
import 'package:proverbapp/verseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('darkMode') ?? false;
  String selectedLanguage = prefs.getString('language') ?? 'English';
  runApp(MyApp(isDarkMode: isDarkMode, selectedLanguage: selectedLanguage));
}

class MyApp extends StatefulWidget {

  final bool isDarkMode;
  final String selectedLanguage;

  MyApp({super.key,required this.isDarkMode, required this.selectedLanguage});

  @override
  _MyAppState createState() => _MyAppState();
// This widget is the root of your application.
}
class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    selectedLanguage = widget.selectedLanguage;
  }
  void _updateDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }
  void _updateLanguageParam(String value) {
    setState(() {
      selectedLanguage = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:  isDarkMode
          ? ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark, // Ensure dark mode brightness),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white), // Example
        bodyMedium: TextStyle(
        fontSize: 16, color: Colors.grey[300]), // Example
        headlineMedium:TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Colors.white),
        labelSmall: TextStyle(
        fontSize: 12, color: Colors.grey[400]), // Example
        ),
    ): ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light, // Ensure light mode brightness
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87), // Example
        bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87), // Example
        headlineMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
        labelSmall: TextStyle(
            fontSize: 12,
            color: Colors.grey[600]), // Example
      )
    ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('fr', ''), // French
      ],
      locale: Locale(selectedLanguage.toLowerCase(), ''),
      routes: {
        '/': (context) => InitialView(onSignUpClicked: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );*/
          Navigator.pushNamed(context, '/register');
        },
          onSignInClicked: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        '/register': (context) => SignUpPage(),
        '/login': (context) => SignInPage(),
        '/HOME':(context) => HomeView(),
        '/account':(context) => AccountView(authService: AuthService(),),
        '/editProfile':(context) => EditProfileView(authService: AuthService(),storage: StorageService(),),
        '/proverbchap':(context) => ChapterListScreen(),
        '/verseInChap': (context) => VerseListScreen(chapterId: ModalRoute.of(context)!.settings.arguments as String),
        '/settings': (context) => SettingsView(onDarkModeChanged: _updateDarkMode,onLanguageChanged: _updateLanguageParam,),
        '/about':(context) => AboutPage(),
      },

    initialRoute: '/', // This is the starting route InitialView()
    );
  }
}


/*
  class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
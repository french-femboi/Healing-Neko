//  _    _            _ _               _   _      _             ____
// | |  | |          | (_)             | \ | |    | |          _|___ \
// | |__| | ___  __ _| |_ _ __   __ _  |  \| | ___| | _____   (_) __) |
// |  __  |/ _ \/ _` | | | '_ \ / _` | | . ` |/ _ \ |/ / _ \     |__ <
// | |  | |  __/ (_| | | | | | | (_| | | |\  |  __/   < (_) |  _ ___) |
// |_|  |_|\___|\__,_|_|_|_| |_|\__, | |_| \_|\___|_|\_\___/  (_)____/
//                               __/ |
//                              |___/
//
// ----------------------------------------------------------------------------
// Made with love and a cat by Catpawz
// based on ideas from firebird496
// ----------------------------------------------------------------------------
//
// ignore_for_file: unused_local_variable, depend_on_referenced_packages, unused_field, prefer_final_fields, camel_case_types, use_key_in_widget_constructors
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const homePage());
}

class homePage extends StatelessWidget {
  const homePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const homePagePage(),
    );
  }
}

ThemeData themeData() {
  Color primaryColor = const Color(0xFF0EF6CC);
  Color accentColor = const Color(0xFF3A4F50);
  Color backgroundColor = const Color(0xFF201B23);

  MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    },
  );

  return ThemeData(
    primarySwatch: primarySwatch,
    hintColor: accentColor,
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: backgroundColor,
    useMaterial3: true,
  );
}

class homePagePage extends StatefulWidget {
  const homePagePage({Key? key});
  @override
  State<homePagePage> createState() => _homePagePageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _homePagePageState extends State<homePagePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _hobbyController = TextEditingController();
  String username = "...";
  String welcomeMessage = "...";
  String petName = "...";
  var _currentIndex = 0;

  //navigation states
  var homeVis = true;
  var treeVis = false;
  var nekoVis = false;
  var sosVis = false;
  var settingsVis = false;

  @override
  void initState() {
    super.initState();
    //load initial user data
    getData();
    //generate a warm welcome message
    generateMessage();
    initializeWindow(context);
  }

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('hln_name') ?? "null";
      petName = prefs.getString('hln_petName') ?? "null";
    });
  }

  generateMessage() {
    //list of smol welcome messages to make the user feel at home
    final List<String> strings = [
      "Welcome, dear friend! You're in a safe space here. :)",
      "Hello and welcome! Take a deep breath and relax. :3",
      "Greetings, lovely soul! Thank you for choosing us. ^^",
      "Ahoy there! Welcome aboard! Let's sail through this together. ;)",
      "Hey you! Yes, you! Welcome to a place where you are cherished. :)",
      "Welcome, welcome, welcome! Your presence makes this space brighter. :D",
      "Hola amigo! Welcome to a journey of self-discovery and growth. :)",
      "Hey there, beautiful! Welcome to a world of healing and positivity. <3",
      "Hiya! Welcome to a cozy corner where you're always understood. :)",
      "Greetings, sunshine! Step into a space where you're celebrated. :D",
      "Hey, hey, hey! Welcome to a place where your heart can speak freely. :)",
      "Hola! Bienvenido! Your journey to wellness starts right here. :)",
      "Hey, lovely soul! Welcome to a community of support and kindness. <3",
      "Hello, hello! Welcome to a sanctuary of peace and acceptance. :)",
      "Hey friend! Welcome to a space where your well-being matters most. ^^",
    ];
    final Random random = Random();
    final int randomNumber = random.nextInt(strings.length);
    setState(() {
      welcomeMessage = strings[randomNumber];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Healing Neko',
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF332841),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          vibrate();
          setState(() => _currentIndex = i);
          if (_currentIndex == 0) {
            homeVis = true;
            treeVis = false;
            nekoVis = false;
            sosVis = false;
            settingsVis = false;
          } else if (_currentIndex == 1) {
            homeVis = false;
            treeVis = true;
            nekoVis = false;
            sosVis = false;
            settingsVis = false;
          } else if (_currentIndex == 2) {
            homeVis = false;
            treeVis = false;
            nekoVis = true;
            sosVis = false;
            settingsVis = false;
          } else if (_currentIndex == 3) {
            homeVis = false;
            treeVis = false;
            nekoVis = false;
            sosVis = true;
            settingsVis = false;
          } else if (_currentIndex == 4) {
            homeVis = false;
            treeVis = false;
            nekoVis = false;
            sosVis = false;
            settingsVis = true;
          } else {
            homeVis = false;
            treeVis = false;
            nekoVis = false;
            sosVis = false;
            settingsVis = false;
          }
        },
        backgroundColor: const Color(0xFF2B2331),
        selectedItemColor: const Color.fromARGB(224, 140, 125, 175),
        unselectedItemColor: const Color.fromARGB(224, 140, 125, 175),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: const Text("Home"),
            selectedColor: const Color(0xFFAE7DEE),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_tree_rounded),
            title: const Text("Healing"),
            selectedColor: const Color(0xFFAE7DEE),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.pets_rounded),
            title: const Text("Neko"),
            selectedColor: const Color(0xFFAE7DEE),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.sos_rounded),
            title: const Text("Emergency"),
            selectedColor: const Color(0xFFAE7DEE),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings_rounded),
            title: const Text("Settings"),
            selectedColor: const Color(0xFFAE7DEE),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Visibility(
              visible: homeVis,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Welcome back, $username!',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          welcomeMessage,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: treeVis,
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "$username's healing tree",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Color(0xFFC8ACEE),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Check out your healing tree here, or go through a new one :)",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF7F698C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: nekoVis,
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        petName,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Color(0xFFC8ACEE),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Take good care of $petName :3",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF7F698C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: sosVis,
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Emergency toolbox",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0xFFC8ACEE),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Are you okay $username?",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF7F698C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: settingsVis,
              child: const Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "App settings",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0xFFC8ACEE),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Customize the app to you needs, and change your saved data.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF7F698C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

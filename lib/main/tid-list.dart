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
// ignore_for_file: unused_local_variable, depend_on_referenced_packages, use_build_context_synchronously, non_constant_identifier_names, prefer_final_fields, use_key_in_widget_constructors
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyTidList());
}

class MyTidList extends StatelessWidget {
  const MyTidList({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const TidListPage(),
      routes: {
        '/home': (context) => const homePage(),
      },
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

class TidListPage extends StatefulWidget {
  const TidListPage({Key? key});
  @override
  State<TidListPage> createState() => _TidListPageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _TidListPageState extends State<TidListPage> {
  String tids = "No TID's found.";

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeWindow(context);
    loadItemsFromPrefs();
  }

  Future<void> loadItemsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsString = prefs.getString('hln_tids');
    setState(() {
      tids = itemsString ?? "No TID's found.";
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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
          "Past T-ID's",
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color.fromARGB(255, 39, 33, 43),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFFC8ACEE)),
          onPressed: () {
            vibrate();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => homePage()),
                (route) => false);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Height of the bottom bar
          child: Container(
            color: Color(0xFFC8ACEE), // Color of the bottom bar
            height: 2.0, // Height of the bottom bar
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Past T-ID's",
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color(0xFFC8ACEE),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "This is just a text file with all the TID's you had before.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  tids,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 173, 149, 187),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  runApp(const MyMd());
}

class MyMd extends StatelessWidget {
  const MyMd({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const MdPage(),
      routes: {
        '/home': (context) => const homePagePage(),
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

class MdPage extends StatefulWidget {
  const MdPage({Key? key});
  @override
  State<MdPage> createState() => _MdPageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _MdPageState extends State<MdPage> {
  String _markdownContent = '';

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
    loadMarkdownFile();
  }

  Future<void> loadMarkdownFile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? file = prefs.getString('hln_mdfile');
    try {
      String content = await rootBundle.loadString(file!);
      setState(() {
        _markdownContent = content;
      });
    } catch (e) {
      print('Error loading markdown file: $e');
      setState(() {
        _markdownContent = 'Error loading content.';
      });
    }
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
          'Text content',
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF332841),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFFC8ACEE)),
          onPressed: () {
            vibrate();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => homePage()),
              (route) => false
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                MarkdownBody(
                  data: _markdownContent,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: Color.fromARGB(255, 238, 228, 252)),
                    h1: TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.bold),
                    h2: TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.bold),
                    a: TextStyle(color: Color.fromARGB(255, 174, 119, 252))
                  ),
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      _launchURL(href);
                    }
                  }
                ),

            ],
          ),
        ),
      ),
    );
  }
}

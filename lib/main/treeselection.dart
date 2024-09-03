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
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const TreeSelectionWidget());
}

class TreeSelectionWidget extends StatelessWidget {
  const TreeSelectionWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const TreeSelectionPage(),
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

class TreeSelectionPage extends StatefulWidget {
  const TreeSelectionPage({Key? key});
  @override
  State<TreeSelectionPage> createState() => _TreeSelectionPageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _TreeSelectionPageState extends State<TreeSelectionPage> {
    PageController _pageController = PageController();
    int _currentPage = 0;

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
          'Tree Selection',
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF332841),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFC8ACEE)),
          onPressed: () {
            vibrate();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const homePage()),
                (route) => false);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0), // Height of the bottom bar
          child: Container(
            color: const Color(0xFFC8ACEE), // Color of the bottom bar
            height: 2.0, // Height of the bottom bar
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
          children: <Widget>[
              Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  // Page 1
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 1'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 2'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                    ],
                  ),
                  // Page 2
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 3'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 4'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                    ],
                  ),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 3'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Button 4'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60), // Big button
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            
            SliderTheme(
              data: SliderThemeData(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
              trackHeight: 4, // Adjust the track height as desired
              activeTrackColor: Color.fromARGB(255, 128, 90, 179), // Set the active track color
              inactiveTrackColor: const Color(0xFF332841), // Set the inactive track color
              ),
              child: Slider(
              value: _currentPage.toDouble(),
              min: 0,
              max: 2, // Adjust this based on the number of pages
              divisions: 2, // Adjust this based on the number of pages
              onChanged: (double value) {
                setState(() {
                _currentPage = value.toInt();
                _pageController.animateToPage(
                  _currentPage,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                });
              },
              ),
            ),
          ],
          ),
        
      ),
    );
  }
}

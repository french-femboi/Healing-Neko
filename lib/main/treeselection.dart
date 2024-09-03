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
// ignore_for_file: unused_local_variable, depend_on_referenced_packages, use_build_context_synchronously, non_constant_identifier_names, prefer_final_fields, use_key_in_widget_constructors, sort_child_properties_last
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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
  String tid = "";

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }
  final player_ui = AudioPlayer();
  
    playUiSound(arg1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var active = prefs.getBool('hln_ui_sounds') ?? true;
    if (active == true) {
      if (arg1 == 1) {
        await player_ui.stop();
        await player_ui.setSource(AssetSource('ui/click_3.wav'));
        await player_ui.resume();
      } else if (arg1 == 2) {
        await player_ui.stop();
        await player_ui.setSource(AssetSource('ui/click_4.wav'));
        await player_ui.resume();
      } else if (arg1 == 3) {
        await player_ui.stop();
        await player_ui.setSource(AssetSource('ui/click_7.wav'));
        await player_ui.resume();
      } else if (arg1 == 4) {
        await player_ui.stop();
        await player_ui.setSource(AssetSource('ui/Complete_23.wav'));
        await player_ui.resume();
      }
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
        backgroundColor: Color.fromARGB(255, 39, 33, 43),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  // Page 1
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'In one word, how do you feel today?',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          vibrate();
                           playUiSound(1);
                          _pageController.animateToPage(
                            1, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "P";
                        },
                        child: const Text(
                          'Positive',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            1, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "N";
                        },
                        child: const Text(
                          'Negative',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            1, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "I";
                        },
                        child: const Text(
                          'I have no idea',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841), // Set the background color
                        ),
                      ),
                    ],
                  ),
                  // Page 2
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Do you feel like you are in control of your life?',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            2, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}Y";
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            2, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}N";
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            2, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}I";
                        },
                        child: const Text(
                          'I have no idea',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'What emotion did you feel most today?',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            3, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}S";
                        },
                        child: const Text(
                          'Sadness',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            3, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}H";
                        },
                        child: const Text(
                          'Happiness',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            3, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}B";
                        },
                        child: const Text(
                          'Boredom',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            3, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}A";
                        },
                        child: const Text(
                          'Anxiety',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          playUiSound(1);
                          vibrate();
                          _pageController.animateToPage(
                            3, // The page index you want to navigate to
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          tid = "${tid}E";
                        },
                        child: const Text(
                          'Something else...',
                          style: TextStyle(
                            color: Color.fromARGB(255, 171, 145, 218), // Set the text color
                            fontWeight: FontWeight.bold, // Set the text weight
                            fontSize: 16, // Set the text size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 60), // Big button
                          backgroundColor: const Color(0xFF332841) // Set the background color
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'T-ID: $tid',
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
                          "The results you get here are limited. I am in no way a qualified professional, I'm just a developer who wants to help.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "If you want to continue, and accept the limitations of this tool, press the button below.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF332841),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center the content
                            children: [
                              Icon(
                                Icons
                                    .check_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Display results",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 171, 145, 218),
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                trackHeight: 4, // Adjust the track height as desired
                activeTrackColor: Color.fromARGB(
                    255, 128, 90, 179), // Set the active track color
                inactiveTrackColor:
                    Color(0xFF332841), // Set the inactive track color
              ),
              child: Slider(
                value: _currentPage.toDouble(),
                min: 0,
                max: 3, // Adjust this based on the number of pages
                divisions: 3, // Adjust this based on the number of pages
                onChanged: (double value) {
                  setState(() {
                    _currentPage = value.toInt();
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                'T-ID: $tid',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFC8ACEE),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

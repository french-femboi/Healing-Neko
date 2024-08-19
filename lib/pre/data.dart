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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../main/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyMain());
}

class MyMain extends StatelessWidget {
  const MyMain({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const DataSavePage(),
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

class DataSavePage extends StatefulWidget {
  const DataSavePage({Key? key});
  @override
  State<DataSavePage> createState() => _DataSavePageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _DataSavePageState extends State<DataSavePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _hobbyController = TextEditingController();
  TextEditingController _petController = TextEditingController();

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }

  completeSetup() async {
    //get the string data from the textfields
    String v_name = _nameController.text;
    String v_hobbies = _hobbyController.text;
    String v_petname = _petController.text;

    //save all the local data into sharedpreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hln_name', v_name);
    await prefs.setString('hln_hobbies', v_hobbies);
    await prefs.setString('hln_petName', v_petname);
    await prefs.setBool('hln_setup', true);

    //after saving everything successfully redirect to the homepage
    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();

    initializeWindow(context);
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
          'Initial setup',
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF332841),
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Welcome :)',
                  style: TextStyle(
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
                  "Welcome to Healing Neko, before you start using the app, please fill out some data for customization. This data will be saved locally on your device, and can be deleted at any time.",
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
                  "Healing Neko uses server connections to fetch data for the app's content and algorithm. The connection is encrypted, and no data is shared from your device. There is absolutely no privacy risk, you're safe with us!",
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
                  "Take the time to configure the app to your wishes. We will add more customization features soon. Remember you do not have to put in your real name, just use your preferred name :) You'll have a neko pet to take care of as well! Give it a good name.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Display name",
                  hintStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  labelStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _hobbyController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Favorite activities",
                  hintStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  labelStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _petController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Pet name",
                  hintStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  labelStyle: const TextStyle(color: Color(0xFFAE7DEE)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Color(0xFF61586D)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    vibrate();
                    completeSetup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF221B2E),
                  ),
                  child: const Text(
                    "Save data",
                    style: TextStyle(
                      color: Color.fromARGB(255, 171, 145, 218),
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
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

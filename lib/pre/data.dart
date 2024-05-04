import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

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
      title: 'For My Love',
      theme: themeData(),
      home: const DataSavePage(),
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
  TextEditingController _statussController = TextEditingController();

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }

  completeSetup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hln_setup', true);
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
        backgroundColor: const Color(0xFF422E5A),
        automaticallyImplyLeading: false,
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
                  "Welcome to Healing Neko, before you start using the app, please fill out some data for customization. This data will be saved locally on your device, and can be deleted at any time :]",
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
                  "Healing Neko uses server connections to fetch data for the app's content. The connection is encrypted, and no data is shared from your device. There is absolutely no privacy risk, you're safe with us :)",
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    vibrate();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF221B2E),
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

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
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyBugReport.MyBugreport());
}

class MyBugReport extends StatelessWidget {
  const MyBugReport.MyBugreport({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const bugPage(),
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

class bugPage extends StatefulWidget {
  const bugPage({Key? key});
  @override
  State<bugPage> createState() => _bugPageState();
}

Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
}

class _bugPageState extends State<bugPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _reportController = TextEditingController();
  TextEditingController _discordController = TextEditingController();
  bool beta = false;
  bool alpha = false;
  bool special = false;

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

  @override
  void dispose() {
    super.dispose();
  }

  String getSelectedPrograms() {
    List<String> selectedPrograms = [];

    if (beta) selectedPrograms.add('Beta');
    if (alpha) selectedPrograms.add('Alpha');
    if (special) selectedPrograms.add('Special');

    if (selectedPrograms.isEmpty) {
      return 'No programs selected';
    } else if (selectedPrograms.length == 1) {
      return selectedPrograms[0];
    } else if (selectedPrograms.length == 2) {
      return '${selectedPrograms[0]} and ${selectedPrograms[1]}';
    } else {
      return '${selectedPrograms[0]}, ${selectedPrograms[1]}, and ${selectedPrograms[2]}';
    }
  }

  Future<void> sendReport() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String appVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String? appInstaller = packageInfo.installerStore;

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String androidVersion = androidInfo.version.release;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String title = _titleController.text;
      String report = _reportController.text;
      String discord = _discordController.text;

      // Define the URL for the Baserow API endpoint
      String url =
          'https://api.dynapaw.eu/api/database/rows/table/1095/?user_field_names=true';

      // Define the data for the new row
      Map<String, dynamic> rowData = {
        'title': title, // Replace with actual title
        'report': report, // Replace with actual message
        'discord': discord,
        'groups': getSelectedPrograms(),
        'device':
            "APPVER: $appVersion, BNUM: $buildNumber, ANDV: $androidVersion, INST: $appInstaller" // Replace with actual creator
      };

      // Make a POST request to add the new row
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Token P1g4DY9F0qhXiJ9X4OaRwgYbbzLdHfc7', // Replace with your database token
          'Content-Type': 'application/json',
        },
        body: json.encode(rowData),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const homePage()),
      );

      // Check if the request was successful
      if (response.statusCode == 201) {
        // Row added successfully
      } else {
        // Error adding row
      }
    } catch (error) {
      // Request failed
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report a bug',
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Sending a bug report, will also send some basic device and app data such as: android version, app version, screen size, connection status and app installer ID.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _discordController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Discord username",
                  hintStyle: const TextStyle(color: Color(0xFF7F698C)),
                  labelStyle: const TextStyle(color: Color(0xFF7F698C)),
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
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Report title",
                  hintStyle: const TextStyle(color: Color(0xFF7F698C)),
                  labelStyle: const TextStyle(color: Color(0xFF7F698C)),
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
              TextField(
                controller: _reportController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Report content",
                  hintStyle: const TextStyle(color: Color(0xFF7F698C)),
                  labelStyle: const TextStyle(color: Color(0xFF7F698C)),
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
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Please select the programs you're part of, so we can pinpoint the bug better.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Beta program",
                    style: TextStyle(
                        color: Color(0xFF7F698C), fontWeight: FontWeight.w700)),
                value: beta,
                onChanged: (bool? value) {
                  setState(() {
                    beta = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text("Alpha program",
                    style: TextStyle(
                        color: Color(0xFF7F698C), fontWeight: FontWeight.w700)),
                value: alpha,
                onChanged: (bool? value) {
                  setState(() {
                    alpha = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text("Special release program",
                    style: TextStyle(
                        color: Color(0xFF7F698C), fontWeight: FontWeight.w700)),
                value: special,
                onChanged: (bool? value) {
                  setState(() {
                    special = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    vibrate();
                    sendReport();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF332841),
                    padding:
                        EdgeInsets.symmetric(vertical: 12), // Add some padding
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the content
                    children: [
                      Icon(
                        Icons.send_rounded, // Choose an appropriate icon
                        color: Color.fromARGB(
                            255, 171, 145, 218), // Match text color
                        size: 20, // Adjust size as needed
                      ),
                      SizedBox(
                          width: 8), // Add some space between icon and text
                      Text(
                        "Send report",
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
        ),
      ),
    );
  }
}

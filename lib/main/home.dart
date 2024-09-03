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
// ignore_for_file: unused_local_variable, depend_on_referenced_packages, unused_field, prefer_final_fields, camel_case_types, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healing_neko/internal/bugreport.dart';
import 'package:healing_neko/internal/featuresuggestion.dart';
import 'package:healing_neko/internal/mdreader.dart';
import 'package:healing_neko/main/treeselection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:audioplayers/audioplayers.dart';

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
  Color accentColor = const Color(0xFF3A4F50);
  Color backgroundColor = const Color(0xFF201B23);

  return ThemeData(
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
  String petFeeling = "happy";
  var _currentIndex = 0;

  var neko_sounds = false;
  var ui_sounds = false;
  var shorter_boot = false;
  var app_version = "-";
  var app_build = "-";
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
    initializeMusic();
    initializeSettings();
    initializeWindow(context);
    loadIndex();
    playUiSound(1);
  }

  initializeSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      neko_sounds = prefs.getBool('hln_neko_sounds') ?? true;
      ui_sounds = prefs.getBool('hln_ui_sounds') ?? true;
      shorter_boot = prefs.getBool('hln_shorter_boot') ?? false;
      app_version = packageInfo.version;
      app_build = packageInfo.buildNumber;
    });
  }



  saveSetting(arg1, arg2) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (arg1 == 1) {
      await prefs.setBool('hln_neko_sounds', arg2);
    } else if (arg1 == 2) {
      await prefs.setBool('hln_ui_sounds', arg2);
    } else if (arg1 == 3) {
      await prefs.setBool('hln_shorter_boot', arg2);
    }
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

  showMd(arg1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hln_mdfile', arg1);
  }

  saveIndex(arg1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hln_index', arg1);
  }

  loadIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var newIndex = prefs.getInt('hln_index') ?? 0;
    setState(() {
      _currentIndex = newIndex;
    });
    loadNav(newIndex);
    await prefs.setInt('hln_index', 0);
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

  final player = AudioPlayer();
  final player_ui = AudioPlayer();
  final player_neko = AudioPlayer();

  stopMusic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hln_song', '-');
    await player.stop();
  }

  stopNekoSounds() async {
    await player_neko.stop();
  }

  playBackMusic(arg1) async {
    playUiSound(4);
    stopMusic();
    if (arg1 == "-") {
      //plaback not enabled
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('hln_song', arg1);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setSource(AssetSource(arg1));
      await player.resume();
    }
  }

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

  initializeMusic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getString('hln_song') ?? "-") == "-") {
      //playback not enabled
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setSource(AssetSource(prefs.getString('hln_song') ?? "-"));
      await player.resume();
    }
  }

  nekoSounds() async {
    if (neko_sounds == true) {
      await player_neko.setReleaseMode(ReleaseMode.loop);
      await player_neko.setVolume(0.2);
      await player_neko.setSource(AssetSource("neko/purr.mp3"));
      await player_neko.resume();
    }
  }

  loadNav(arg1) {
    setState(() => _currentIndex = arg1);
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
    if (_currentIndex == 2) {
      nekoSounds();
    } else {
      stopNekoSounds();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF2B2331),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Healing Neko',
          style:
              TextStyle(color: Color(0xFFC8ACEE), fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color.fromARGB(255, 39, 33, 43),
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
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          vibrate();
          playUiSound(1);
          setState(() => _currentIndex = i);
          loadNav(i);
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Visibility(
              visible: homeVis,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xFF61586D),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Color(0xFF61586D),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TreeSelectionPage()),
                            );
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
                                    .feedback_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Start tree selection",
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
            Visibility(
              visible: nekoVis,
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Color(0xFF61586D),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: Image.asset('assets/img/CatHappyWhite.png'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "$petName is currently $petFeeling",
                        textAlign: TextAlign.center,
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Color(0xFF61586D),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          vibrate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 50, 80),
                        ),
                        child: const Text(
                          "Online toolkit",
                          style: TextStyle(
                            color: Color.fromARGB(255, 195, 178, 226),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          vibrate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 50, 80),
                        ),
                        child: const Text(
                          "Catpawz community",
                          style: TextStyle(
                            color: Color.fromARGB(255, 195, 178, 226),
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
            Visibility(
              visible: settingsVis,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      const SizedBox(
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
                      const SizedBox(height: 10),
                      const SizedBox(
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
                      const SizedBox(height: 10),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xFF61586D),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Sounscapes",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Select a background music, or enable/disable certain UI sounds.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            playUiSound(2);
                            vibrate();
                            Widget _buildBottomSheet(
                              BuildContext context,
                              ScrollController scrollController,
                              double bottomSheetOffset,
                            ) {
                              return Material(
                                  color: const Color(0xFF2B2331),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2B2331),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListView(
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        children: [
                                          const Text(
                                            'MUSIC SELECTION',
                                            style: TextStyle(
                                                color: Color(0xFFAE7DEE),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const Text(
                                            'Select the background music you want while using Healing Neko! Also check out the amazing artists who made these songs :3',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 113, 97, 126),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                vibrate();
                                                stopMusic();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Stop music",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          const Text(
                                            'AMBIENT MUSIC',
                                            style: TextStyle(
                                                color: Color(0xFFAE7DEE),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const Text(
                                            "Music by Meydän and Lee Rosevere",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 113, 97, 126),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Meydan_-_Away.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Away by Meydän",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Meydän_-_Freezing_but_warm.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Freezing but warm by Meydän",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Meydän_-_Elk.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Elk by Meydän",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Lee_Rosevere_-_Expectations.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Expectations by Lee Rosevere",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Lee_Rosevere_-_Featherlight.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Featherlight by Lee Rosevere",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Lee_Rosevere_-_We_Dont_Know_How_it_Ends.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "We Don't Know How it Ends by Lee Rosevere",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          const Text(
                                            'R&B and Soul',
                                            style: TextStyle(
                                                color: Color(0xFFAE7DEE),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const Text(
                                            "Music by Pierce Murphy and Mekanik",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 113, 97, 126),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Pierce_Murphy_-_Galilee.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Galilee by Pierce Murphy",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Pierce_Murphy_-_Devil_In_A_Falling_Sky.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Devil In A Falling Sky by Pierce Murphy",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Pierce_Murphy_-_This_Dream_I_Had.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "This Dream I Had by Pierce Murphy",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                playBackMusic(
                                                    'soundscapes/Beat_Mekanik_-_Just_a_Taste.mp3');
                                                vibrate();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 61, 50, 80),
                                              ),
                                              child: const Text(
                                                "Just a Taste by Beat Mekanik",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 195, 178, 226),
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ));
                            }

                            showFlexibleBottomSheet(
                              minHeight: 0,
                              initHeight: 0.8,
                              maxHeight: 0.8,
                              context: context,
                              builder: _buildBottomSheet,
                              isExpand: false,
                              bottomSheetBorderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                    20.0), // Top left corner radius
                                topRight: Radius.circular(
                                    20.0), // Top right corner radius
                              ),
                            );
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
                                    .music_note_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Select background music",
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            showMd('soundscapes.md');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyMd()),
                            );
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
                                    .info_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Music credits / licenses",
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
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text(
                          'Enable Neko purr & meow',
                          style: TextStyle(
                            color: Color(0xFFC8ACEE),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        value:
                            neko_sounds, // boolean variable to hold the switch state
                        onChanged: (bool value) {
                          playUiSound(3);
                          setState(() {
                            neko_sounds = value;
                            saveSetting(1, value);
                          });
                        },
                        activeColor: Color.fromARGB(
                            255, 214, 182, 255), // Color when the switch is on
                        activeTrackColor: Color(
                            0xFF61586D), // Track color when the switch is on
                        inactiveThumbColor:
                            Colors.grey, // Thumb color when the switch is off
                        inactiveTrackColor: Color(
                            0xFF332841), // Track color when the switch is off
                      ),
                      SwitchListTile(
                        title: const Text(
                          'Enable UI sounds',
                          style: TextStyle(
                            color: Color(0xFFC8ACEE),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        value:
                            ui_sounds, // boolean variable to hold the switch state
                        onChanged: (bool value) {
                          playUiSound(3);
                          setState(() {
                            ui_sounds = value;
                            saveSetting(2, value);
                          });
                        },
                        activeColor: Color.fromARGB(
                            255, 214, 182, 255), // Color when the switch is on
                        activeTrackColor: Color(
                            0xFF61586D), // Track color when the switch is on
                        inactiveThumbColor:
                            Colors.grey, // Thumb color when the switch is off
                        inactiveTrackColor: Color(
                            0xFF332841), // Track color when the switch is off
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xFF61586D),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Other settings",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFC8ACEE),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Enable or disable certain features, or change the data you've saved. Some features might require an app restart to take effect.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        title: const Text(
                          'Enable faster boot',
                          style: TextStyle(
                            color: Color(0xFFC8ACEE),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        value:
                            shorter_boot, // boolean variable to hold the switch state
                        onChanged: (bool value) {
                          playUiSound(3);
                          setState(() {
                            shorter_boot = value;
                            saveSetting(3, value);
                          });
                        },
                        activeColor: Color.fromARGB(
                            255, 214, 182, 255), // Color when the switch is on
                        activeTrackColor: Color(
                            0xFF61586D), // Track color when the switch is on
                        inactiveThumbColor:
                            Colors.grey, // Thumb color when the switch is off
                        inactiveTrackColor: Color(
                            0xFF332841), // Track color when the switch is off
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xFF61586D),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            showMd('readme.md');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyMd()),
                            );
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
                                    .edit_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Show readme file",
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            showMd('changes.md');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyMd()),
                            );
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
                                    .web_stories_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Display changelog",
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const bugPage()),
                            );
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
                                    .feedback_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Report a bug",
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            vibrate();
                            playUiSound(2);
                            saveIndex(4);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const suggestPage()),
                            );
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
                                    .reviews_rounded, // Choose an appropriate icon
                                color: Color.fromARGB(
                                    255, 171, 145, 218), // Match text color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text(
                                "Suggest a feature",
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "This app was made with <3 and cats\n ≽/ᐠ - w -マ≼ Ⳋ from Catpawz\n\n based on ideas from firebird496\n\nVER: $app_version\nBNUM: $app_build",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7F698C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

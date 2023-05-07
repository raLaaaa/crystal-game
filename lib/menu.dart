import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/game.dart';
import 'package:darkness_dungeon/util/custom_sprite_animation_widget.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/localization/strings_location.dart';
import 'package:darkness_dungeon/util/player_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:darkness_dungeon/widgets/custom_radio.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool showSplash = false;


  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: showSplash ? buildSplash() : buildMenu(),
    );
  }

  Widget buildMenu() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "A game with a crystal",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Normal', fontSize: 30.0),
              ),
              SizedBox(
                height: 30.0,
              ),

              Image.asset(
                "assets/images/crystal_glow.gif",
                height: 64.0,
                width: 64.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: Size(100, 40), //////// HERE
                  ),
                  child: Text(
                    getString('play_cap'),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 17.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Game()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DefectorRadio<bool>(
                value: false,
                label: 'Keyboard',
                group: Game.useJoystick,
                onChange: (value) {
                  setState(() {
                    Game.useJoystick = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              DefectorRadio<bool>(
                value: true,
                group: Game.useJoystick,
                label: 'Joystick',
                onChange: (value) {
                  setState(() {
                    Game.useJoystick = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              if (!Game.useJoystick)
                SizedBox(
                  height: 80,
                  width: 200,
                  child: Sprite.load('keyboard_tip.png').asWidget(),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 20,
          margin: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'powered by rala',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Text(
                    //   getString('built_with'),
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontFamily: 'Normal',
                    //       fontSize: 12.0),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     _launchURL(
                    //         'https://github.com/RafaelBarbosatec/bonfire');
                    //   },
                    //   child: Text(
                    //     'Bonfire',
                    //     style: TextStyle(
                    //       decoration: TextDecoration.underline,
                    //       color: Colors.blue,
                    //       fontFamily: 'Normal',
                    //       fontSize: 12.0,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSplash() {
    return FlameSplashScreen(
      theme: FlameSplashTheme.dark,
      onFinish: (BuildContext context) {
        setState(() {
          showSplash = false;
        });
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

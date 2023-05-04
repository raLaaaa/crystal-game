import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/controllers/wavecontroller.dart';
import 'package:darkness_dungeon/decoration/areas/crystal_spawn_area.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:darkness_dungeon/decoration/door.dart';
import 'package:darkness_dungeon/decoration/key.dart';
import 'package:darkness_dungeon/decoration/potion_life.dart';
import 'package:darkness_dungeon/decoration/spikes.dart';
import 'package:darkness_dungeon/decoration/torch.dart';
import 'package:darkness_dungeon/enemies/boss.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/enemies/goblin.dart';
import 'package:darkness_dungeon/enemies/imp.dart';
import 'package:darkness_dungeon/enemies/mini_boss.dart';
import 'package:darkness_dungeon/interface/knight_interface.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/menu.dart';
import 'package:darkness_dungeon/npc/kid.dart';
import 'package:darkness_dungeon/npc/wizard_npc.dart';
import 'package:darkness_dungeon/player/knight.dart';
import 'package:darkness_dungeon/util/dialogs.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'crystal_game_controller.dart';
import 'decoration/areas/target_crystal_area.dart';
import 'decoration/barrel.dart';

class Game extends StatefulWidget {
  static bool useJoystick = true;
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> implements GameListener {
  bool showGameOver = false;

  late CrystalGameController _controller;

  @override
  void initState() {
    _controller = CrystalGameController()..addListener(this);
    _controller.add(WaveController());
    _controller.add(FpsTextComponent(position: Vector2(400,40)));
    Sounds.playBackgroundSound();
    super.initState();
  }

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    tileSize = max(sizeScreen.height, sizeScreen.width) / 15;


    var joystick = Joystick(
      directional: JoystickDirectional(
        spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
        spriteKnobDirectional: Sprite.load('joystick_knob.png'),
        size: 100,
        isFixed: false,
      ),
      actions: [
        JoystickAction(
          actionId: 0,
          sprite: Sprite.load('joystick_atack.png'),
          spritePressed: Sprite.load('joystick_atack_selected.png'),
          size: 80,
          margin: EdgeInsets.only(bottom: 50, right: 50),
        ),
        JoystickAction(
          actionId: 1,
          sprite: Sprite.load('joystick_atack_range.png'),
          spritePressed: Sprite.load('joystick_atack_range_selected.png'),
          size: 50,
          margin: EdgeInsets.only(bottom: 50, right: 160),
        )
      ],
    );
    if (!Game.useJoystick) {
      joystick = Joystick(
        keyboardConfig: KeyboardConfig(
          keyboardDirectionalType: KeyboardDirectionalType.wasd,
          acceptedKeys: [
            LogicalKeyboardKey.space,
            LogicalKeyboardKey.keyZ,
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: BonfireWidget(
        gameController: _controller,
        showCollisionArea: false,
        joystick: joystick,
        player: Knight(
          Vector2(12 * tileSize, 6 * tileSize),
        ),
        map: WorldMapByTiled(
          'tiled/map.json',
          forceTileSize: Vector2(tileSize, tileSize),
          objectsBuilder: {
            'crystal_spawn_area': (p) => CrystalSpawnArea(p.position, p.size),
            'barrel': (p) => Barrel(p.position),
            'door': (p) => Door(p.position, p.size),
            'torch': (p) => Torch(p.position),
            'potion': (p) => PotionLife(p.position, 30),
            'wizard': (p) => WizardNPC(p.position),
            'spikes': (p) => Spikes(p.position),
            'target_crystal_area': (p) => TargetCrystalArea(p.position, p.size),
            'key': (p) => DoorKey(p.position),
            'kid': (p) => Kid(p.position),
            'boss': (p) => Boss(p.position),
            'goblin': (p) => Goblin(p.position),
            'imp': (p) => Imp(p.position),
            'mini_boss': (p) => MiniBoss(p.position),
            'torch_empty': (p) => Torch(p.position, empty: true),
          },
        ),
        interface: KnightInterface(),
        lightingColorGame: Colors.black.withOpacity(0.6),
        background: BackgroundColorGame(Colors.grey[900]!),
        progress: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Normal',
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialogGameOver() {
    setState(() {
      showGameOver = true;
    });
    Dialogs.showGameOver(
      context,
      () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Game()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    
    _controller.visibleEnemies?.forEach((element) {
      if (element is CrystalGameEnemy && element.hasReachedFinish) {
        if (!showGameOver) {
          showGameOver = true;
          _showDialogGameOver();
        }
      }
    });

    if (_controller.player != null && _controller.player?.isDead == true) {
      if (!showGameOver) {
        showGameOver = true;
        _showDialogGameOver();
      }
    }
  }

  
}

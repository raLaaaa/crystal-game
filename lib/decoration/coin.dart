import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/player/knight.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:flutter/material.dart';

import '../util/functions.dart';

class Coin extends GameDecoration with Sensor, Lighting {
  final timeUntilFade = Timer(6, repeat: false, autoStart: true);

  Coin(Vector2 position)
      : super.withAnimation(
          animation: GameSpriteSheet.coin(),
          position: position,
          size: Vector2(32, 32),
        ) {
    setupSensorArea(
      intervalCheck: 100,
    );

    setupLighting(
      LightingConfig(
          radius: width * 1.5,
          blurBorder: width,
          pulseVariation: 0.1,
          color: Colors.yellowAccent.withOpacity(0.1)),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeUntilFade.update(dt);

    this.animation?.frames.forEach((element) {
      if (timeUntilFade.current >= 5) {
        element.stepTime = 0.015;
      } else if (timeUntilFade.current > 4) {
        element.stepTime = 0.05;
      } else if (timeUntilFade.current > 3) {
        element.stepTime = 0.075;
      } else if (timeUntilFade.current > 2) {
        element.stepTime = 0.1;
      } else if (timeUntilFade.current > 1) {
        element.stepTime = 0.2;
      } else {
        element.stepTime = 0.25;
      }
    });

    if (gameRef.player != null) {
      if (timeUntilFade.finished) {
        removeFromParent();
        gameRef.add(
          AnimatedObjectOnce(
            animation: GameSpriteSheet.smokeExplosion(),
            position: this.position,
            size: Vector2(32, 32),
          ),
        );
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onContact(GameComponent collision) {
    if (collision is Player) {
      Knight k = gameRef.player as Knight;
      k.increaseCollectedCoins();
      removeFromParent();
    }
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);

  @override
  void onContactExit(GameComponent component) {}
}

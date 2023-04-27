import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';

import 'package:flutter/material.dart';

import '../../main.dart';

class TargetCrystalArea extends GameDecoration with Sensor, ObjectCollision {
  TargetCrystalArea(
    Vector2 position,
    Vector2 size,
  ) : super(position: position, size: size) {
    setupSensorArea(
      intervalCheck: 100,
    );
  }

  @override
  void onContact(GameComponent collision) {
    if (collision is CrystalGameEnemy) {
        if(collision.isCarryCrystal){
          collision.hasReachedFinish = true;
        }
    }
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);

  @override
  void onContactExit(GameComponent component) {

  }

  @override
  String toString() {
    return 'Area: $position';
  }
}

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:flutter/material.dart';

import '../../decoration/areas/target_crystal_area.dart';
import '../../main.dart';
import '../goblin.dart';

mixin DummyBehavior on CrystalGameEnemy {
  void behave(double dt, CrystalGameEnemy enemy) {
    super.update(dt);

    this.seeAndMoveToPlayer(
        radiusVision: tileSize * 50,
        closePlayer: (player) {
          
        });
  }

  TargetCrystalArea? _findClosestArea(List<TargetCrystalArea> areas) {
    double lowestDistance = 999999;
    TargetCrystalArea? toReturn;

    areas.forEach((element) {
      double distance = this.distance(element);
      if (distance < lowestDistance) {
        lowestDistance = distance;
        toReturn = element;
      }
    });

    return toReturn;
  }
}

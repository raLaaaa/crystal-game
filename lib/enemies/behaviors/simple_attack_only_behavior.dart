import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/decoration/areas/target_crystal_area.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../goblin.dart';

mixin SimpleAttackOnlyBehavior on CrystalGameEnemy {
  void behave(double dt, CrystalGameEnemy enemy) {
    super.update(dt);

    List<TargetCrystalArea> areas = getAreasOfCurrentMap();

    if (enemy.isCarryCrystal) {
      TargetCrystalArea? closest = _findClosestArea(areas);
      this.followComponent(closest!, dt, closeComponent: (c) {});
      this.moveFromDirection(this.lastDirection, speedVector: Vector2(50, 30));
    } else {
      this.seeAndMoveToPlayer(
          radiusVision: tileSize * 50,
          closePlayer: (player) {
            enemy.execAttack();
          });
    }
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

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../goblin.dart';

mixin SimpleBehavior on CrystalGameEnemy {
  void behave(double dt, CrystalGameEnemy enemy) {
    super.update(dt);

    this.seeAndMoveToPlayer(
        radiusVision: tileSize * 50,
        closePlayer: (player) {
          enemy.execAttack();
        });
  }
}

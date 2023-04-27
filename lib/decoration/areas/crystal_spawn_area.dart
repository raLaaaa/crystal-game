import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../crystal.dart';

class CrystalSpawnArea extends GameDecoration {

  bool crystalAdded = false;

  CrystalSpawnArea(
    Vector2 position,
    Vector2 size,
  ) : super(position: position, size: size) {
  }


  @override
  update(dt){
    super.update(dt);
    if(!crystalAdded && gameRef.player != null) {
      gameRef.add(Crystal(position));
      crystalAdded = true;
    }
  }


  @override
  int get priority => LayerPriority.getComponentPriority(1);



  @override
  String toString() {
    return 'Area: $position';
  }
}

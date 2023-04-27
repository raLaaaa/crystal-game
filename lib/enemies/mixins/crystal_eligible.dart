import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:flutter/material.dart';

import '../../decoration/areas/target_crystal_area.dart';
import '../../main.dart';
import '../goblin.dart';

mixin CrystalEligible on Npc  {

  bool isAllowedToPickUpCrystal = true;
  bool isCarryCrystal = false;
  bool hasReachedFinish = false;

}
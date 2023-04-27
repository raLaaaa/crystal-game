import 'dart:ui';

import 'package:darkness_dungeon/decoration/areas/target_crystal_area.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../util/enemy_sprite_sheet.dart';
import '../util/sounds.dart';
import 'mixins/crystal_eligible.dart';
import 'package:bonfire/bonfire.dart';

abstract class CrystalGameEnemy extends SimpleEnemy
    with CrystalEligible, Lighting {
  LightingConfig lightingConfig = LightingConfig(radius: 0, color: Colors.black);

  CrystalGameEnemy({
    required Vector2 position,
    required Vector2 size,
    SimpleDirectionAnimation? animation,
    double life = 100,
    double speed = 100,
    Direction initDirection = Direction.right,
    ReceivesAttackFromEnum receivesAttackFrom =
        ReceivesAttackFromEnum.PLAYER_AND_ALLY,
  }) : super(
          position: position,
          size: size,
          life: life,
          speed: speed,
          receivesAttackFrom: receivesAttackFrom,
        ) {
    this.isCarryCrystal = false;
    this.hasReachedFinish = false;
    this.animation = animation;
    lastDirection = initDirection;
    lastDirectionHorizontal =
        initDirection == Direction.left ? Direction.left : Direction.right;

    setupLighting(lightingConfig);
  }

  void execAttack() {
    this.simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: 5,
      interval: 300,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isCarryCrystal) {

    lightingConfig = LightingConfig(
      radius: width * 3.5,
      blurBorder: width * 2,
      pulseSpeed: 0.35,
      withPulse: true,
      pulseCurve: Curves.bounceIn,
      pulseVariation: 0.4,
      color: Colors.lightBlueAccent.withOpacity(0.1),
    );

      Paint p = Paint();
      p.color = Colors.blueAccent;
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(position.x + (size.x / 2), position.y - 10),
              width: 24,
              height: 24),
          p);
    }
  }

  @override
  void die() {
    if (isCarryCrystal) {
      gameRef.add(Crystal(position));
    }

    removeFromParent();
    super.die();
  }

  Crystal? getCrystalOfCurrentMap() {
    var crystal;

    gameRef.visibleComponents().forEach((element) {
      if (element is Crystal) {
        crystal = element;
      }
    });

    return crystal;
  }

  List<TargetCrystalArea> getAreasOfCurrentMap() {
    var areas = <TargetCrystalArea>[];

    gameRef.visibleComponents().forEach((element) {
      if (element is TargetCrystalArea) {
        areas.add(element);
      }
    });

    return areas;
  }
}

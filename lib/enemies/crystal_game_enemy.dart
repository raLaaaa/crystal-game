import 'dart:math';
import 'dart:ui';

import 'package:darkness_dungeon/decoration/areas/target_crystal_area.dart';
import 'package:darkness_dungeon/decoration/coin.dart';
import 'package:darkness_dungeon/decoration/crystal.dart';
import 'package:darkness_dungeon/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flame/cache.dart';

import '../main.dart';
import '../util/enemy_sprite_sheet.dart';
import '../util/sounds.dart';
import 'mixins/crystal_eligible.dart';
import 'package:bonfire/bonfire.dart';

abstract class CrystalGameEnemy extends SimpleEnemy
    with CrystalEligible, Lighting, ObjectCollision {
  LightingConfig lightingConfig =
      LightingConfig(radius: 0, color: Colors.black);

  late int chanceToDropACoin;

  CrystalGameEnemy({
    required Vector2 position,
    required Vector2 size,
    SimpleDirectionAnimation? animation,
    double life = 100,
    double speed = 100,
    chanceToDropACoin = 50,
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
    this.chanceToDropACoin = chanceToDropACoin;
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

      GameImages.crystal.render(canvas,
          position: Vector2(position.x + (size.x / 4), y - 10),
          size: Vector2(18, 18));
    }
  }

  @override
  void die() {
    if (isCarryCrystal) {
      gameRef.add(Crystal(position));
    }

    Random rnd = Random();
    var result = rnd.nextInt(100);

    if (result <= chanceToDropACoin) {
      gameRef.add(Coin(position));
    }

    removeFromParent();
    super.die();
  }

  Crystal? getCrystalOfCurrentMap() {
    var crystal;

    gameRef.decorations().forEach((element) {
      if (element is Crystal) {
        crystal = element;
      }
    });

    return crystal;
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    return super.onCollision(component, active);
  }

  List<TargetCrystalArea> getAreasOfCurrentMap() {
    var areas = <TargetCrystalArea>[];

    gameRef.decorations().forEach((element) {
      if (element is TargetCrystalArea) {
        areas.add(element);
      }
    });

    return areas;
  }
}

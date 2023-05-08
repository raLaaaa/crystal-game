import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/behaviors/dummy_behavior.dart';
import 'package:darkness_dungeon/enemies/behaviors/simple_behavior.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';

import 'behaviors/simple_attack_only_behavior.dart';
import 'mixins/crystal_eligible.dart';

class Dummy extends CrystalGameEnemy with DummyBehavior, MoveToPositionAlongThePath, UseBarLife {
  final Vector2 initPosition;
  double attack = 25;

  Dummy(this.initPosition)
      : super(
          animation: EnemySpriteSheet.golemAnimations(),
          position: initPosition,
          size: Vector2(tileSize * 3, tileSize * 3),
          speed: 20,
          life: 9999999,
        ) {          
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(valueByTileSize(tileSize), valueByTileSize(tileSize)),
            align: Vector2(valueByTileSize(6), valueByTileSize((tileSize) / 2)),
          ),
        ],
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.behave(dt, this);
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: GameSpriteSheet.smokeExplosion(),
        position: this.position,
        size: Vector2(32, 32),
      ),
    );
    super.die();
  }

  void execAttack() {
    this.simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: attack,
      interval: 800,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic id) {
    this.showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.receiveDamage(attacker, damage, id);
  }
}

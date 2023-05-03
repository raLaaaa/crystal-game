import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/behaviors/simple_behavior.dart';
import 'package:darkness_dungeon/enemies/behaviors/simple_only_crystal_behavior.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/player/knight.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';

import 'behaviors/simple_attack_only_behavior.dart';
import 'mixins/crystal_eligible.dart';

class SmallMushroom extends CrystalGameEnemy with SimpleOnlcyCrystalBehavior, MoveToPositionAlongThePath, UseBarLife {
  final Vector2 initPosition;
  double attack = 25;

  SmallMushroom(this.initPosition)
      : super(
          animation: EnemySpriteSheet.smallMushroomAnimations(),
          position: initPosition,
          size: Vector2.all(tileSize * 0.8),
          speed: tileSize / 0.65,
          life: 10,
          chanceToDropACoin: 100
        ) {          


    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(
              valueByTileSize(7),
              valueByTileSize(7),
            ),
            align: Vector2(valueByTileSize(3), valueByTileSize(4)),
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
  bool onCollision(GameComponent component, bool active) {
    if(this.isCarryCrystal && component is Knight) {
        return false;
    }

    return super.onCollision(component, active);
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

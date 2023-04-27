import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/main.dart';

import 'package:flutter/material.dart';

import 'areas/crystal_spawn_area.dart';

class Crystal extends GameDecoration with Lighting, Movement, Sensor, ObjectCollision {
  bool open = false;
  bool showDialog = false;
  double colisionSizeFactor = 0.3;
  
  double speed = 20;

  Crystal(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('items/crystal.png'),
          position: position,
          size: Vector2(tileSize, tileSize),
        ) {

    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize * colisionSizeFactor, tileSize * colisionSizeFactor),
            align: Vector2((tileSize/2) - (tileSize * colisionSizeFactor) / 2, (tileSize/2) - (tileSize * colisionSizeFactor) / 2 ),
          ),
        ],
      ),
    );

    setupLighting(
      LightingConfig(
        radius: width * 3.5,
        blurBorder: width * 2,
        pulseSpeed: 0.35,
        withPulse: true,
        pulseCurve: Curves.bounceIn,
        pulseVariation: 0.4,
        color: Colors.lightBlueAccent.withOpacity(0.08),
      ),
    );

    aboveComponents = true;

    setupSensorArea(
      intervalCheck: 100,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player != null) {

      CrystalSpawnArea spawnArea = gameRef.decorations().firstWhere((element) => element is CrystalSpawnArea) as CrystalSpawnArea;


      if (this.position.distanceTo(spawnArea.position) > 30) {
        this.followComponent(spawnArea, dt, closeComponent: (d) {});
      }
    }
  }

  @override
  void onContact(GameComponent collision) {
    if (collision is CrystalGameEnemy &&
        !checkIfSomeOneAlreadyCarriesCrystal()) {
      collision.isCarryCrystal = true;
      removeFromParent();
    }
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);

  @override
  void onContactExit(GameComponent component) {}

  bool checkIfSomeOneAlreadyCarriesCrystal() {
    bool toReturn = false;

    gameRef.livingEnemies().forEach((e) {
      if (e is CrystalGameEnemy) {
        if (e.isCarryCrystal) {
          toReturn = true;
        }
      }
    });

    return toReturn;
  }
}

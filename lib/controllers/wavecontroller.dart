import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/player/knight.dart';

import '../decoration/areas/target_crystal_area.dart';
import '../enemies/goblin.dart';

class WaveController extends GameComponent {
  final timeBetweenUnitSpawns = Timer(0.5, repeat: false, autoStart: true);
  final timeBetweenWaveChanges = Timer(5, repeat: false, autoStart: false);
  final timingTreshold = .200;
  int counter = 0;
  int counterLimit = 0;
  int currentWave = 0;
  bool spawningIsInProgress = false;
  bool disableWaves = false;
  List<List<CrystalGameEnemy>> waves = [];

  WaveController() {
    setupWaves();
  }

  void setupWaves() {
    List<CrystalGameEnemy> waveOne = [];
    waveOne.add(Goblin(Vector2(0, 0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    // waveOne.add(Goblin(Vector2(0,0)));
    waves.add(waveOne);

    List<CrystalGameEnemy> waveTwo = [];
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waves.add(waveTwo);
    counterLimit = waves[0].length;
  }

  @override
  void update(double dt) {
    if (!disableWaves) {
      timeBetweenUnitSpawns.update(dt);
      timeBetweenWaveChanges.update(dt);

      if (checkIfWaveIsFinished()) {

        if(!timeBetweenWaveChanges.isRunning()) {
          timeBetweenWaveChanges.start();

          if (gameRef.player is Knight) {
            Knight player = gameRef.player as Knight;
            player.currentlyWaveChanging = true;
          } 

        }

        if((timeBetweenWaveChanges.limit - timeBetweenWaveChanges.current) < timingTreshold) {
          currentWave++;
          counter = 0;
          timeBetweenWaveChanges.reset();
          timeBetweenWaveChanges.stop();

          if (gameRef.player is Knight) {
            Knight player = gameRef.player as Knight;
            player.currentlyWaveChanging = false;
          }

        }
        else {
          if (gameRef.player is Knight) {
            Knight player = gameRef.player as Knight;
            player.timeUntilNextWave = (timeBetweenWaveChanges.limit - timeBetweenWaveChanges.current);
          } 
        }

        if (gameRef.player is Knight) {
          Knight player = gameRef.player as Knight;
          player.isOnCurrentWave = currentWave;
        }

        if (currentWave > waves.length - 1) {
          Knight player = gameRef.player as Knight;
          player.isOnCurrentWave = currentWave;
          disableWaves = true;
          print('YOU WON');
          player.won = true;
          timeBetweenUnitSpawns.stop();
          return;
        } else {
          counterLimit = waves[currentWave].length;
        }
      }

      if (timeBetweenUnitSpawns.finished) {
        timeBetweenUnitSpawns.reset();
        timeBetweenUnitSpawns.start();

        if (counter < counterLimit) {
          spawnWave(dt);
        }
      }
    }

    super.update(dt);
  }

  bool checkIfWaveIsFinished() {
    bool toReturn = true;

    waves[currentWave].forEach((element) {
      if (!element.isDead) {
        toReturn = false;
      }
    });

    if (gameRef.livingEnemies().isNotEmpty) {
      toReturn = false;
    }

    return toReturn;
  }

  void spawnWave(dt) {
    var areas = getAreasOfCurrentMap();
    Random random = Random();
    var rnd = random.nextInt(areas.length - 1) + 1;
    CrystalGameEnemy toSpawn = waves[currentWave][counter];
    toSpawn.size = Vector2(tileSize / 1.5, tileSize / 1.5);
    toSpawn.position = areas[rnd].position;

    if (!toSpawn.isDead) {
      gameRef.add(waves[currentWave][counter]);
    }

    counter++;
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

import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/crystal_game_enemy.dart';
import 'package:darkness_dungeon/enemies/dummy.dart';
import 'package:darkness_dungeon/enemies/goblin.dart';
import 'package:darkness_dungeon/enemies/small_skelet.dart';
import 'package:darkness_dungeon/main.dart';
import 'package:darkness_dungeon/player/knight.dart';

import '../decoration/areas/target_crystal_area.dart';
import '../enemies/imp.dart';
import '../util/dialogs.dart';

class WaveController extends GameComponent {
  final timeBetweenUnitSpawns = Timer(1.25, repeat: false, autoStart: true);
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
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(SmallSkelet(Vector2(0, 0)));
    // waveOne.add(Goblin(Vector2(0, 0)));
    // waveOne.add(Goblin(Vector2(0, 0)));
    // waveOne.add(Goblin(Vector2(0, 0)));
    // waveOne.add(Goblin(Vector2(0, 0)));
    waves.add(waveOne);

    List<CrystalGameEnemy> waveTwo = [];
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    waveTwo.add(Goblin(Vector2(0, 0)));
    // // waveTwo.add(Goblin(Vector2(0, 0)));
    //  waveTwo.add(Goblin(Vector2(0, 0)));
    waves.add(waveTwo);

    List<CrystalGameEnemy> waveThree = [];
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    waveThree.add(Imp(Vector2(0, 0)));
    // waveThree.add(Imp(Vector2(0, 0)));
    waves.add(waveThree);

    List<CrystalGameEnemy> waveFour = [];
    waveFour.add(Imp(Vector2(0, 0)));
    waveFour.add(Dummy(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Goblin(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    // waveFour.add(Imp(Vector2(0, 0)));
    waves.add(waveFour);

    counterLimit = waves[0].length;
  }

  @override
  void update(double dt) {
    if (!disableWaves) {
      timeBetweenUnitSpawns.update(dt);
      timeBetweenWaveChanges.update(dt);

      if (checkIfWaveIsFinished()) {
        if (checkIfGameIsWon()) {
          finishGame();
        }

        if (!timeBetweenWaveChanges.isRunning()) {
          timeBetweenWaveChanges.start();
          setPlayerCurrentlyWaveChanging(true);
        }

        if ((timeBetweenWaveChanges.limit - timeBetweenWaveChanges.current) <
            timingTreshold) {
          currentWave++;
          counterLimit = waves[currentWave].length;
          counter = 0;
          timeBetweenWaveChanges.reset();
          timeBetweenWaveChanges.stop();
          setPlayerCurrentlyWaveChanging(false);
        } else {
          setUntilNextWaveOfPlayer();
        }
        setCurrentWaveOfPlayer();
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

  void finishGame() {
    Knight player = gameRef.player as Knight;
    setCurrentWaveOfPlayer();
    setPlayerCurrentlyWaveChanging(false);
    disableWaves = true;
    player.won = true;
    timeBetweenUnitSpawns.stop();
    Dialogs.showCongratulations(gameRef.context);
    return;
  }

  void setPlayerCurrentlyWaveChanging(bool status) {
    if (gameRef.player is Knight) {
      Knight player = gameRef.player as Knight;
      player.currentlyWaveChanging = status;
    }
  }

  void setUntilNextWaveOfPlayer() {
    if (gameRef.player is Knight) {
      Knight player = gameRef.player as Knight;
      player.timeUntilNextWave =
          (timeBetweenWaveChanges.limit - timeBetweenWaveChanges.current);
    }
  }

  void setCurrentWaveOfPlayer() {
    if (gameRef.player is Knight) {
      Knight player = gameRef.player as Knight;
      player.isOnCurrentWave = currentWave;
    }
  }

  bool checkIfGameIsWon() {
    bool result = true;

    waves[waves.length - 1].forEach((element) {
      if (!element.isDead) {
        result = false;
      }
    });

    return result;
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
    var rnd = random.nextInt(areas.length - 1);
    CrystalGameEnemy toSpawn = waves[currentWave][counter];

    if (!(toSpawn is Dummy)) {
      toSpawn.size = Vector2(tileSize / 1.5, tileSize / 1.5);
    }

    if (areas[rnd].width > areas[rnd].height) {
      Random widthRnd = Random();
      var x = 0.0;
      if (toSpawn.size.x > tileSize) {
        x = areas[rnd].position.x + (areas[rnd].width.toInt() / 3);
               
      } else {
        x = widthRnd.nextInt(areas[rnd].width.toInt() - 30) +
            areas[rnd].position.x;
      }
      Vector2 spawnPos = Vector2(x, areas[rnd].position.y);
      toSpawn.position = spawnPos;
    } else {
      Random widthRnd = Random();
      var y = 0.0;
      if (toSpawn.size.y > tileSize) {
        y = areas[rnd].position.y + (areas[rnd].height.toInt() / 3);
      } else {
        y = widthRnd.nextInt(areas[rnd].height.toInt() - 30) +
          areas[rnd].position.y;
      }
      Vector2 spawnPos = Vector2(areas[rnd].position.x, y);
      toSpawn.position = spawnPos;
    }

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

import 'dart:math';

import 'package:bonfire/bonfire.dart';

import '../decoration/areas/target_crystal_area.dart';
import '../enemies/goblin.dart';

class WaveController extends GameComponent {
  final countdown = Timer(5, repeat: false, autoStart: true);
  int counter = 0;
  int counterLimit = 2;
  int currentWave = 0;
  bool spawningIsInProgress = false;
  bool disableWaves = false;

  @override
  void update(double dt) {

    if(!disableWaves) {
    countdown.update(dt);
    
    if(countdown.finished){
      spawnWave(dt);
      countdown.reset();
      countdown.start();

      if(counter == counterLimit) {
        currentWave++;
        counter = 0;
        counterLimit = counterLimit + 1;
        print(currentWave);
      }

    }

    }

    super.update(dt);
  }

  void spawnWave(dt) {
    var areas = getAreasOfCurrentMap();
    Random random = Random();
    var rnd = random.nextInt(areas.length - 1) + 1;


    if(currentWave % 2 == 0) {
      rnd = random.nextInt(2);
      gameRef.add(Goblin(areas[rnd].position));
      rnd = random.nextInt(2) + 2;
      gameRef.add(Goblin(areas[rnd].position));
    }
    else if (currentWave >= 3) {
      gameRef.add(Goblin(areas[0].position));
      gameRef.add(Goblin(areas[2].position));
      gameRef.add(Goblin(areas[3].position));
    }
    else {
      gameRef.add(Goblin(areas[rnd].position));
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

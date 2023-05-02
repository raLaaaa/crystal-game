import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/interface/bar_life_component.dart' as bar_life_component;
import 'package:darkness_dungeon/player/knight.dart';
import 'package:flutter/material.dart';

class KnightInterface extends GameInterface {
  late Sprite key;

  @override
  Future<void> onLoad() async {
    key = await Sprite.load('items/key_silver.png');
    add(bar_life_component.BarLifeComponent());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      _drawKey(canvas);
      _drawWave(canvas);
    } catch (e) {}
    super.render(canvas);
  }

  void _drawKey(Canvas c) {
    if (gameRef.player != null && (gameRef.player as Knight).containKey) {
      key.renderRect(c, Rect.fromLTWH(150, 20, 35, 30));
    }
  }

  void _drawWave(Canvas c) {
    if (gameRef.player != null) {

      Knight p = gameRef.player as Knight;
      TextSpan span;

      if(p.currentlyWaveChanging) {
        span = new TextSpan(style: new TextStyle(color: Colors.blue[800]), text: !p.won ? 'Current Wave: ' + p.isOnCurrentWave.toString(): 'You won!');
      }
      else {
        span = new TextSpan(style: new TextStyle(color: Colors.blue[800]), text: 'Time until next Wave: ${p.timeUntilNextWave}');
      }
      
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(c, new Offset(150, 20));
    }
  }
}

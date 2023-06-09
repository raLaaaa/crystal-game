import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/interface/bar_life_component.dart'
    as bar_life_component;
import 'package:darkness_dungeon/player/knight.dart';
import 'package:flutter/material.dart';

class KnightInterface extends GameInterface {
  late Sprite key;
  late FpsTextComponent fps;
  bool showFPS = true;


  @override
  Future<void> onLoad() async {
    key = await Sprite.load('items/key_silver.png');
    fps = FpsTextComponent(position: Vector2(gameRef.size.x - 100, 20));
    if(showFPS) {
      gameRef.add(fps);
    }
    add(bar_life_component.BarLifeComponent());
    return super.onLoad();
  }

  @override
  void update(dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    try {
     _drawKey(canvas);
     _drawWave(canvas);
     _drawCoins(canvas);
     _drawNextWaveIn(canvas);
    } catch (e) {
      print(e);
    }
    super.render(canvas);
  }

  void _drawKey(Canvas c) {
    if (gameRef.player != null && (gameRef.player as Knight).containKey) {
      key.renderRect(c, Rect.fromLTWH(150, 20, 35, 30));
    }
  }

  void _drawNextWaveIn(Canvas c) {
    if (gameRef.player != null) {
      Knight p = gameRef.player as Knight;

      if (p.currentlyWaveChanging && !p.won) {
        TextPaint textPaint = new TextPaint(
          style: TextStyle(
              color: Colors.blue[800],
              fontSize: 48.0,
              fontWeight: FontWeight.bold),
        );

        double width = gameRef.size.x;
        double height = gameRef.size.y;

        textPaint.render(c, 'Next Wave in', Vector2(width / 2, 150),
            anchor: Anchor.topCenter);

        textPaint.render(
            c, '${p.timeUntilNextWave.toInt()}', Vector2(width / 2, 200),
            anchor: Anchor.topCenter);
      }
    }
  }

  void _drawWave(Canvas c) {
    if (gameRef.player != null) {
      Knight p = gameRef.player as Knight;
      TextSpan span;

      span = new TextSpan(
          style: new TextStyle(color: Colors.blue[800]),
          text: !p.won
              ? 'Current Wave: ' + p.isOnCurrentWave.toString()
              : 'You won!');

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(c, new Offset(150, 20));
    }
  }

  void _drawCoins(Canvas c) {
    if (gameRef.player != null) {
      Knight p = gameRef.player as Knight;
      TextSpan span;

      span = new TextSpan(
          style: new TextStyle(color: Colors.blue[800]),
          text: 'Current Coins: ' + p.collectedCoins.toString());

      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(c, new Offset(150, 40));
    }
  }
}

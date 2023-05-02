import 'package:bonfire/bonfire.dart';
import 'package:flame/flame.dart';


class GameImages {

  static late Sprite crystal;

  static Future initialize() async {
    crystal = Sprite(await Flame.images.load('items/crystal.png'));
  }

}

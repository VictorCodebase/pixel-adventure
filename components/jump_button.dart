// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:pixel_adventure_v2/pixel_adventure.dart';

// class JumpButton extends SpriteComponent with HasGameRef<PixelAdventure>{
//   JumpButton();
//   final double fromEgdeMargin = (32 + 64); //64 is button size, 32 the margin
//   @override
//   FutureOr<void> onLoad() {
//     _spawnButtonSprites();
//     return super.onLoad();
//   }

//   void _spawnButtonSprites() {
//     final upButtonCircle = UpButtonCircle(
//       position: Vector2(
//         fromEgdeMargin,
//         gameRef.size.y - fromEgdeMargin,
//       ),
//       size: Vector2.all(64),
//     );
//     final upButton = UpButton(
//       position: Vector2(
//         fromEgdeMargin,
//         game.size.y - fromEgdeMargin,
//       ),
//     );
//     add(upButtonCircle);
//     add(upButton);
//   }
// }

// class UpButton extends SpriteComponent with HasGameRef<PixelAdventure>{
//   UpButton({position, size}) : super(
//     position: position,
//     size: size,
//   );
//   final int fromEgdeMargin = (32 + 64); //64 is button size, 32 the margin
//   @override
//   FutureOr<void> onLoad() {
//     _spawnButtonSprites();
//     return super.onLoad();
//   }

//   void _spawnButtonSprites() {

//   }
// }

// class UpButtonCircle extends SpriteComponent with HasGameRef<PixelAdventure>{
//   UpButtonCircle({position, size}) : super(
//     position: position,
//     size: size,
//   );
//   final int fromEgdeMargin = (32 + 64); //64 is button size, 32 the margin
//   @override
//   FutureOr<void> onLoad() {
//     _spawnButtonSprites();
//     return super.onLoad();
//   }

//   void _spawnButtonSprites() {

//   }
// }

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure_v2/pixel_adventure.dart';

class JumpButton extends SpriteComponent with HasGameRef<PixelAdventure>, TapCallbacks   {
  JumpButton();

  final margin = 32;
  final buttonSize = 64;
  final double fromEgdeMargin = (32 + 64); //64 is button size, 32 the margin


  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    priority = 1;
    sprite = Sprite(
      game.images.fromCache('HUD/jumpbtn.png'),
    );
    position = Vector2(
      game.size.x - margin - buttonSize, 
      game.size.y - margin - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}

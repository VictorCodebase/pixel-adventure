import 'dart:async';
//import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_v2/components/jump_button.dart';
import 'package:pixel_adventure_v2/components/player.dart';
import 'package:pixel_adventure_v2/components/level.dart';

//FIXME: Add an animated jump icon and fix bugs surrounding it
//FIXME: Fix layer interference bug
class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: "Ninja Frog"); //default character
  late JoystickComponent joystick;

  // TODO: Allow users to change to joystick in settings
  bool showControls = true;
  int level = 1;
  final int totalLevels = 2;

  @override
  FutureOr<void> onLoad() async {
    //To ensure characters are loaded into cache first
    await images.loadAllImages();

    _loadLevel();
    if (showControls){
      add(JumpButton());
      addJoystick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls){
    updateJoystick();
    }
    super.update(dt);
  }


  void addJoystick() {
    joystick = JoystickComponent(
      priority: 999,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      knobRadius: 58,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }
  
  void updateJoystick() {
    switch(joystick.direction){
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1.0;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      player.horizontalMovement = 1.0;
        break;
      default:
        player.horizontalMovement = 0.0;
    }
  }

  void goToNextLevel() {
    if(level < totalLevels) {level++;}
    else{
      level = 1; //TODO: Add a game complete screen}
    }
    _loadLevel();
  }
  
  void _loadLevel() {
    Level world = Level(
      player: player,
      levelName: 'Level-${level.toString().padLeft(2, '0')}',
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
  }
  
  void addUpButton() {
    print("Jump");
    // final upButton = JumpButton(
    //   onTapDown: () {
    //     player.hasJumped = true;
    //   },
    //   onTapUp: () {
    //     player.hasJumped = false;
    //   },
    //);
    //add(upButton);
  }

}

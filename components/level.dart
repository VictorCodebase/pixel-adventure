import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure_v2/components/background_tile.dart';
import 'package:pixel_adventure_v2/components/collision_block.dart';
import 'package:pixel_adventure_v2/components/end_game.dart';
import 'package:pixel_adventure_v2/components/fruit.dart';
import 'package:pixel_adventure_v2/components/player.dart';
import 'package:pixel_adventure_v2/components/saw.dart';
import 'package:pixel_adventure_v2/pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure>{
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> cozllisionBlocks = [];
  List<CollisionBlock> getCollisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    //debugMode = true;

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }
  
  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    const tileSize = 64;
    final numTilesY = (game.size.y / tileSize).floor();
    final numTilesX = (game.size.x / tileSize).floor();

    if (backgroundLayer != null){
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');

      for(double y = 0; y < game.size.y / numTilesY; y++){
        for (double x = 0; x < numTilesX; x++){
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Grey',
            position: Vector2(x * tileSize, y * tileSize),
          );
          add(backgroundTile);
        }
        
      }
    }
  }
  
  void _spawningObjects() {
    print(levelName);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>("SpawnPoints");
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical =spawnPoint.properties.getValue('isVertical');
            final offsetNeg =spawnPoint.properties.getValue('offsetNeg');
            final offsetPos =spawnPoint.properties.getValue('offsetPos');
            final saw = Saw(
              isVeritcal: isVertical ?? false,
              offsetNeg: offsetNeg ?? 0,
              offsetPos: offsetPos ?? 0,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              );
            add(saw);
            break;
            case 'EndGame':
              final endGame = EndGame(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
              );
              add(endGame);
              break;
          default:
        }
      }
    }
  }
  
  void _addCollisions() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
          add(block);
        }
          
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}


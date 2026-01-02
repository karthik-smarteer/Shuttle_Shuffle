import 'package:hive/hive.dart';
import '../models/player_model.dart';

abstract class PlayerLocalDataSource {
  Future<List<PlayerModel>> getPlayers();
  Future<void> addPlayer(PlayerModel player);
  Future<void> deletePlayer(String id);
}

class PlayerLocalDataSourceImpl implements PlayerLocalDataSource {
  final HiveInterface hive;

  PlayerLocalDataSourceImpl({required this.hive});

  @override
  Future<void> addPlayer(PlayerModel player) async {
    final box = await hive.openBox<PlayerModel>('players');
    await box.put(player.id, player);
  }

  @override
  Future<void> deletePlayer(String id) async {
    final box = await hive.openBox<PlayerModel>('players');
    await box.delete(id);
  }

  @override
  Future<List<PlayerModel>> getPlayers() async {
    final box = await hive.openBox<PlayerModel>('players');
    return box.values.toList();
  }
}

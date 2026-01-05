import 'package:hive/hive.dart';
import '../../domain/entities/player.dart';

// 1. This must match the filename exactly
part 'player_model.g.dart';

@HiveType(typeId: 0)
class PlayerModel extends Player {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  const PlayerModel({
    required this.id,
    required this.name,
  }) : super(id: id, name: name);

  factory PlayerModel.fromEntity(Player player) {
    return PlayerModel(
      id: player.id,
      name: player.name,
    );
  }
}

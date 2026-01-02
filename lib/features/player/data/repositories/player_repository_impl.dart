import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_local_data_source.dart';
import '../models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerLocalDataSource localDataSource;

  PlayerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addPlayer(Player player) async {
    try {
      await localDataSource.addPlayer(PlayerModel.fromEntity(player));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayer(String id) async {
    try {
      await localDataSource.deletePlayer(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      final playerModels = await localDataSource.getPlayers();
      return Right(playerModels);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}

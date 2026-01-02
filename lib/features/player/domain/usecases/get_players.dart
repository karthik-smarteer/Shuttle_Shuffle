import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class GetPlayers implements UseCase<List<Player>, NoParams> {
  final PlayerRepository repository;

  GetPlayers(this.repository);

  @override
  Future<Either<Failure, List<Player>>> call(NoParams params) async {
    return await repository.getPlayers();
  }
}

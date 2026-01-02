import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class AddPlayer implements UseCase<void, Player> {
  final PlayerRepository repository;

  AddPlayer(this.repository);

  @override
  Future<Either<Failure, void>> call(Player player) async {
    return await repository.addPlayer(player);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/player_repository.dart';

class DeletePlayer implements UseCase<void, String> {
  final PlayerRepository repository;

  DeletePlayer(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deletePlayer(id);
  }
}

import 'package:dartz/dartz.dart';
import 'package:shuttle_shuffle/features/player/domain/entities/player.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/team.dart';

class ShuffleTeams implements UseCase<List<Team>, List<Player>> {
  @override
  Future<Either<Failure, List<Team>>> call(List<Player> players) async {
    if (players.isEmpty) {
      return const Right([]);
    }

    // Create a copy to avoid modifying the original list
    List<Player> shuffledPlayers = List.from(players);
    shuffledPlayers.shuffle();

    List<Team> teams = [];
    const uuid = Uuid();

    for (int i = 0; i < shuffledPlayers.length; i += 2) {
      if (i + 1 < shuffledPlayers.length) {
        // Pair exists
        teams.add(Team(
          id: uuid.v4(),
          players: [shuffledPlayers[i], shuffledPlayers[i + 1]],
        ));
      } else {
        // Last player (odd number case)
        teams.add(Team(
          id: uuid.v4(),
          players: [shuffledPlayers[i]],
        ));
      }
    }

    return Right(teams);
  }
}

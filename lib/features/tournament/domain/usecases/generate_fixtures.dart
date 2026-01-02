import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';
import 'package:uuid/uuid.dart';
import 'package:shuttle_shuffle/features/match/domain/entities/match.dart';

class GenerateFixtures {
  List<Match> generateRoundRobin(List<Team> teams) {
    if (teams.length < 2) return [];

    List<Match> matches = [];
    final uuid = const Uuid();

    for (int i = 0; i < teams.length; i++) {
      for (int j = i + 1; j < teams.length; j++) {
        matches.add(Match(
          id: uuid.v4(),
          teamA: teams[i],
          teamB: teams[j],
        ));
      }
    }
    return matches;
  }

  // Simple Knockout Generation (Top 4 -> Semis -> Final)
  List<Match> generateKnockoutPhase(List<Team> rankedTeams) {
    if (rankedTeams.length < 4) return []; // Need at least 4 for semis

    final uuid = const Uuid();
    List<Match> matches = [];

    // Semi Final 1: 1st vs 4th
    matches.add(Match(
      id: uuid.v4(),
      teamA: rankedTeams[0],
      teamB: rankedTeams[3],
    ));

    // Semi Final 2: 2nd vs 3rd
    matches.add(Match(
      id: uuid.v4(),
      teamA: rankedTeams[1],
      teamB: rankedTeams[2],
    ));

    return matches;
  }
}

import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';
import 'package:uuid/uuid.dart';
import 'package:shuttle_shuffle/features/match/domain/entities/match.dart';

class GenerateFixtures {
  List<Match> generateRoundRobin(List<Team> teams, int maxPoints) {
    if (teams.length < 2) return [];

    List<Match> matches = [];
    final uuid = const Uuid();

    // Circle Method (Round Robin Scheduling)
    List<Team?> teamList = List.from(teams);
    if (teamList.length % 2 != 0) {
      teamList.add(null); // Bye team
    }

    int numTeams = teamList.length;
    int numRounds = numTeams - 1;

    for (int round = 0; round < numRounds; round++) {
      for (int i = 0; i < numTeams / 2; i++) {
        final teamA = teamList[i];
        final teamB = teamList[numTeams - 1 - i];

        if (teamA != null && teamB != null) {
          matches.add(
            Match(
              id: uuid.v4(),
              teamA: teamA,
              teamB: teamB,
              maxPoints: maxPoints,
            ),
          );
        }
      }

      // Rotate teams (keep the first team fixed)
      final lastTeam = teamList.removeLast();
      teamList.insert(1, lastTeam);
    }

    return matches;
  }

  // Simple Knockout Generation (Top 4 -> Semis -> Final)
  List<Match> generateKnockoutPhase(List<Team> rankedTeams, int maxPoints) {
    if (rankedTeams.length < 4) return []; // Need at least 4 for semis

    final uuid = const Uuid();
    List<Match> matches = [];

    // Semi Final 1: 1st vs 4th
    matches.add(
      Match(
        id: uuid.v4(),
        teamA: rankedTeams[0],
        teamB: rankedTeams[3],
        maxPoints: maxPoints,
      ),
    );

    // Semi Final 2: 2nd vs 3rd
    matches.add(
      Match(
        id: uuid.v4(),
        teamA: rankedTeams[1],
        teamB: rankedTeams[2],
        maxPoints: maxPoints,
      ),
    );

    return matches;
  }
}

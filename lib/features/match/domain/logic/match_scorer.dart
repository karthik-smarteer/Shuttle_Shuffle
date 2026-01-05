import 'package:shuttle_shuffle/features/match/domain/entities/match.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';

class MatchScorer {
  Match incrementScoreA(Match match) {
    int newScoreA = match.scoreA + 1;
    return _checkWinCondition(match.copyWith(scoreA: newScoreA));
  }

  Match incrementScoreB(Match match) {
    int newScoreB = match.scoreB + 1;
    return _checkWinCondition(match.copyWith(scoreB: newScoreB));
  }

  Match _checkWinCondition(Match match) {
    final sA = match.scoreA;
    final sB = match.scoreB;
    final target = match.maxPoints;
    final cap = target + 9; // e.g., 21 -> 30, 11 -> 20

    if (sA >= target || sB >= target) {
      // Standard win with 2 point lead
      if ((sA - sB).abs() >= 2) {
        return _finishMatch(match, sA > sB ? match.teamA : match.teamB);
      }
      // Golden point cap
      if (sA == cap) return _finishMatch(match, match.teamA);
      if (sB == cap) return _finishMatch(match, match.teamB);
    }

    return match;
  }

  Match _finishMatch(Match match, Team winner) {
    return match.copyWith(isFinished: true, winner: winner);
  }
}

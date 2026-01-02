import 'package:shuttle_shuffle/features/match/domain/entities/match.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';

class MatchScorer {
  static const int pointsToWin = 21;
  static const int maxPoints = 30;

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

    if (sA >= pointsToWin || sB >= pointsToWin) {
      // Standard win
      if ((sA - sB).abs() >= 2) {
        return _finishMatch(match, sA > sB ? match.teamA : match.teamB);
      }
      // Golden point cap
      if (sA == maxPoints) return _finishMatch(match, match.teamA);
      if (sB == maxPoints) return _finishMatch(match, match.teamB);
    }
    
    return match;
  }

  Match _finishMatch(Match match, Team winner) {
    return match.copyWith(isFinished: true, winner: winner);
  }
}

import 'package:equatable/equatable.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class StartMatch extends MatchEvent {
  final Team teamA;
  final Team teamB;
  final String? matchId;
  final int maxPoints;

  const StartMatch(this.teamA, this.teamB, {this.matchId, this.maxPoints = 21});

  @override
  List<Object> get props => [
    teamA,
    teamB,
    maxPoints,
    if (matchId != null) matchId!,
  ];
}

class ScoreTeamA extends MatchEvent {}

class ScoreTeamB extends MatchEvent {}

class ResetMatch extends MatchEvent {}

class SkipMatch extends MatchEvent {
  final Team winner;

  const SkipMatch(this.winner);

  @override
  List<Object> get props => [winner];
}

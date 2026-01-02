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

  const StartMatch(this.teamA, this.teamB);

  @override
  List<Object> get props => [teamA, teamB];
}

class ScoreTeamA extends MatchEvent {}

class ScoreTeamB extends MatchEvent {}

class ResetMatch extends MatchEvent {}

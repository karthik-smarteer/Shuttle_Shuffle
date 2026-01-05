import 'package:equatable/equatable.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';
import 'package:shuttle_shuffle/features/tournament/domain/entities/tournament.dart';
import 'package:shuttle_shuffle/features/match/domain/entities/match.dart'
    as match_entity;

abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class StartTournament extends TournamentEvent {
  final List<Team> teams;
  final TournamentType type;
  final int maxPoints;

  const StartTournament(this.teams, this.type, [this.maxPoints = 21]);

  @override
  List<Object> get props => [teams, type, maxPoints];
}

class UpdateMatchResult extends TournamentEvent {
  final match_entity.Match match;

  const UpdateMatchResult(this.match);

  @override
  List<Object> get props => [match];
}

class GenerateNextRound extends TournamentEvent {}

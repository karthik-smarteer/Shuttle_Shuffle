import 'package:equatable/equatable.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';
import 'package:shuttle_shuffle/features/match/domain/entities/match.dart'
    as match_entity;

enum TournamentType { roundRobin, knockout }

class Tournament extends Equatable {
  final String id;
  final TournamentType type;
  final List<Team> teams;
  final List<match_entity.Match> matches;
  final bool isFinished;

  const Tournament({
    required this.id,
    required this.type,
    required this.teams,
    required this.matches,
    this.isFinished = false,
  });

  Tournament copyWith({
    String? id,
    TournamentType? type,
    List<Team>? teams,
    List<match_entity.Match>? matches,
    bool? isFinished,
  }) {
    return Tournament(
      id: id ?? this.id,
      type: type ?? this.type,
      teams: teams ?? this.teams,
      matches: matches ?? this.matches,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object> get props => [id, type, teams, matches, isFinished];
}

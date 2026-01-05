import 'package:equatable/equatable.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';

class Match extends Equatable {
  final String id;
  final Team teamA;
  final Team teamB;
  final int scoreA;
  final int scoreB;
  final bool isFinished;
  final Team? winner;
  final int maxPoints;

  const Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    this.scoreA = 0,
    this.scoreB = 0,
    this.isFinished = false,
    this.winner,
    this.maxPoints = 21,
  });

  Match copyWith({
    String? id,
    Team? teamA,
    Team? teamB,
    int? scoreA,
    int? scoreB,
    bool? isFinished,
    Team? winner,
    int? maxPoints,
  }) {
    return Match(
      id: id ?? this.id,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      isFinished: isFinished ?? this.isFinished,
      winner: winner ?? this.winner,
      maxPoints: maxPoints ?? this.maxPoints,
    );
  }

  @override
  List<Object?> get props => [
    id,
    teamA,
    teamB,
    scoreA,
    scoreB,
    isFinished,
    winner,
    maxPoints,
  ];
}

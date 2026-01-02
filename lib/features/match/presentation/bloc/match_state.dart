import 'package:equatable/equatable.dart';
import '../../domain/entities/match.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {}

class MatchInProgress extends MatchState {
  final Match match;

  const MatchInProgress(this.match);

  @override
  List<Object> get props => [match];
}

class MatchFinished extends MatchState {
  final Match match;

  const MatchFinished(this.match);

  @override
  List<Object> get props => [match];
}

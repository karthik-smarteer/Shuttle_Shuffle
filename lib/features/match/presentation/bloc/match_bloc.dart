import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/match.dart';
import '../../domain/logic/match_scorer.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchScorer scorer;

  MatchBloc({required this.scorer}) : super(MatchInitial()) {
    on<StartMatch>(_onStartMatch);
    on<ScoreTeamA>(_onScoreTeamA);
    on<ScoreTeamB>(_onScoreTeamB);
    on<ResetMatch>(_onResetMatch);
  }

  void _onStartMatch(StartMatch event, Emitter<MatchState> emit) {
    final match = Match(
      id: const Uuid().v4(),
      teamA: event.teamA,
      teamB: event.teamB,
    );
    emit(MatchInProgress(match));
  }

  void _onScoreTeamA(ScoreTeamA event, Emitter<MatchState> emit) {
    if (state is MatchInProgress) {
      final currentMatch = (state as MatchInProgress).match;
      final updatedMatch = scorer.incrementScoreA(currentMatch);
      
      if (updatedMatch.isFinished) {
        emit(MatchFinished(updatedMatch));
      } else {
        emit(MatchInProgress(updatedMatch));
      }
    }
  }

  void _onScoreTeamB(ScoreTeamB event, Emitter<MatchState> emit) {
    if (state is MatchInProgress) {
      final currentMatch = (state as MatchInProgress).match;
      final updatedMatch = scorer.incrementScoreB(currentMatch);

      if (updatedMatch.isFinished) {
        emit(MatchFinished(updatedMatch));
      } else {
        emit(MatchInProgress(updatedMatch));
      }
    }
  }

  void _onResetMatch(ResetMatch event, Emitter<MatchState> emit) {
    if (state is MatchInProgress || state is MatchFinished) {
      Match currentMatch;
      if (state is MatchInProgress) {
        currentMatch = (state as MatchInProgress).match;
      } else {
        currentMatch = (state as MatchFinished).match;
      }

      final resetMatch = Match(
        id: const Uuid().v4(),
        teamA: currentMatch.teamA,
        teamB: currentMatch.teamB,
      );
      emit(MatchInProgress(resetMatch));
    }
  }
}

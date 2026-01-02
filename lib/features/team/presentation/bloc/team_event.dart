import 'package:equatable/equatable.dart';
import 'package:shuttle_shuffle/features/player/domain/entities/player.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object> get props => [];
}

class GenerateTeams extends TeamEvent {
  final List<Player> players;

  const GenerateTeams(this.players);

  @override
  List<Object> get props => [players];
}

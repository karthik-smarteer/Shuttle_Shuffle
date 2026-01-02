import 'package:equatable/equatable.dart';
import '../../domain/entities/player.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class LoadPlayers extends PlayerEvent {}

class AddPlayerEvent extends PlayerEvent {
  final String name;

  const AddPlayerEvent(this.name);

  @override
  List<Object> get props => [name];
}

class RemovePlayerEvent extends PlayerEvent {
  final String id;

  const RemovePlayerEvent(this.id);

  @override
  List<Object> get props => [id];
}

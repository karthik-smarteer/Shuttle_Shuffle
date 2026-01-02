import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/player.dart';
import '../../domain/usecases/add_player.dart';
import '../../domain/usecases/delete_player.dart';
import '../../domain/usecases/get_players.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetPlayers getPlayers;
  final AddPlayer addPlayer;
  final DeletePlayer deletePlayer;

  PlayerBloc({
    required this.getPlayers,
    required this.addPlayer,
    required this.deletePlayer,
  }) : super(PlayerInitial()) {
    on<LoadPlayers>(_onLoadPlayers);
    on<AddPlayerEvent>(_onAddPlayer);
    on<RemovePlayerEvent>(_onRemovePlayer);
  }

  Future<void> _onLoadPlayers(
    LoadPlayers event,
    Emitter<PlayerState> emit,
  ) async {
    emit(PlayerLoading());
    final result = await getPlayers(NoParams());
    result.fold(
      (failure) => emit(const PlayerError('Failed to load players')),
      (players) => emit(PlayerLoaded(players)),
    );
  }

  Future<void> _onAddPlayer(
    AddPlayerEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final uuid = const Uuid().v4();
    final player = Player(id: uuid, name: event.name);
    
    final result = await addPlayer(player);
    result.fold(
      (failure) => emit(const PlayerError('Failed to add player')),
      (_) => add(LoadPlayers()),
    );
  }

  Future<void> _onRemovePlayer(
    RemovePlayerEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final result = await deletePlayer(event.id);
    result.fold(
      (failure) => emit(const PlayerError('Failed to remove player')),
      (_) => add(LoadPlayers()),
    );
  }
}

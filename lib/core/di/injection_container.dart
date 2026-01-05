import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shuttle_shuffle/features/player/data/repositories/player_repository_impl.dart';
import 'package:shuttle_shuffle/features/player/domain/repositories/player_repository.dart';
import '../../features/player/data/datasources/player_local_data_source.dart';
import '../../features/player/data/models/player_model.dart';
import '../../features/player/domain/usecases/add_player.dart';
import '../../features/player/domain/usecases/delete_player.dart';
import '../../features/player/domain/usecases/get_players.dart';
import '../../features/match/domain/logic/match_scorer.dart';
import '../../features/match/presentation/bloc/match_bloc.dart';
import '../../features/player/presentation/bloc/player_bloc.dart';
import '../../features/tournament/domain/usecases/generate_fixtures.dart';
import '../../features/tournament/presentation/bloc/tournament_bloc.dart';
import '../../features/team/domain/usecases/shuffle_teams.dart';
import '../../features/team/presentation/bloc/team_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  // Features - Player Management
  initPlayerFeatures();
  // Features - Team Generation
  initTeamFeatures();
  // Features - Match Scoring
  initMatchFeatures();
  // Features - Tournament
  initTournamentFeatures();
}

void initTournamentFeatures() {
  // Logic
  sl.registerLazySingleton(() => GenerateFixtures());

  // Bloc
  sl.registerFactory(() => TournamentBloc(generateFixtures: sl()));
}

void initMatchFeatures() {
  // Logic
  sl.registerLazySingleton(() => MatchScorer());

  // Bloc
  sl.registerFactory(() => MatchBloc(scorer: sl()));
}

void initTeamFeatures() {
  // Uses cases
  sl.registerLazySingleton(() => ShuffleTeams());

  // Bloc
  sl.registerFactory(() => TeamBloc(shuffleTeams: sl()));
}

void initPlayerFeatures() {
  // Hive Adapter
  Hive.registerAdapter(PlayerModelAdapter());

  // Bloc
  sl.registerFactory(
    () => PlayerBloc(getPlayers: sl(), addPlayer: sl(), deletePlayer: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddPlayer(sl()));
  sl.registerLazySingleton(() => GetPlayers(sl()));
  sl.registerLazySingleton(() => DeletePlayer(sl()));

  // Repository
  sl.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PlayerLocalDataSource>(
    () => PlayerLocalDataSourceImpl(hive: sl()),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_shuffle/features/match/presentation/pages/scoreboard_page.dart';
import 'package:shuttle_shuffle/features/team/domain/entities/team.dart';
import 'package:shuttle_shuffle/features/tournament/domain/entities/tournament.dart';
import 'package:shuttle_shuffle/features/match/domain/entities/match.dart'
    as match_entity;
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';

class TournamentPage extends StatelessWidget {
  final List<Team> teams;
  final TournamentType type;

  const TournamentPage({super.key, required this.teams, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TournamentBloc>()..add(StartTournament(teams, type)),
      child: const TournamentView(),
    );
  }
}

class TournamentView extends StatelessWidget {
  const TournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Standings'),
        centerTitle: true,
      ),
      body: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          if (state is TournamentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TournamentActive) {
            return Column(
              children: [
                // Standings Table
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.05),
                  child: Column(
                    children: [
                      const Text(
                        'Standings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.white24),
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Team',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Points',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...state.standings.entries.map((entry) {
                            final teamName = state.tournament.teams
                                .firstWhere((t) => t.id == entry.key)
                                .players
                                .map((p) => p.name)
                                .join('/');
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(teamName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(entry.value.toString()),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Fixture List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.tournament.matches.length,
                    itemBuilder: (context, index) {
                      final match = state.tournament.matches[index];
                      return Card(
                        color: match.isFinished
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white.withOpacity(0.05),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            '${match.teamA.players.map((p) => p.name).join("/")} vs ${match.teamB.players.map((p) => p.name).join("/")}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: match.isFinished
                              ? Text(
                                  'Score: ${match.scoreA} - ${match.scoreB}',
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                  ),
                                )
                              : const Text('Tap to Play'),
                          trailing: match.isFinished
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.accent,
                                )
                              : const Icon(Icons.play_arrow),
                          onTap: () async {
                            if (!match.isFinished) {
                              final updatedMatch = await Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => ScoreboardPage(
                                        teamA: match.teamA,
                                        teamB: match.teamB,
                                      ),
                                    ),
                                  );

                              if (updatedMatch != null &&
                                  updatedMatch is match_entity.Match) {
                                context.read<TournamentBloc>().add(
                                  UpdateMatchResult(updatedMatch),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (state.tournament.type == TournamentType.knockout &&
                    state.tournament.matches.every((m) => m.isFinished))
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<TournamentBloc>().add(GenerateNextRound());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text('Generate Knockout Round'),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

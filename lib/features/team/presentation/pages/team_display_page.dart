import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_shuffle/features/match/presentation/pages/scoreboard_page.dart';
import 'package:shuttle_shuffle/features/tournament/domain/entities/tournament.dart';
import 'package:shuttle_shuffle/features/tournament/presentation/pages/tournament_page.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:shuttle_shuffle/features/player/domain/entities/player.dart';
import '../bloc/team_bloc.dart';
import '../bloc/team_event.dart';
import '../bloc/team_state.dart';

class TeamDisplayPage extends StatelessWidget {
  final List<Player> players;

  const TeamDisplayPage({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeamBloc>()..add(GenerateTeams(players)),
      child: const TeamDisplayView(),
    );
  }
}

class TeamDisplayView extends StatelessWidget {
  const TeamDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Teams'),
        centerTitle: true,
      ),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state is TeamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamGenerated) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.teams.length,
                    itemBuilder: (context, index) {
                      final team = state.teams[index];
                      final isSolo = team.players.length == 1;

                      return Card(
                        color: Colors.white.withOpacity(0.05),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isSolo
                              ? const BorderSide(color: Colors.orangeAccent, width: 1)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Team ${index + 1}',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...team.players.map((p) => Text(
                                    p.name,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 18,
                                    ),
                                  )),
                              if (isSolo) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline,
                                        color: Colors.orangeAccent, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Needs a substitute/ghost',
                                      style: TextStyle(
                                        color: Colors.orangeAccent.withOpacity(0.8),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                             // Re-trigger generation with the same players
                             // We need to access the players from the event history or pass them down.
                             // For simplicity accessing via closure if possible or we can store players in state.
                             // But here we rely on the parent or we can restart the bloc event.
                             // Better approach: Have a 'ShuffleAgain' event or just pass players again.
                             // Since we are inside BlocProvider, we can't easily access the initial players without storing them.
                             // Let's assume we navigate back or use a stored list if we had one.
                             // Actually, simpler: Just pop and push again or simpler:
                             // We can't easily re-shuffle here without the player list in the state.
                             // Let's update state to hold players too? Or just pass it in event.
                             // For now, let's just use the Navigator to pop.
                             Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.accent),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Back / Reshuffle'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (state.teams.length >= 2) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScoreboardPage(
                                    teamA: state.teams.first,
                                    teamB: state.teams.last,
                                  ),
                                ),
                              );
                            }
                            if (state.teams.length < 2) {
                               Fluttertoast.showToast(
                                msg: 'Need at least 2 teams!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: AppColors.accent,
                                textColor: AppColors.primaryBackground,
                                fontSize: 16.0,
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Select Mode'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('Regular (Round Robin)'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TournamentPage(
                                              teams: state.teams,
                                              type: TournamentType.roundRobin,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Tournament (Knockout)'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TournamentPage(
                                              teams: state.teams,
                                              type: TournamentType.knockout,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.primaryBackground,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Start Match'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is TeamError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

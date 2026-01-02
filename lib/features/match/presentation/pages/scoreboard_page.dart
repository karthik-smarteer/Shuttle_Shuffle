import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../team/domain/entities/team.dart';
import '../bloc/match_bloc.dart';
import '../bloc/match_event.dart';
import '../bloc/match_state.dart';

class ScoreboardPage extends StatelessWidget {
  final Team teamA;
  final Team teamB;

  const ScoreboardPage({
    super.key,
    required this.teamA,
    required this.teamB,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MatchBloc>()..add(StartMatch(teamA, teamB)),
      child: const ScoreboardView(),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Scoreboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final state = context.read<MatchBloc>().state;
            if (state is MatchInProgress) {
              Navigator.of(context).pop(state.match);
            } else if (state is MatchFinished) {
              Navigator.of(context).pop(state.match);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MatchBloc>().add(ResetMatch());
            },
          ),
        ],
      ),
      body: BlocConsumer<MatchBloc, MatchState>(
        listener: (context, state) {
          if (state is MatchFinished) {
            final winner = state.match.winner;
            final message = winner != null 
                ? 'Team Matches Finished! Winner: Team ${winner.players.map((e) => e.name).join(' & ')}'
                : 'Match Finished!';
            
            Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.accent,
              textColor: AppColors.primaryBackground,
              fontSize: 18.0,
            );
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              // We can't return values directly in onPopInvoked for back button, 
              // but we can pass data if we manually pop. 
              // However, for system back button, we can't easily pass data back without using a state management solution 
              // or passing a callback. 
              // A better way for this specific flow:
              // Use a "Finish Match" button or save continuously. 
              // But to keep it simple: We will add a "Done" button in AppBar.
            },
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MatchState state) {
      if (state is MatchInitial) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is MatchInProgress || state is MatchFinished) {
        final match = (state is MatchInProgress)
            ? state.match
            : (state as MatchFinished).match;
        
        return Column(
              children: [
                 const SizedBox(height: 20),
                 _buildTeamScoreSection(
                   context, 
                   'Team A', 
                   match.teamA, 
                   match.scoreA, 
                   Colors.blueAccent,
                   () => context.read<MatchBloc>().add(ScoreTeamA()),
                   state is MatchFinished
                 ),
                 const Divider(height: 40, thickness: 2, color: Colors.grey),
                 _buildTeamScoreSection(
                   context, 
                   'Team B', 
                   match.teamB, 
                   match.scoreB, 
                   Colors.redAccent,
                   () => context.read<MatchBloc>().add(ScoreTeamB()),
                   state is MatchFinished
                 ),
                 if (state is MatchFinished && match.winner != null)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Winner: ${match.winner!.players.map((p) => p.name).join(" & ")}',
                        style: const TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.accent
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              ],
            );
          }
          return const SizedBox.shrink();
        }
  }

  Widget _buildTeamScoreSection(
    BuildContext context, 
    String label, 
    Team team, 
    int score, 
    Color color,
    VoidCallback onScore,
    bool isFinished,
  ) {
    return Expanded(
      child: InkWell(
        onTap: isFinished ? null : onScore,
        child: Container(
          width: double.infinity,
          color: color.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                team.players.map((p) => p.name).join('\n'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (!isFinished)
                const Text(
                  'Tap to Score',
                  style: TextStyle(color: Colors.white38),
                ),
            ],
          ),
        ),
      ),
    );
  }

import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameState {
  final int teamAScore;
  final int teamBScore;
  final List<String> winners;
  final List<Map<String, dynamic>> history;

  GameState({
    this.teamAScore = 0,
    this.teamBScore = 0,
    this.winners = const [],
    this.history = const [],
  });

  GameState copyWith({
    int? teamAScore,
    int? teamBScore,
    List<String>? winners,
    List<Map<String, dynamic>>? history,
  }) {
    return GameState(
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      winners: winners ?? this.winners,
      history: history ?? this.history,
    );
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  void addPoints(int team, int points) {
    if (team == 1) {
      state = state.copyWith(teamAScore: state.teamAScore + points);
    } else if (team == 2) {
      state = state.copyWith(teamBScore: state.teamBScore + points);
    }
  }

  void endGame() {
    String winner;
    if (state.teamAScore > state.teamBScore) {
      winner = 'Team A';
    } else if (state.teamBScore > state.teamAScore) {
      winner = 'Team B';
    } else {
      winner = 'Draw';
    }

    final updatedWinners = [...state.winners, winner];
    final updatedHistory = [
      ...state.history,
      {
        'teamA': state.teamAScore,
        'teamB': state.teamBScore,
        'winner': winner,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ];

    state = state.copyWith(winners: updatedWinners, history: updatedHistory);
  }

  void resetAll() {
    endGame();
    state = state.copyWith(teamAScore: 0, teamBScore: 0);
  }
}

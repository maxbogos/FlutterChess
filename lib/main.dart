import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/chess_engine.dart';
import 'ui/board_view.dart';
import 'ui/game_info_panel.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChessEngine(),
      child: MaterialApp(
        title: 'Chess Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey,
        ),
        home: const ChessBoardScreen(),
      ),
    );
  }
}

class ChessBoardScreen extends StatelessWidget {
  const ChessBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('♟ Chess Game'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Chess Board
                Card(
                  color: Colors.blueGrey.shade800,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: BoardView(),
                  ),
                ),

                const SizedBox(width: 24),

                // Game Info Panel
                SizedBox(
                  width: 250,
                  child: GameInfoPanel(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

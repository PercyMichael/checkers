import 'package:flutter/material.dart';

void main() {
  runApp(const CheckersGame());
}

class CheckersGame extends StatelessWidget {
  const CheckersGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkers Game',
      home: const GameBoard(),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<int>> board = List.generate(8, (index) => List.filled(8, 0));
  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    _setupBoard();
  }

  void _setupBoard() {
    for (int i = 0; i < 3; i++) {
      for (int j = (i % 2); j < 8; j += 2) {
        board[i][j] = 1; // Player 1 pieces
      }
    }
    for (int i = 5; i < 8; i++) {
      for (int j = (i % 2); j < 8; j += 2) {
        board[i][j] = 2; // Player 2 pieces
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkers Game')),
      body: Center(
        // Center the container
        child: Container(
          width: 410, // Total width of the board (8 tiles * 50 pixels)
          height: 410, // Total height of the board (8 tiles * 50 pixels)
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 5), // Add border
          ),
          child: Column(
            children: List.generate(8, (row) {
              return Row(
                children: List.generate(8, (col) {
                  return GestureDetector(
                    onTap: () => _onTileTap(row, col),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: (row + col) % 2 == 0 ? Colors.white : Colors.black,
                      child: Center(
                        child: _buildPiece(row, col),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPiece(int row, int col) {
    if (board[row][col] == 1) {
      return const CircleAvatar(backgroundColor: Colors.red);
    } else if (board[row][col] == 2) {
      return const CircleAvatar(backgroundColor: Colors.blue);
    }
    return const SizedBox.shrink();
  }

  void _onTileTap(int row, int col) {
    if (selectedRow == null && selectedCol == null) {
      // Select a piece
      if (board[row][col] != 0) {
        selectedRow = row;
        selectedCol = col;
        setState(() {});
      }
    } else {
      // Move the selected piece
      if (_isValidMove(row, col)) {
        board[row][col] = board[selectedRow!][selectedCol!];
        board[selectedRow!][selectedCol!] = 0; // Clear the old position
        selectedRow = null; // Deselect
        selectedCol = null; // Deselect
        setState(() {});
      } else {
        // Invalid move, deselect
        selectedRow = null;
        selectedCol = null;
        setState(() {});
      }
    }
  }

  bool _isValidMove(int row, int col) {
    // Check if the move is valid (simple diagonal move)
    if (board[row][col] == 0) {
      int direction = board[selectedRow!][selectedCol!] == 1
          ? 1
          : -1; // Player 1 moves down, Player 2 moves up
      if ((row - selectedRow!) == direction &&
          (col - selectedCol!).abs() == 1) {
        return true; // Regular move
      }
    }
    return false; // Invalid move
  }
}

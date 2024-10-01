import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Assuming you're using the Flame game engine

class CheckerPiece extends PositionComponent {
  final Color color; // Color of the checker piece

  CheckerPiece(this.color);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, CheckersBoard.squareSize / 2 * 0.4,
        paint); // Draw the piece
  }
}

class CheckersBoard extends PositionComponent {
  static const int rows = 8;
  static const int cols = 8;
  static const double squareSize = 50.0; // Size of each square
  static const double borderWidth = 5.0; // Width of the border

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _addCheckerPieces(); // Add checker pieces on load
  }

  void _addCheckerPieces() {
    // Add pieces for the first player (black)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < cols; col++) {
        if ((row + col) % 2 == 1) {
          final piece = CheckerPiece(Colors.yellow)
            ..position = Vector2(col * squareSize + squareSize / 2,
                row * squareSize + squareSize / 2);
          add(piece);
        }
      }
    }

    // Add pieces for the second player (white)
    for (int row = 5; row < 8; row++) {
      for (int col = 0; col < cols; col++) {
        if ((row + col) % 2 == 1) {
          final piece = CheckerPiece(Colors.white)
            ..position = Vector2(col * squareSize + squareSize / 2,
                row * squareSize + squareSize / 2);
          add(piece);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw the squares
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final rect = Rect.fromLTWH(
            col * squareSize, row * squareSize, squareSize, squareSize);
        final paint = Paint()
          ..color = (row % 2 == col % 2) ? Colors.white : Colors.black;
        canvas.drawRect(rect, paint);
      }
    }

    // Draw the border
    final borderRect =
        Rect.fromLTWH(0, 0, cols * squareSize, rows * squareSize);
    final borderPaint = Paint()..color = Colors.black; // Set border color
    canvas.drawRect(
        borderRect,
        borderPaint
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke);
  }

  @override
  NotifyingVector2 get position =>
      super.position; // Override to center the board
}

class CheckersGame extends FlameGame {
  late SpriteComponent background; // Declare background component

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background image
    background = SpriteComponent()
      ..sprite = await loadSprite('bg.png') // Load your image
      ..size = size; // Set the size to match the game size
    add(background); // Add the background to the game

    final board = CheckersBoard()
      ..position = Vector2(
          (size.x - CheckersBoard.cols * CheckersBoard.squareSize) / 2,
          (size.y - CheckersBoard.rows * CheckersBoard.squareSize) / 2);
    add(board);
  }
}

void main() {
  runApp(GameWidget(game: CheckersGame()));
}

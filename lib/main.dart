import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Assuming you're using the Flame game engine

class CheckerPiece extends CircleComponent with TapCallbacks {
  final Color color; // Color of the checker piece
  final int id; // Unique identifier for the piece
  bool isSelected = false; // Track if the piece is selected

  CheckerPiece(this.color, this.id, Vector2 position)
      : super(
          radius: 20, // Set the radius (adjust as needed)
          position: position,
          anchor: Anchor.center, // Center the circle
        ) {
    // Set the color of the circle
    paint = Paint()..color = color;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Toggle selection state
    isSelected = !isSelected;

    if (isSelected) {
      // Create and add the ColorEffect when selected
      final effect = ColorEffect(
        const Color(0xFF00FF00), // Green color
        EffectController(duration: 1.5),
        opacityFrom: 0.2,
        opacityTo: 0.8,
      );
      add(effect);
    } else {
      // Remove all effects when deselected
      // removeAll<ColorEffect>();
    }

    print(
        'Checker piece $id tapped at position: $position'); // Print message with identifier and position on tap
  }
}

class CheckersBoard extends PositionComponent {
  static const int rows = 8;
  static const int cols = 8;
  static const double squareSize = 40.0; // Size of each square
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
          final piece = CheckerPiece(
              Colors.yellow,
              row * cols + col,
              Vector2(col * squareSize + squareSize / 2,
                  row * squareSize + squareSize / 2)) // Pass initial position
            ..size = Vector2(CheckersBoard.squareSize * 0.4,
                CheckersBoard.squareSize * 0.4); // Ensure size is set
          add(piece);
        }
      }
    }

    // Add pieces for the second player (white)
    for (int row = 5; row < 8; row++) {
      for (int col = 0; col < cols; col++) {
        if ((row + col) % 2 == 1) {
          final piece = CheckerPiece(
              Colors.white,
              row * cols + col,
              Vector2(col * squareSize + squareSize / 2,
                  row * squareSize + squareSize / 2)) // Pass initial position
            ..size = Vector2(CheckersBoard.squareSize * 0.4,
                CheckersBoard.squareSize * 0.4); // Ensure size is set
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

  CheckerPiece? selectedPiece; // Track the currently selected piece

  @override
  void onTapUp(TapUpEvent event) {
    // Check which piece was tapped
    final tappedPiece = getPieceAt(event.localPosition);
    if (tappedPiece != null) {
      if (selectedPiece != null) {
        // Deselect the previously selected piece
        selectedPiece!.isSelected = false;
        // Remove the effect from the previously selected piece
        // selectedPiece!.removeAll(); // Remove all effects directly
      }
      // Select the new piece
      selectedPiece = tappedPiece;
      selectedPiece!.isSelected = true;

      // Add effect to the newly selected piece
      final effect = ColorEffect(
        const Color(0xFF00FF00), // Green color
        EffectController(duration: 1.5),
        opacityFrom: 0.2,
        opacityTo: 0.8,
      );
      selectedPiece!.add(effect);
    }
  }

  CheckerPiece? getPieceAt(Vector2 position) {
    // Logic to determine which piece is at the given position
    for (var child in children) {
      if (child is CheckerPiece && child.containsPoint(position)) {
        return child;
      }
    }
    return null;
  }
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

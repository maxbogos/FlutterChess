
/// Represents a position on the chess board
class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  /// Creates a position from algebraic notation (e.g., "e4")
  factory Position.fromAlgebraic(String notation) {
    final col = notation.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final row = 8 - int.parse(notation[1]);
    return Position(row, col);
  }

  /// Converts to algebraic notation (e.g., "e4")
  String toAlgebraic() {
    final colLetter = String.fromCharCode('a'.codeUnitAt(0) + col);
    return '$colLetter${8 - row}';
  }

  Position operator +(Position other) => Position(row + other.row, col + other.col);
  Position operator -(Position other) => Position(row - other.row, col - other.col);
  Position operator *(int scalar) => Position(row * scalar, col * scalar);

  bool operator ==(Object other) =>
      other is Position && row == other.row && col == other.col;

  int get hashCode => row * 1000 + col;

  /// Checks if this position is on the board
  bool isValid() => row >= 0 && row < 8 && col >= 0 && col < 8;

  @override
  String toString() => '($row, $col)';
}

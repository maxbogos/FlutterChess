import 'package:flutter/foundation.dart';
import '../models/board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import '../models/position.dart';
import '../logic/move_validator.dart';

/// Represents the current state of the game
enum GameStatus {
  playing,
  check,
  checkmate,
  stalemate,
  draw,
}

/// The chess engine - manages game state and move execution
class ChessEngine extends ChangeNotifier {
  final Board _board = Board();
  PieceColor _currentTurn = PieceColor.white;
  GameStatus _gameStatus = GameStatus.playing;
  final List<Move> _moveHistory = [];
  final List<Piece> _capturedWhite = [];
  final List<Piece> _capturedBlack = [];
  Position? _selectedPosition;
  final List<Position> _legalMoves = [];
  String _statusMessage = 'White to move';

  // Getters
  Board get board => _board;
  PieceColor get currentTurn => _currentTurn;
  GameStatus get gameStatus => _gameStatus;
  List<Move> get moveHistory => List.unmodifiable(_moveHistory);
  List<Piece> get capturedWhite => List.unmodifiable(_capturedWhite);
  List<Piece> get capturedBlack => List.unmodifiable(_capturedBlack);
  Position? get selectedPosition => _selectedPosition;
  List<Position> get legalMoves => List.unmodifiable(_legalMoves);
  String get statusMessage => _statusMessage;
  bool get isGameOver => _gameStatus != GameStatus.playing && _gameStatus != GameStatus.check;

  /// Initialize the game
  ChessEngine() {
    _board.setupInitialPosition();
  }

  /// Handle a square tap
  void onSquareTapped(Position pos) {
    if (isGameOver) return;

    final piece = _board.at(pos);

    // If a piece is already selected
    if (_selectedPosition != null) {
      // Tapping the same square deselects
      if (_selectedPosition == pos) {
        _deselect();
        return;
      }

      // Tapping another piece of the same color selects that instead
      if (piece != null && piece.color == _currentTurn) {
        _selectPiece(pos);
        return;
      }

      // Try to make a move
      if (_legalMoves.contains(pos)) {
        _makeMove(_selectedPosition!, pos);
        return;
      }

      // Invalid move, deselect
      _deselect();
      return;
    }

    // No piece selected yet
    if (piece != null && piece.color == _currentTurn) {
      _selectPiece(pos);
    }
  }

  /// Select a piece and show its legal moves
  void _selectPiece(Position pos) {
    _selectedPosition = pos;
    _legalMoves.clear();

    final moves = MoveValidator.getAllLegalMoves(_board, _currentTurn);
    for (final move in moves) {
      if (move.from == pos) {
        _legalMoves.add(move.to);
      }
    }

    notifyListeners();
  }

  /// Deselect the current piece
  void _deselect() {
    _selectedPosition = null;
    _legalMoves.clear();
    notifyListeners();
  }

  /// Execute a move
  void _makeMove(Position from, Position to) {
    final piece = _board.at(from);
    if (piece == null) return;

    final capturedPiece = _board.at(to);

    // Track captured pieces
    if (capturedPiece != null) {
      if (capturedPiece.color == PieceColor.white) {
        _capturedWhite.add(capturedPiece);
      } else {
        _capturedBlack.add(capturedPiece);
      }
    }

    // Execute the move
    _board.move(from, to);

    // Handle pawn promotion
    if (piece.type == PieceType.pawn && (to.row == 0 || to.row == 7)) {
      _board.set(to, Piece(type: PieceType.queen, color: piece.color, hasMoved: true));
    }

    // Create move record
    final move = Move(
      from: from,
      to: to,
      capturedPiece: capturedPiece,
    );
    _moveHistory.add(move);

    // Switch turns
    _currentTurn = _currentTurn == PieceColor.white ? PieceColor.black : PieceColor.white;

    // Check game status
    _updateGameStatus();
    _deselect();
  }

  /// Update the game status based on current board state
  void _updateGameStatus() {
    final inCheck = MoveValidator.isInCheck(_board, _currentTurn);
    final checkmate = MoveValidator.isCheckmate(_board, _currentTurn);
    final stalemate = MoveValidator.isStalemate(_board, _currentTurn);

    if (checkmate) {
      _gameStatus = GameStatus.checkmate;
      final winner = _currentTurn == PieceColor.white ? 'Black' : 'White';
      _statusMessage = 'Checkmate! $winner wins!';
    } else if (stalemate) {
      _gameStatus = GameStatus.stalemate;
      _statusMessage = 'Stalemate! Draw.';
    } else if (inCheck) {
      _gameStatus = GameStatus.check;
      _statusMessage = 'Check! ${_currentTurn.name.toUpperCase()} to move';
    } else {
      _gameStatus = GameStatus.playing;
      _statusMessage = '${_currentTurn.name.toUpperCase()} to move';
    }

    notifyListeners();
  }

  /// Reset the game
  void resetGame() {
    _board.setupInitialPosition();
    _currentTurn = PieceColor.white;
    _gameStatus = GameStatus.playing;
    _moveHistory.clear();
    _capturedWhite.clear();
    _capturedBlack.clear();
    _selectedPosition = null;
    _legalMoves.clear();
    _statusMessage = 'White to move';
    notifyListeners();
  }

  /// Undo the last move
  void undoMove() {
    if (_moveHistory.isEmpty) return;

    // For simplicity, reset the game
    // A full implementation would need to track board state
    resetGame();
  }
}

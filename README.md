# ♟ Chess Game in Flutter

A fully functional chess game built with Flutter and Dart, designed to run in the browser. You can play it here : 


## Features

- ✅ **Complete chess rules** - All piece movements validated
- ✅ **Check detection** - Visual warning when king is in check
- ✅ **Checkmate & stalemate** - Game ends properly
- ✅ **Move highlighting** - See all legal moves when selecting a piece
- ✅ **Captured pieces** - Track taken pieces
- ✅ **Pawn promotion** - Auto-promotes to queen
- ✅ **Beautiful UI** - Dark theme with gradient background
- ✅ **Responsive** - Works on desktop and mobile

## Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data layer (pure data)
│   ├── piece.dart           # Piece, PieceColor, PieceType
│   ├── position.dart        # Board position (row, col)
│   ├── board.dart           # 8x8 board representation
│   └── move.dart            # Move representation
├── logic/                    # Business logic (chess rules)
│   ├── move_generator.dart  # Generate all possible moves
│   └── move_validator.dart  # Filter out illegal moves
├── services/                 # State management
│   └── chess_engine.dart    # Game controller (Provider)
└── ui/                       # Presentation layer
    ├── board_view.dart      # Renders the 8x8 grid
    ├── square_view.dart     # Individual square + piece
    └── game_info_panel.dart # Status, captures, controls
```

## How to Run

### Prerequisites

1. Install Flutter (https://flutter.dev/docs/get-started/install)
2. Verify installation: `flutter doctor`

### Setup & Run

```bash
# Navigate to the project
cd chess_game

# Get dependencies
flutter pub get

# Run in Chrome (web)
flutter run -d chrome

# Or build for web deployment
flutter build web
```

### Quick Test in Browser

After running `flutter run -d chrome`, the game will open in your default browser.

## How to Play

1. **Click a piece** of the current player's color to select it
2. **Green highlights** show all legal moves for that piece
3. **Click a highlighted square** to move the piece there
4. **Click the same piece again** to deselect
5. **Click another piece** to switch selection

## Game Rules Implemented

| Feature | Status |
|---------|--------|
| All piece movements | ✅ |
| Turn-based play | ✅ |
| Check detection | ✅ |
| Checkmate detection | ✅ |
| Stalemate detection | ✅ |
| Move validation (no self-check) | ✅ |
| Captured pieces tracking | ✅ |
| Pawn promotion (to queen) | ✅ |

### Not Yet Implemented

- Castling (king-side & queen-side)
- En passant captures
- Pawn promotion choice (auto-promotes to queen)
- Move history/undo
- Draw by repetition
- 50-move rule

## Tech Stack

- **Flutter** - UI framework
- **Provider** - State management
- **Pure Dart** - Game logic (no external chess libraries)

## File Structure

```
chess_game/
├── pubspec.yaml              # Project dependencies
├── analysis_options.yaml     # Linting rules
├── web/
│   └── index.html           # Web entry point
├── lib/
│   ├── main.dart            # App setup
│   ├── models/              # Data models
│   ├── logic/               # Chess rules
│   ├── services/            # Game engine
│   └── ui/                  # Visual components
└── README.md                # This file
```

## License

MIT License - Feel free to use and modify!

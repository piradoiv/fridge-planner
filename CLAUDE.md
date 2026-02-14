# CLAUDE.md

This file provides guidance for AI assistants working with the FridgePlanner codebase.

## Project Overview

FridgePlanner is a native iOS meal planning app built with **Xojo** (version 2025r2+). It helps users plan lunch and dinner for an entire month, with features like an auto-saved meal library, PDF export for printing, and offline SQLite storage. Created by Ricardo Cruz (piradoiv) for the May 2025 open-source challenge.

- **Language:** Xojo
- **Platform:** iOS (primary), with build automation for macOS, Windows, Linux
- **License:** MIT
- **Bundle ID:** `es.rcruz.fridgeplanner`

## Repository Structure

```
fridge-planner/
├── CLAUDE.md                           # This file
├── README.md                           # Project documentation
├── LICENSE                             # MIT License
├── .gitignore                          # Git ignore rules
├── assets/
│   └── icon/                           # App icons (23 PNG files, various iOS sizes)
└── src/
    ├── FridgePlanner.xojo_project      # Main Xojo project file
    ├── FridgePlanner.xojo_resources    # Project resources
    ├── App.xojo_code                   # Application entry point (Sentry init, global state)
    ├── LaunchScreen.xojo_code          # iOS launch screen
    ├── Build Automation.xojo_code      # Build steps for all platforms
    ├── iPhoneLayout.xojo_code          # iPhone layout config
    ├── iPadLayout.xojo_code            # iPad layout config
    ├── Model/                          # Data models and persistence
    │   ├── Meal.xojo_code              # Meal entity (ID, Name, IsLunch, IsDinner)
    │   ├── DailyPlan.xojo_code         # Daily plan (Lunch[], Dinner[], Notes, Colors)
    │   ├── DatabaseManager.xojo_code   # SQLite operations (~404 lines)
    │   └── MealPlanManager.xojo_code   # High-level meal management API (~258 lines)
    ├── GUI/                            # User interface
    │   ├── MainScreen.xojo_code        # Main calendar view
    │   ├── AddMealScreen.xojo_code     # Add/edit meal dialog
    │   ├── PDFScreen.xojo_code         # PDF preview and sharing
    │   ├── DecorationScreen.xojo_code  # Calendar decoration settings
    │   ├── DailyPlanStyleScreen.xojo_code  # Day styling (border, color)
    │   ├── CalendarContainer.xojo_code     # Custom calendar grid (canvas-based)
    │   ├── DayPlanTableContainer.xojo_code # Lunch/dinner table display
    │   └── Colors/                     # 9 color assets with light/dark mode support
    └── Libraries/                      # Third-party code
        ├── Xojo_Sentry.xojo_code       # Sentry error tracking module
        └── Xojo_Sentry/               # Sentry implementation classes (8 files)
```

## Architecture

The app follows an **MVC-like** pattern:

- **Model layer** (`src/Model/`): `Meal` and `DailyPlan` are plain data classes. `DatabaseManager` handles all SQLite operations. `MealPlanManager` wraps the database layer with a higher-level API and caching.
- **View/GUI layer** (`src/GUI/`): 5 screens (`MainScreen`, `AddMealScreen`, `PDFScreen`, `DecorationScreen`, `DailyPlanStyleScreen`) and 2 container controls (`CalendarContainer`, `DayPlanTableContainer`).
- **App entry point** (`src/App.xojo_code`): Initializes Sentry and creates the global `MealsManager` singleton instance. Contains seed data constants (`kLunchMeals`, `kDinnerMeals`).

### Key Patterns

- **Global singleton:** `App.MealsManager` (MealPlanManager) is the central access point for all meal/plan operations
- **Delegation:** `AddMealScreen` communicates back via `AddMealHandler` delegate
- **Event-driven:** Custom events like `DaySelected` (CalendarContainer) and `ReloadRequested` (DayPlanTableContainer)
- **Canvas-based rendering:** The calendar grid is custom-drawn in `CalendarContainer` using Paint events
- **Migration system:** `DatabaseManager` manages schema changes through a `migrations` table with version tracking

## Database Schema

SQLite database stored at `Documents/es.rcruz.fridgeplanner/FridgePlanner.db`.

| Table | Purpose |
|-------|---------|
| `plans` | Daily plans with date, notes, background_color, border_size |
| `meals` | Meal library entries with name, is_lunch, is_dinner flags |
| `plans_meals` | Junction table linking plans to meals (with is_lunch/is_dinner) |
| `migrations` | Tracks applied schema migrations by version number |

Indexes exist on `meals(is_lunch)`, `meals(is_dinner)`, `meals(is_lunch, is_dinner)`, `meals(name)`, and `plans_meals(plan_id, meal_id)`.

## Development Setup

### Requirements

- **Xojo IDE** version 2025r2 or later with iOS support

### Getting Started

1. Clone the repository
2. Open `src/FridgePlanner.xojo_project` in Xojo
3. Build and run using the iOS Simulator or a connected iOS device

### Build Automation

Build steps are defined in `src/Build Automation.xojo_code`:
- **iOS:** Build + Sign
- **macOS:** Build + Sign
- **Windows/Linux:** Build only

## No Automated Tests or CI

This project does not have automated tests, a test framework, linting, or CI/CD pipelines. Testing is done manually in the iOS Simulator or on a physical device. There is conditional debug code (`#If DebugBuild`) used for development-only behavior.

## Coding Conventions

- Follow [Xojo coding conventions](https://documentation.xojo.com/topics/code_management/coding_guidelines.html)
- Xojo code files use the `.xojo_code` extension; color assets use `.xojo_color`
- Color assets support both light and dark mode variants
- SQL queries in `DatabaseManager` use parameterized statements (avoid SQL injection)
- Debug logging is gated behind `LogQueries` flag and `#If DebugBuild` checks

## Git Conventions

- **Branch naming:** Feature branches use `feature/description` format
- **Commit messages:** Short imperative descriptions; reference GitHub issues with `Fix #N` or `Implements #N` syntax
- **Ignored files:** Build outputs, `.xojo_uistate`, `.DS_Store`, debug symbols, `.ipa` files, packaging logs

Examples of commit message style from the project:
```
Fix #13 - Entering an invalid color when editing a cell style won't crash the app anymore
Implements #8 - Custom decoration on PDF generation
Implements #7 - Allow to configure the selected day background color and border size
Add Sentry for error tracking
Performance improvements
```

## External Integrations

- **Sentry** (`Libraries/Xojo_Sentry/`): Error tracking and breadcrumb logging. Configured in `App.InitializeSentry()` with 100% error sampling and 10% trace sampling.

The app is fully **offline-capable** with no external REST APIs or network dependencies beyond Sentry.

## Known Incomplete Features

- `MealPlanManager.SwapMeals()` is partially implemented (contains a `Break` statement)
- Duplicate Previous Month feature is planned but not fully wired up in the UI
- Several open issues exist in the GitHub Issues section

## Important File Locations

| What | Where |
|------|-------|
| Main project file | `src/FridgePlanner.xojo_project` |
| App entry point & seed data | `src/App.xojo_code` |
| Database logic | `src/Model/DatabaseManager.xojo_code` |
| Business logic | `src/Model/MealPlanManager.xojo_code` |
| Calendar rendering | `src/GUI/CalendarContainer.xojo_code` |
| PDF generation | `src/GUI/PDFScreen.xojo_code` |
| Theme colors | `src/GUI/Colors/` |

# Home Screen Mapping (Phase 66)

| React Component | Flutter Implementation | Notes |
| :--- | :--- | :--- |
| `HomeHeader` | `_HomeHeader` (private class) | Gradient background, bold title, dynamic date (stubbed). |
| `Today's Fortune Card` | `_FortuneSummaryCard` | Gradient `LinearGradient(Color(0xFF8B6F47), Color(0xFFC4A574))`, `TweenAnimationBuilder` for entry animation. |
| `QuickAccessGrid` | `_QuickAccessGrid` | 4-column `GridView.builder`, `childAspectRatio: 0.8`. |
| `OracleCard` sections | `OracleCard` usage | Mapped Connection, Consultation, Face Reading, and Yearly Fortune. |

## Animation Mapping
- React: `framer-motion` (`initial`, `animate`)
- Flutter: `TweenAnimationBuilder<double>` for `Opacity` and `Transform.translate` (Y-axis).

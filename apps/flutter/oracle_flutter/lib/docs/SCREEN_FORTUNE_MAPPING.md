# Fortune Screen Mapping (Phase 66)

## Source Files
- React: `src/app/screens/Fortune.tsx`
- Flutter: `lib/app/screens/tabs/fortune_screen.dart`

## UI Sections
1. **Header**: "Fortune" title + subtitle.
2. **Category Tabs**: Horizontal scrollable pill buttons.
3. **Today's Fortune Card**: Large gradient card (same style as Home but with more content: "One-liner" and "Luck scores").
4. **Manseryeok Section**: `OracleCard` containing a "This week" bar chart.
5. **Saju Analysis Section**: `OracleCard` containing element/star/cycle info.
6. **Tarot Section**: `OracleCard` containing 3 card stubs.
7. **Dream Section**: Simple `OracleCard`.

## Navigation Calls
- `fortune-today`
- `calendar`
- `saju-analysis`
- `tarot`
- `dream`

## State / Data
- Categories array: `['전체', '오늘', '만세력', '타로', '꿈해몽']`
- Luck categories: `Love (85)`, `Wealth (72)`, `Health (68)`
- Saju info: `Element: Wood`, `Star: Pyeongwan`, `Cycle: Good`

## Animations
- Today's Fortune Card: `opacity: 0, y: 20` -> `opacity: 1, y: 0`.

## Flutter Implementation Plan
- **Scrolling**: `SingleChildScrollView`.
- **Tabs**: `ListView.builder` (horizontal).
- **Today's Fortune**: Custom widget or reuse `_FortuneSummaryCard` (needs refactoring if reused, but for now I'll create a dedicated one for Fortune screen to match 1:1).
- **OracleCards**: Use `OracleCard` widget with custom `child` contents.
- **I18n**: Move all hardcoded strings to `translations.dart`.

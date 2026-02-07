# Theme Mapping: CSS → Flutter

**Source**: `oracle/figma_tools/figma_1/src/styles/theme.css`
**Target**: `lib/app/theme/app_colors.dart`, `lib/app/theme/app_theme.dart`

> ⚠️ **Note**: Some tokens couldn't be parsed to Flutter Color and are stored as raw strings in `AppColorsRaw`.

---

## :root Variables (Light Theme) - Lines 3-72

| CSS Variable | CSS Value | Line | Parsed? | Flutter Symbol |
|--------------|-----------|------|---------|----------------|
| `--font-size` | `16px` | 4 | ❌ | `AppColorsRaw.root['--font-size']` |
| `--background` | `#FAF8F3` | 7 | ✅ | `AppColorsLight.background` |
| `--foreground` | `#3D3530` | 8 | ✅ | `AppColorsLight.foreground` |
| `--card` | `#FFFFFF` | 9 | ✅ | `AppColorsLight.card` |
| `--card-foreground` | `#3D3530` | 10 | ✅ | `AppColorsLight.cardForeground` |
| `--popover` | `#FFFFFF` | 11 | ✅ | `AppColorsLight.popover` |
| `--popover-foreground` | `#3D3530` | 12 | ✅ | `AppColorsLight.popoverForeground` |
| `--primary` | `#8B6F47` | 15 | ✅ | `AppColorsLight.primary` |
| `--primary-foreground` | `#FFFFFF` | 16 | ✅ | `AppColorsLight.primaryForeground` |
| `--secondary` | `#F5F1EA` | 19 | ✅ | `AppColorsLight.secondary` |
| `--secondary-foreground` | `#3D3530` | 20 | ✅ | `AppColorsLight.secondaryForeground` |
| `--muted` | `#E8E4DD` | 23 | ✅ | `AppColorsLight.muted` |
| `--muted-foreground` | `#6B6258` | 24 | ✅ | `AppColorsLight.mutedForeground` |
| `--accent` | `#E8DED0` | 27 | ✅ | `AppColorsLight.accent` |
| `--accent-foreground` | `#3D3530` | 28 | ✅ | `AppColorsLight.accentForeground` |
| `--destructive` | `#D4756F` | 31 | ✅ | `AppColorsLight.destructive` |
| `--destructive-foreground` | `#FFFFFF` | 32 | ✅ | `AppColorsLight.destructiveForeground` |
| `--border` | `rgba(139, 111, 71, 0.15)` | 35 | ⚠️ | `AppColorsRaw.borderLight` (manually converted) |
| `--input` | `transparent` | 36 | ❌ | `AppColorsRaw.root['--input']` |
| `--input-background` | `#F5F1EA` | 37 | ✅ | `AppColorsLight.inputBackground` |
| `--switch-background` | `#D4C4B0` | 38 | ✅ | `AppColorsLight.switchBackground` |
| `--font-weight-medium` | `600` | 40 | ❌ | `AppColorsRaw.root['--font-weight-medium']` |
| `--font-weight-normal` | `400` | 41 | ❌ | `AppColorsRaw.root['--font-weight-normal']` |
| `--ring` | `#8B6F47` | 42 | ✅ | `AppColorsLight.ring` |
| `--warm-cream` | `#FAF8F3` | 45 | ✅ | `AppColorsLight.warmCream` |
| `--soft-beige` | `#F5F1EA` | 46 | ✅ | `AppColorsLight.softBeige` |
| `--warm-brown` | `#8B6F47` | 47 | ✅ | `AppColorsLight.warmBrown` |
| `--caramel` | `#C4A574` | 48 | ✅ | `AppColorsLight.caramel` |
| `--sage` | `#9DB4A0` | 49 | ✅ | `AppColorsLight.sage` |
| `--peach` | `#E9C5B5` | 50 | ✅ | `AppColorsLight.peach` |
| `--sky-pastel` | `#B8D4E8` | 51 | ✅ | `AppColorsLight.skyPastel` |
| `--warm-gray` | `#6B6258` | 52 | ✅ | `AppColorsLight.warmGray` |
| `--light-brown` | `#D4C4B0` | 53 | ✅ | `AppColorsLight.lightBrown` |
| `--chart-1` | `#8B6F47` | 56 | ✅ | `AppColorsLight.chart1` |
| `--chart-2` | `#9DB4A0` | 57 | ✅ | `AppColorsLight.chart2` |
| `--chart-3` | `#E9C5B5` | 58 | ✅ | `AppColorsLight.chart3` |
| `--chart-4` | `#B8D4E8` | 59 | ✅ | `AppColorsLight.chart4` |
| `--chart-5` | `#C4A574` | 60 | ✅ | `AppColorsLight.chart5` |
| `--radius` | `1rem` | 62 | ⚠️ | `kRadius = 16.0` (assumed 16px base) |
| `--sidebar` | `#FFFFFF` | 64 | ✅ | `AppColorsLight.sidebar` |
| `--sidebar-foreground` | `#3D3530` | 65 | ✅ | `AppColorsLight.sidebarForeground` |
| `--sidebar-primary` | `#8B6F47` | 66 | ✅ | `AppColorsLight.sidebarPrimary` |
| `--sidebar-primary-foreground` | `#FFFFFF` | 67 | ✅ | `AppColorsLight.sidebarPrimaryForeground` |
| `--sidebar-accent` | `#F5F1EA` | 68 | ✅ | `AppColorsLight.sidebarAccent` |
| `--sidebar-accent-foreground` | `#3D3530` | 69 | ✅ | `AppColorsLight.sidebarAccentForeground` |
| `--sidebar-border` | `rgba(139, 111, 71, 0.15)` | 70 | ❌ | `AppColorsRaw.root['--sidebar-border']` |
| `--sidebar-ring` | `#8B6F47` | 71 | ✅ | `AppColorsLight.sidebarRing` |

---

## .dark Variables (Dark Theme) - Lines 74-121

| CSS Variable | CSS Value | Line | Parsed? | Flutter Symbol |
|--------------|-----------|------|---------|----------------|
| `--background` | `#2A2420` | 76 | ✅ | `AppColorsDark.background` |
| `--foreground` | `#F5F1EA` | 77 | ✅ | `AppColorsDark.foreground` |
| `--card` | `#342E28` | 78 | ✅ | `AppColorsDark.card` |
| `--card-foreground` | `#F5F1EA` | 79 | ✅ | `AppColorsDark.cardForeground` |
| `--popover` | `#342E28` | 80 | ✅ | `AppColorsDark.popover` |
| `--popover-foreground` | `#F5F1EA` | 81 | ✅ | `AppColorsDark.popoverForeground` |
| `--primary` | `#C4A574` | 84 | ✅ | `AppColorsDark.primary` |
| `--primary-foreground` | `#2A2420` | 85 | ✅ | `AppColorsDark.primaryForeground` |
| `--secondary` | `#3D362F` | 87 | ✅ | `AppColorsDark.secondary` |
| `--secondary-foreground` | `#F5F1EA` | 88 | ✅ | `AppColorsDark.secondaryForeground` |
| `--muted` | `#3D362F` | 90 | ✅ | `AppColorsDark.muted` |
| `--muted-foreground` | `#A39789` | 91 | ✅ | `AppColorsDark.mutedForeground` |
| `--accent` | `#3D362F` | 93 | ✅ | `AppColorsDark.accent` |
| `--accent-foreground` | `#F5F1EA` | 94 | ✅ | `AppColorsDark.accentForeground` |
| `--destructive` | `#E08B85` | 96 | ✅ | `AppColorsDark.destructive` |
| `--destructive-foreground` | `#2A2420` | 97 | ✅ | `AppColorsDark.destructiveForeground` |
| `--border` | `rgba(196, 165, 116, 0.2)` | 99 | ⚠️ | `AppColorsRaw.borderDark` (manually converted) |
| `--input` | `rgba(196, 165, 116, 0.2)` | 100 | ❌ | `AppColorsRaw.dark['--input']` |
| `--ring` | `#C4A574` | 101 | ✅ | `AppColorsDark.ring` |
| `--font-weight-medium` | `600` | 103 | ❌ | `AppColorsRaw.dark['--font-weight-medium']` |
| `--font-weight-normal` | `400` | 104 | ❌ | `AppColorsRaw.dark['--font-weight-normal']` |
| `--chart-1` | `#C4A574` | 107 | ✅ | `AppColorsDark.chart1` |
| `--chart-2` | `#9DB4A0` | 108 | ✅ | `AppColorsDark.chart2` |
| `--chart-3` | `#E9C5B5` | 109 | ✅ | `AppColorsDark.chart3` |
| `--chart-4` | `#B8D4E8` | 110 | ✅ | `AppColorsDark.chart4` |
| `--chart-5` | `#D4C4B0` | 111 | ✅ | `AppColorsDark.chart5` |
| `--sidebar` | `#2A2420` | 113 | ✅ | `AppColorsDark.sidebar` |
| `--sidebar-foreground` | `#F5F1EA` | 114 | ✅ | `AppColorsDark.sidebarForeground` |
| `--sidebar-primary` | `#C4A574` | 115 | ✅ | `AppColorsDark.sidebarPrimary` |
| `--sidebar-primary-foreground` | `#2A2420` | 116 | ✅ | `AppColorsDark.sidebarPrimaryForeground` |
| `--sidebar-accent` | `#3D362F` | 117 | ✅ | `AppColorsDark.sidebarAccent` |
| `--sidebar-accent-foreground` | `#F5F1EA` | 118 | ✅ | `AppColorsDark.sidebarAccentForeground` |
| `--sidebar-border` | `rgba(196, 165, 116, 0.2)` | 119 | ❌ | `AppColorsRaw.dark['--sidebar-border']` |
| `--sidebar-ring` | `#C4A574` | 120 | ✅ | `AppColorsDark.sidebarRing` |

---

## Unparsed Values Summary

| Reason | Count | Examples |
|--------|-------|----------|
| Non-color value (px, rem, number) | 6 | `--font-size`, `--radius`, `--font-weight-*` |
| `transparent` keyword | 1 | `--input` (light) |
| `rgba()` with manual conversion | 4 | `--border`, `--sidebar-border` |

---

## Radius Constants

From `--radius: 1rem` (L62), assuming 16px base:

| CSS Expression | Flutter Constant | Value |
|----------------|------------------|-------|
| `calc(var(--radius) - 4px)` | `kRadiusSm` | 12.0 |
| `calc(var(--radius) - 2px)` | `kRadiusMd` | 14.0 |
| `var(--radius)` | `kRadiusLg` | 16.0 |
| `calc(var(--radius) + 4px)` | `kRadiusXl` | 20.0 |

---

## Notes
- This mapping was generated in Phase 22 without speculation.
- Some tokens are stored as raw strings to avoid guessing Flutter Color values.
- Font family (L182) is noted as TODO in `app_theme.dart`.

# Components Mapping (Phase 55)

**Source**: `src/app/components/*`
**Target**: `lib/app/widgets/*`

## 1. OracleCard

| Feature | React (`OracleCard.tsx`) | Flutter (`oracle_card.dart`) | Notes |
| :--- | :--- | :--- | :--- |
| **Props** | `title` | `required String title` | |
| | `description` | `String? description` | |
| | `icon` (ReactNode) | `Widget? icon` | |
| | `badge` | `String? badge` | |
| | `accentColor` | `Color? accentColor` | Default: `primary` |
| | `onClick` | `VoidCallback? onTap` | |
| | `children` | `Widget? child` | |
| **Style** | `bg-card`, `rounded-2xl`, `p-5` | `Card` / `Container` | Radius `16.0` (approx 2xl), Padding `20.0` |
| | `shadow-sm`, `border`, `border-border` | `BoxDecoration` | |
| **Animation** | `whileTap={{ scale: 0.98 }}` | `ScaleTransition` | Custom wrapper |
| **Internal** | ChevronRight icon if onClick | `Icons.chevron_right` | |

## 2. BottomNav

| Feature | React (`BottomNav.tsx`) | Flutter (`bottom_nav.dart`) | Notes |
| :--- | :--- | :--- | :--- |
| **Tabs** | 5 fixed tabs | 5 `NavigationDestination` | |
| **Icons** | Lucide: `Home`, `Sparkles`, `Heart`, `History`, `User` | Material: `home`, `auto_awesome`, `favorite`, `history`, `person` | Closest match |
| **Active** | `text-primary`, `strokeWidth=2.5` | `selectedIconTheme` | Color: `primary` |
| **Inactive** | `text-muted-foreground` | `unselectedIconTheme` | Color: `onSurface` (muted) |
| **Layout** | Fixed bottom, `max-w-md` | `NavigationBar` | Height/Padding automatic |

## 3. ImageWithFallback

| Feature | React (`ImageWithFallback.tsx`) | Flutter (`image_with_fallback.dart`) | Notes |
| :--- | :--- | :--- | :--- |
| **Props** | `src`, `alt`, `className` | `src`, `fit`, `width`, `height` | |
| **Error** | `onError` set state `didError` | `Image.network(errorBuilder: ...)` | |
| **Fallback** | Base64 SVG (Grey placeholder) | `SvgPicture.string(...)` | Identical SVG data |
| **UI** | Center SVG in gray bg | Center SVG in surface-variant | |

## SVG Data (Base64 Decoded)
The React `ERROR_IMG_SRC` is a Base64 encoded SVG.
Decoded content:
```svg
<svg width="88" height="88" xmlns="http://www.w3.org/2000/svg" stroke="#000" stroke-linejoin="round" opacity=".3" fill="none" stroke-width="3.7"><rect x="16" y="16" width="56" height="56" rx="6"/><path d="m16 58 16-18 32 32"/><circle cx="53" cy="35" r="7"/></svg>
```

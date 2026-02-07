# Oracle App - Design Tokens

Oracle 사주/운세 앱의 디자인 시스템 토큰입니다. Flutter 또는 다른 플랫폼으로 전환할 때 참고하세요.

## Color Tokens

### Primary Colors
- **Primary**: `#8B6F47` (메인 브라운)
- **Primary Light**: `#C4A574` (골드 브라운)
- **Primary Dark**: `#6B5537`

### Secondary Colors  
- **Cream/Beige**: `#E9C5B5` (따뜻한 크림)
- **Green**: `#9DB4A0` (연한 그린)
- **Blue**: `#B8D4E8` (연한 블루)

### Semantic Colors
- **Background Light**: `#FDFBF8` (따뜻한 화이트)
- **Background Dark**: `#2B2520` (웜 차콜)
- **Card Light**: `#FFFFFF`
- **Card Dark**: `#3A3230`
- **Border Light**: `#E5E0DB`
- **Border Dark**: `#4A4240`

### Text Colors
- **Foreground Light**: `#2B2520`
- **Foreground Dark**: `#F5F5F0`
- **Muted Light**: `#6B625A`
- **Muted Dark**: `#A8A09B`

### Status Colors
- **Success**: `#9DB4A0`
- **Warning**: `#E9C5B5`
- **Error**: `#D9534F`
- **Info**: `#B8D4E8`

## Typography

### Font Families
- **Default**: System font stack
- Korean: `-apple-system, BlinkMacSystemFont, "Segoe UI", "Apple SD Gothic Neo", sans-serif`
- English: `Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`

### Font Sizes
- **xs**: 12px (0.75rem)
- **sm**: 14px (0.875rem)
- **base**: 16px (1rem)
- **lg**: 18px (1.125rem)
- **xl**: 20px (1.25rem)
- **2xl**: 24px (1.5rem)
- **3xl**: 30px (1.875rem)
- **4xl**: 36px (2.25rem)

### Font Weights
- **Normal**: 400
- **Medium**: 500
- **Semibold**: 600
- **Bold**: 700

## Spacing

8pt Grid System 사용

- **0**: 0px
- **1**: 4px (0.25rem)
- **2**: 8px (0.5rem)
- **3**: 12px (0.75rem)
- **4**: 16px (1rem)
- **5**: 20px (1.25rem)
- **6**: 24px (1.5rem)
- **8**: 32px (2rem)
- **10**: 40px (2.5rem)
- **12**: 48px (3rem)
- **16**: 64px (4rem)
- **20**: 80px (5rem)

## Border Radius

- **sm**: 8px (0.5rem)
- **md**: 12px (0.75rem)
- **lg**: 16px (1rem)
- **xl**: 20px (1.25rem)
- **2xl**: 24px (1.5rem)
- **3xl**: 32px (2rem)
- **full**: 9999px (완전한 원형)

## Shadows

### Light Theme
- **sm**: `0 1px 2px 0 rgb(0 0 0 / 0.05)`
- **md**: `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`
- **lg**: `0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)`
- **xl**: `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`
- **2xl**: `0 25px 50px -12px rgb(0 0 0 / 0.25)`

### Dark Theme
- Opacity increased by 50% for better visibility

## Animation

### Duration
- **fast**: 150ms
- **normal**: 300ms
- **slow**: 500ms

### Easing
- **ease-in**: `cubic-bezier(0.4, 0, 1, 1)`
- **ease-out**: `cubic-bezier(0, 0, 0.2, 1)`
- **ease-in-out**: `cubic-bezier(0.4, 0, 0.2, 1)`

## Component-Specific Tokens

### Bottom Navigation
- **Height**: 80px
- **Icon Size**: 24px
- **Active Color**: Primary
- **Inactive Color**: Muted

### Cards
- **Padding**: 16px-24px (depends on size)
- **Border Radius**: 16px-24px
- **Shadow**: md

### Buttons
- **Primary**: Background: Primary, Text: White
- **Secondary**: Background: Card, Border: Border, Text: Foreground
- **Ghost**: Background: Transparent, Text: Primary
- **Height**: 48px (standard), 56px (large)
- **Padding**: 16px-24px horizontal
- **Border Radius**: 12px-16px

### Input Fields
- **Height**: 48px
- **Padding**: 16px
- **Border Radius**: 12px
- **Border**: 1px solid Border
- **Focus**: 2px ring Primary/20

### Score Display
- **Font Size**: 48px-64px (large score)
- **Font Weight**: Bold (700)
- **Color**: Primary

## Icon Sizes

- **xs**: 16px
- **sm**: 20px
- **md**: 24px
- **lg**: 28px
- **xl**: 32px
- **2xl**: 48px
- **3xl**: 64px

## Breakpoints (for responsive design)

- **mobile**: < 640px
- **tablet**: 640px - 1024px
- **desktop**: > 1024px

## Z-Index Layers

- **base**: 0
- **dropdown**: 10
- **modal-backdrop**: 40
- **modal**: 50
- **toast**: 60

## Implementation Notes

1. **Color Consistency**: 모든 색상은 light/dark 테마에서 대응하는 값이 있어야 합니다.
2. **Spacing**: 8pt grid를 엄격하게 따릅니다.
3. **Typography**: 시스템 폰트를 우선 사용하여 플랫폼 네이티브 느낌을 유지합니다.
4. **Accessibility**: WCAG 2.1 AA 기준을 만족하는 대비비를 유지합니다.

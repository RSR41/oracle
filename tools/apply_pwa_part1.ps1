# Oracle PWA Part 1 - 자동 파일 생성 스크립트
# 
# 생성되는 파일 목록:
# 1. pwa/package.json
# 2. pwa/.gitignore
# 3. pwa/.env.example
# 4. pwa/tsconfig.json
# 5. pwa/next.config.js
# 6. pwa/tailwind.config.ts
# 7. pwa/postcss.config.js
# 8. pwa/src/app/layout.tsx
# 9. pwa/src/app/globals.css
# 10. pwa/src/app/page.tsx
# 11. pwa/src/app/not-found.tsx
# 12. pwa/src/app/loading.tsx
# 13. pwa/src/types/index.ts
# 14. pwa/src/lib/constants.ts
# 15. pwa/README.md
# 16. PROJECT_STATE.md
#
# 사용법: 레포 루트에서 실행
# .\tools\apply_pwa_part1.ps1

Write-Host "Oracle PWA Part 1 파일 생성 시작..." -ForegroundColor Green

# 폴더 생성
$folders = @(
    "pwa",
    "pwa/src",
    "pwa/src/app",
    "pwa/src/types",
    "pwa/src/lib",
    "pwa/src/components"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "폴더 생성: $folder" -ForegroundColor Cyan
    }
}

# 1. pwa/package.json
@'
{
  "name": "oracle-pwa",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.4.19",
    "eslint": "^8",
    "eslint-config-next": "14.2.5",
    "postcss": "^8.4.38",
    "tailwindcss": "^3.4.4",
    "typescript": "^5"
  }
}
'@ | Out-File -FilePath "pwa/package.json" -Encoding UTF8
Write-Host "생성: pwa/package.json" -ForegroundColor Yellow

# 2. pwa/.gitignore
@'
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
'@ | Out-File -FilePath "pwa/.gitignore" -Encoding UTF8
Write-Host "생성: pwa/.gitignore" -ForegroundColor Yellow

# 3. pwa/.env.example
@'
# API Configuration
# 백엔드 API Base URL (예: https://api.oracle-app.com 또는 http://localhost:3001)
API_BASE_URL=http://localhost:3001

# Mock Mode (true면 실제 API 호출 없이 가짜 데이터 사용)
NEXT_PUBLIC_MOCK_MODE=true

# 서비스 도메인 (예시 - 실제 배포 시 변경 필요)
# NFC 태그 URL 예시: https://YOUR_DOMAIN/tag/{token}
NEXT_PUBLIC_APP_DOMAIN=https://YOUR_DOMAIN
'@ | Out-File -FilePath "pwa/.env.example" -Encoding UTF8
Write-Host "생성: pwa/.env.example" -ForegroundColor Yellow

# 4. pwa/tsconfig.json
@'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
'@ | Out-File -FilePath "pwa/tsconfig.json" -Encoding UTF8
Write-Host "생성: pwa/tsconfig.json" -ForegroundColor Yellow

# 5. pwa/next.config.js
@'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
}

module.exports = nextConfig
'@ | Out-File -FilePath "pwa/next.config.js" -Encoding UTF8
Write-Host "생성: pwa/next.config.js" -ForegroundColor Yellow

# 6. pwa/tailwind.config.ts
@'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
        },
        fortune: {
          excellent: '#10b981',
          good: '#3b82f6',
          normal: '#f59e0b',
          caution: '#ef4444',
        }
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-in',
        'slide-up': 'slideUp 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        }
      }
    },
  },
  plugins: [],
};
export default config;
'@ | Out-File -FilePath "pwa/tailwind.config.ts" -Encoding UTF8
Write-Host "생성: pwa/tailwind.config.ts" -ForegroundColor Yellow

# 7. pwa/postcss.config.js
@'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
'@ | Out-File -FilePath "pwa/postcss.config.js" -Encoding UTF8
Write-Host "생성: pwa/postcss.config.js" -ForegroundColor Yellow

# 8. pwa/src/app/layout.tsx
@'
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Oracle - 오늘의 운세",
  description: "NFC 키링으로 빠르게 확인하는 오늘의 운세",
  manifest: "/manifest.json",
  themeColor: "#0ea5e9",
  viewport: "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Oracle"
  }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <head>
        <link rel="apple-touch-icon" href="/icon-192x192.png" />
      </head>
      <body className={`${inter.className} bg-gray-50`}>
        {children}
      </body>
    </html>
  );
}
'@ | Out-File -FilePath "pwa/src/app/layout.tsx" -Encoding UTF8
Write-Host "생성: pwa/src/app/layout.tsx" -ForegroundColor Yellow

# 9. pwa/src/app/globals.css
@'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  * {
    @apply border-gray-200;
  }
  
  body {
    @apply text-gray-900;
  }
}

@layer components {
  .btn-primary {
    @apply bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-primary-700 transition-colors shadow-md active:scale-95;
  }
  
  .btn-secondary {
    @apply bg-white text-primary-600 px-6 py-3 rounded-lg font-semibold border-2 border-primary-600 hover:bg-primary-50 transition-colors active:scale-95;
  }
  
  .btn-ghost {
    @apply text-gray-600 px-4 py-2 rounded-lg hover:bg-gray-100 transition-colors;
  }

  .card {
    @apply bg-white rounded-xl shadow-lg p-6;
  }
  
  .card-bordered {
    @apply bg-white rounded-xl border-2 border-gray-200 p-6;
  }

  .input-field {
    @apply w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent;
  }
  
  .label {
    @apply block text-sm font-medium text-gray-700 mb-2;
  }

  .spinner {
    @apply animate-spin rounded-full border-4 border-gray-200 border-t-primary-600;
  }
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
'@ | Out-File -FilePath "pwa/src/app/globals.css" -Encoding UTF8
Write-Host "생성: pwa/src/app/globals.css" -ForegroundColor Yellow

# 10. pwa/src/app/page.tsx
@'
import Link from 'next/link';

export default function Home() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-6">
      <div className="max-w-md w-full space-y-8 text-center">
        <div className="space-y-4">
          <div className="w-24 h-24 mx-auto bg-gradient-to-br from-primary-500 to-primary-700 rounded-full flex items-center justify-center shadow-xl">
            <span className="text-4xl">🔮</span>
          </div>
          <h1 className="text-4xl font-bold text-gray-900">
            Oracle
          </h1>
          <p className="text-lg text-gray-600">
            키링 하나로 빠르게 확인하는<br />
            오늘의 운세
          </p>
        </div>

        <div className="card space-y-4 animate-fade-in">
          <div className="text-left space-y-3">
            <div className="flex items-start space-x-3">
              <span className="text-2xl">✨</span>
              <div>
                <h3 className="font-semibold text-gray-900">NFC 키링을 태그하세요</h3>
                <p className="text-sm text-gray-600">3초 안에 오늘의 운세를 확인할 수 있습니다</p>
              </div>
            </div>
            
            <div className="flex items-start space-x-3">
              <span className="text-2xl">🎁</span>
              <div>
                <h3 className="font-semibold text-gray-900">키링 소유자 전용 혜택</h3>
                <p className="text-sm text-gray-600">매일 체크인으로 전체 리포트를 확인하세요</p>
              </div>
            </div>
          </div>
        </div>

        {process.env.NEXT_PUBLIC_MOCK_MODE === 'true' && (
          <div className="space-y-3">
            <p className="text-sm text-gray-500">개발 모드 - 테스트 링크</p>
            <div className="space-y-2">
              <Link href="/tag/demo-token-123" className="block btn-primary">
                테스트 태그 체험하기
              </Link>
              <Link href="/profile" className="block btn-secondary">
                프로필 입력하기
              </Link>
            </div>
          </div>
        )}

        <div className="pt-6">
          <Link href="/install" className="text-primary-600 hover:underline text-sm">
            앱 설치하기 →
          </Link>
        </div>

        <p className="text-xs text-gray-500 pt-4">
          본 서비스는 오락 및 참고용으로 제공됩니다
        </p>
      </div>
    </main>
  );
}
'@ | Out-File -FilePath "pwa/src/app/page.tsx" -Encoding UTF8
Write-Host "생성: pwa/src/app/page.tsx" -ForegroundColor Yellow

# 11. pwa/src/app/not-found.tsx
@'
import Link from 'next/link';

export default function NotFound() {
  return (
    <main className="min-h-screen flex items-center justify-center p-6">
      <div className="max-w-md w-full text-center space-y-6">
        <div className="text-6xl">🔍</div>
        <h1 className="text-2xl font-bold text-gray-900">
          페이지를 찾을 수 없습니다
        </h1>
        <p className="text-gray-600">
          요청하신 페이지가 존재하지 않거나<br />
          이동되었을 수 있습니다.
        </p>
        <Link href="/" className="inline-block btn-primary">
          홈으로 돌아가기
        </Link>
      </div>
    </main>
  );
}
'@ | Out-File -FilePath "pwa/src/app/not-found.tsx" -Encoding UTF8
Write-Host "생성: pwa/src/app/not-found.tsx" -ForegroundColor Yellow

# 12. pwa/src/app/loading.tsx
@'
export default function Loading() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center space-y-4">
        <div className="w-16 h-16 spinner mx-auto"></div>
        <p className="text-gray-600">로딩 중...</p>
      </div>
    </div>
  );
}
'@ | Out-File -FilePath "pwa/src/app/loading.tsx" -Encoding UTF8
Write-Host "생성: pwa/src/app/loading.tsx" -ForegroundColor Yellow

# 13. pwa/src/types/index.ts
@'
export interface TagInfo {
  token: string;
  isActive: boolean;
  requiresProfile: boolean;
  profileId?: string;
}

export interface Profile {
  id: string;
  birthDate: string;
  birthTime?: string;
  birthTimeUnknown: boolean;
  isLunar: boolean;
  gender?: 'male' | 'female';
  createdAt: string;
}

export interface ProfileFormData {
  birthDate: string;
  birthTime: string;
  birthTimeUnknown: boolean;
  isLunar: boolean;
  gender: 'male' | 'female' | '';
}

export type FortuneScore = 'excellent' | 'good' | 'normal' | 'caution';

export interface FortuneSnapshot {
  date: string;
  score: FortuneScore;
  keywords: string[];
  oneLiner: string;
  preview: {
    love: string;
    money: string;
    health: string;
    work: string;
  };
}

export interface TodayReport {
  date: string;
  score: FortuneScore;
  keywords: string[];
  summary: string;
  details: {
    love: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    money: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    health: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    work: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
  };
  luckyItems?: string[];
  luckyNumbers?: number[];
  isCheckedIn: boolean;
}

export interface CheckinRequest {
  token: string;
  profileId: string;
}

export interface CheckinResponse {
  success: boolean;
  todayReport: TodayReport;
  message?: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
}

export interface ShareCardData {
  date: string;
  score: FortuneScore;
  keywords: string[];
  oneLiner: string;
}
'@ | Out-File -FilePath "pwa/src/types/index.ts" -Encoding UTF8
Write-Host "생성: pwa/src/types/index.ts" -ForegroundColor Yellow

# 14. pwa/src/lib/constants.ts
@'
export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001';
export const MOCK_MODE = process.env.NEXT_PUBLIC_MOCK_MODE === 'true';
export const APP_DOMAIN = process.env.NEXT_PUBLIC_APP_DOMAIN || 'https://YOUR_DOMAIN';

export const STORAGE_KEYS = {
  PROFILE_ID: 'oracle_profile_id',
  LAST_CHECKIN: 'oracle_last_checkin',
} as const;

export const FORTUNE_SCORE_LABELS = {
  excellent: '최고의 하루',
  good: '좋은 하루',
  normal: '평범한 하루',
  caution: '조심스러운 하루',
} as const;

export const FORTUNE_SCORE_COLORS = {
  excellent: 'text-fortune-excellent',
  good: 'text-fortune-good',
  normal: 'text-fortune-normal',
  caution: 'text-fortune-caution',
} as const;

export const FORTUNE_SCORE_BG_COLORS = {
  excellent: 'bg-fortune-excellent',
  good: 'bg-fortune-good',
  normal: 'bg-fortune-normal',
  caution: 'bg-fortune-caution',
} as const;

export const API_ENDPOINTS = {
  TAG_INFO: '/public/tag/:token',
  CREATE_PROFILE: '/public/profile',
  CHECKIN: '/public/checkin',
  TODAY_REPORT: '/public/today-report',
} as const;

export const ERROR_MESSAGES = {
  NETWORK_ERROR: '네트워크 연결을 확인해주세요',
  INVALID_TOKEN: '유효하지 않은 태그입니다',
  INACTIVE_TOKEN: '비활성화된 태그입니다',
  PROFILE_REQUIRED: '프로필 정보를 먼저 입력해주세요',
  CHECKIN_FAILED: '체크인에 실패했습니다',
  UNKNOWN_ERROR: '알 수 없는 오류가 발생했습니다',
} as const;

export const DATE_FORMAT = {
  DISPLAY: 'YYYY년 MM월 DD일',
  API: 'YYYY-MM-DD',
} as const;
'@ | Out-File -FilePath "pwa/src/lib/constants.ts" -Encoding UTF8
Write-Host "생성: pwa/src/lib/constants.ts" -ForegroundColor Yellow

# 15. pwa/README.md
@'
# Oracle PWA

NFC 키링으로 빠르게 확인하는 오늘의 운세 서비스 - PWA

## 빠른 시작 (Windows)

### 1. 프로젝트 이동
cd pwa

### 2. 패키지 설치
npm install

### 3. 환경변수 설정
copy .env.example .env.local

.env.local 파일을 열어서 필요한 값을 수정하세요.

### 4. 개발 서버 실행
npm run dev

브라우저에서 http://localhost:3000 을 열면 앱이 실행됩니다.

## 프로젝트 구조

pwa/
├── src/
│   ├── app/              # Next.js App Router 페이지
│   ├── components/       # 재사용 컴포넌트
│   ├── lib/              # 유틸리티, API 레이어
│   └── types/            # TypeScript 타입 정의
├── public/               # 정적 파일
└── .env.local            # 환경변수 (로컬)

## 주요 기능

1. NFC 태그 진입 (/tag/[token])
2. 프로필 입력 (/profile)
3. 오늘의 운세 (/result/today)
4. PWA 기능

## 보안 규칙

1. NFC 태그에는 token만 저장
2. 개인정보는 서버 DB 또는 localStorage의 profileId로만 관리
3. 모든 결과 화면에 "오락/참고용" 고지
4. 환경변수 파일(.env.local)은 절대 커밋 금지

## 자주 발생하는 오류

### "Module not found" 오류
rmdir /s /q node_modules
npm install

### 포트 충돌 (3000번 포트 사용 중)
npm run dev -- -p 3001

### 환경변수 변경이 적용 안 됨
Ctrl+C로 중단 후 npm run dev 다시 실행
'@ | Out-File -FilePath "pwa/README.md" -Encoding UTF8
Write-Host "생성: pwa/README.md" -ForegroundColor Yellow

# 16. PROJECT_STATE.md
@'
# Oracle 프로젝트 상태

## 전체 진행 상황
- [x] PWA Part 1: 기본 구조 완료
- [ ] PWA Part 2: 핵심 기능 (진행 예정)
- [ ] PWA Part 3: 결과 페이지 및 PWA 설정
- [ ] Backend 구현
- [ ] Android 앱 구현
- [ ] iOS 앱 구현

## PWA Part 1 완료 항목

완성된 파일 (15개):
1. pwa/package.json
2. pwa/.gitignore
3. pwa/.env.example
4. pwa/tsconfig.json
5. pwa/next.config.js
6. pwa/tailwind.config.ts
7. pwa/postcss.config.js
8. pwa/src/app/layout.tsx
9. pwa/src/app/globals.css
10. pwa/src/app/page.tsx
11. pwa/src/app/not-found.tsx
12. pwa/src/app/loading.tsx
13. pwa/src/types/index.ts
14. pwa/src/lib/constants.ts
15. pwa/README.md

주요 구현 내용:
- Next.js 14 App Router 구조
- TypeScript 설정
- Tailwind CSS 디자인 시스템
- 타입 정의 완료
- 홈 페이지 UI
- 환경변수 설정

## Part 2 진행 예정

구현할 파일:
1. pwa/src/lib/api.ts
2. pwa/src/lib/storage.ts
3. pwa/src/lib/mock-data.ts
4. pwa/src/components/LoadingSpinner.tsx
5. pwa/src/components/ErrorMessage.tsx
6. pwa/src/components/FortuneScore.tsx
7. pwa/src/app/tag/[token]/page.tsx
8. pwa/src/app/profile/page.tsx
9. pwa/src/components/ProfileForm.tsx

## 실행 방법 (Windows)

cd pwa
npm install
copy .env.example .env.local
npm run dev

브라우저: http://localhost:3000

## 보안 규칙
1. NFC 태그에는 token만 저장
2. 환경변수는 .env.local 사용
3. 모든 결과에 "오락/참고용" 고지
'@ | Out-File -FilePath "PROJECT_STATE.md" -Encoding UTF8
Write-Host "생성: PROJECT_STATE.md" -ForegroundColor Yellow

Write-Host "`n==================================" -ForegroundColor Green
Write-Host "Part 1 파일 생성 완료!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host "`n다음 단계:" -ForegroundColor Cyan
Write-Host "1. cd pwa" -ForegroundColor White
Write-Host "2. npm install" -ForegroundColor White
Write-Host "3. copy .env.example .env.local" -ForegroundColor White
Write-Host "4. npm run dev" -ForegroundColor White
Write-Host "`n브라우저에서 http://localhost:3000 접속" -ForegroundColor Cyan
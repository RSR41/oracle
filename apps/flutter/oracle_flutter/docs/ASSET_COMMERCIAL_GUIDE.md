# Commercial Asset Usage Guide

## 1. Principles
Oracle Flutter application aims for potential commercial release. Therefore, all images, fonts, icons, and assets must be **legally cleared** for commercial use.

> [!WARNING]
> **Legal Liability**: Using unlicensed assets can lead to app store rejection, lawsuits, or DMCA takedowns.

## 2. AI Generated Images
(Midjourney, Stable Diffusion, DALL-E, etc.)

### 2.1. Commercial Rights
- **Midjourney**: Paid subscribers (Standard/Pro/Mega) own the assets they generate. Free tier (if available) usually requires attribution or restricts commercial use. **Check current subscription status.**
- **Stable Diffusion (Local/Stability AI)**: Generally CC0 (Public Domain), but verify the specific model license (e.g., SDXL 1.0 License).
- **DALL-E 3**: Users generally own rights to generated images.

### 2.2. Policy
1. **Verify License**: Before adding an AI image, confirm the generation service's ToS allows commercial use.
2. **No Copyright**: AI images currently **cannot be copyrighted** in many jurisdictions (US/KR). Do not claim exclusive copyright enforcement on these assets.

## 3. Stock Images & Icons
### 3.1. Safe Sources
- **Unsplash / Pexels**: Free for commercial use (License allows implementation in apps). Attribution appreciated but not required.
- **Material Icons**: Apache 2.0 / OFL (Safe).
- **Purchased Assets**: Keep receipt and license file in `docs/licenses/`.

### 3.2. Prohibited
- **Google Images Search**: Do not use random images found on the web.
- **Non-Commercial (NC) Licenses**: assets labeled CC-BY-NC are **forbidden**.

## 4. Tracking
Maintain a `LICENSES` file or section in `pubspec.yaml` comments for major assets.

- **Path**: `assets/images/tarot_deck/`
  - **Source**: Midjourney (Paid Plan) or Custom Illustrator
  - **License**: Commercial Allowed

## 5. User Generated Content (Face Reading)
- Images taken by users (Camera/Gallery) belong to the **User**.
- **Privacy**: These images must be stored **locally only** (unless cloud backup is explicitly enabled with consent).
- **Liability**: The app is not responsible for the content of user-uploaded images.

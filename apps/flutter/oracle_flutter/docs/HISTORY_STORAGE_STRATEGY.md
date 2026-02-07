# History Storage Strategy (Local SQLite)

## 1. Overview
The Oracle app uses a **Single Table Strategy** (`history` table) stored in a local SQLite database (`oracle_app.db`) to manage all user activity records, including Fortune, Dream Interpretation, Tarot, Face Reading, and compatibility results.

This approach simplifies queries, searching, and potential future cloud synchronization.

## 2. Helper & Schema
- **File**: `lib/app/database/database_helper.dart` (Singleton)
- **Table**: `history`

### Schema Design
| Column | Type | Description |
|---|---|---|
| `id` | TEXT (PK) | UUID v4 |
| `type` | TEXT | 'fortune', 'dream', 'tarot', 'faceReading', 'compatibility' |
| `title` | TEXT | User-facing title (e.g., "Daily Fortune", "Dragon Dream") |
| `summary` | TEXT | Short result summary for list view |
| `content` | TEXT | Main advice or details (searchable) |
| `overallScore` | INTEGER | Numeric score (0-100) for sorting/stats |
| `date` | TEXT | "YYYY-MM-DD" (Logical date of the reading) |
| `createdAt` | TEXT | ISO8601 Timestamp (for sorting) |
| `payloadJson` | TEXT | JSON string containing full feature-specific data |
| `mediaPaths` | TEXT | JSON list of local file paths (images) |

**Indexes**:
- `idx_history_type`: Fast filtering by category.
- `idx_history_createdAt`: Pagination and sorting.

## 3. Storage Policy

### 3.1. Complex Data (Payload)
Features like Tarot (card positions, meanings) or Face Reading (feature breakdown) have unique data structures.
- **Strategy**: Store the structured object as a JSON string in `payloadJson`.
- **Restoration**: `HistoryRepository.getPayload(id)` retrieves and decodes this JSON. Feature-specific models (e.g., `TarotResult`, `DreamResult`) should implement `.fromJson()` to restore the UI state.

### 3.2. Image Storage
Features like **Face Reading** involve user images.
- **Problem**: Temporary cache paths (e.g., from ImagePicker) are cleared by the OS.
- **Strategy**:
  1. **Copy** the image file to `ApplicationDocumentsDirectory` (persistent app storage).
  2. Store the **persistent path** in the `mediaPaths` column (JSON array).
  3. **Delete** the file when the history item is deleted (`HistoryRepository.delete` should handle cleanup).

## 4. Scalability & Pagination

### 4.1. Pagination API
As history grows, loading all items becomes slow.
- **Implementation**: `HistoryRepository.getHistoryPaged({String? type, int limit=30, int offset=0})`
- **UI**: Use `ListView.builder` with "Infinite Scroll" or a "Load More" button.
- **Default Limit**: 30 items per page.

## 5. Backup & cleanup
- **Export**: Future feature to dump `history` table to JSON for backup.
- **Cleanup**: If DB exceeds size limits (e.g., >100MB of text), implement auto-deletion of old records (e.g., keep last 1 year) or user-initiated "Clear All".

# Porting Bug Report (Phase 66)

Log of bugs found in React source or issues encountered during porting. These are NOT fixed in Flutter unless they cause crashes, but are documented for future consistency.

| ID | Screen | React Source Issue | Symptom | Flutter Mitigation |
| :--- | :--- | :--- | :--- | :--- |
| BUG-001 | History | Hardcoded Detail Screens | Calls `${type}-detail` which doesn't exist for some types. | Redirect to `ComingSoonScreen` with debug info. |

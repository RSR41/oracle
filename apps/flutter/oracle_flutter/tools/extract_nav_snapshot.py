import re
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[4]  # .../oracle
REACT = REPO / "figma_tools" / "figma_1" / "src" / "app"

app_tsx = (REACT / "App.tsx").read_text(encoding="utf-8")
bottom_nav = (REACT / "components" / "BottomNav.tsx").read_text(encoding="utf-8")

def find_all(pattern, text):
  return re.findall(pattern, text, flags=re.MULTILINE)
# App.tsx main tabs: 두 군데에 동일 배열이 있음 (handleBack includes + BottomNav show condition)
tabs_includes = re.search(r"\[\s*'home'\s*,\s*'fortune'\s*,\s*'compatibility'\s*,\s*'history'\s*,\s*'profile'\s*\]", app_tsx)
main_tabs = ['home','fortune','compatibility','history','profile'] if tabs_includes else []

# App.tsx switch cases (case 'xxx':)
switch_cases = find_all(r"case\s+'([^']+)'\s*:", app_tsx)

# placeholder 케이스: App.tsx에서 "준비 중입니다"를 반환하는 그룹
# (case 'fortune-today': case 'calendar': ... case 'premium':)
placeholder_block = re.search(r"// Placeholder screens.*?case\s+'premium'\s*:\s*return\s*\(", app_tsx, flags=re.DOTALL)
placeholder_cases = []
if placeholder_block:
  placeholder_cases = find_all(r"case\s+'([^']+)'\s*:", placeholder_block.group(0))

# BottomNav tabs ids (React source 그대로)
bottom_tabs = find_all(r"id:\s*'([^']+)'\s*,\s*icon:", bottom_nav)

# screens 폴더에서 onNavigate('xxx') 문자열 호출 수집
screens_dir = REACT / "screens"
navigate_targets = set()
dynamic_templates = []

for p in screens_dir.glob("*.tsx"):
  txt = p.read_text(encoding="utf-8")
  for m in re.finditer(r"onNavigate\(\s*'([^']+)'\s*(?:,|\))", txt):
    navigate_targets.add(m.group(1))
  # 템플릿 문자열 형태: onNavigate(`${item.type}-detail`, ...)
  if "onNavigate(`${item.type}-detail`" in txt or "`${item.type}-detail`" in txt:
    dynamic_templates.append({"file": str(p), "pattern": "${item.type}-detail"})

# History.tsx에서 type 후보 추출 (historyItems 배열)
history_path = screens_dir / "History.tsx"
history_types = []
detail_screens = []
if history_path.exists():
  htxt = history_path.read_text(encoding="utf-8")
  history_types = sorted(set(re.findall(r"type:\s*'([^']+)'", htxt)))
  detail_screens = [f"{t}-detail" for t in history_types]

out = {
  "react_base": str(REACT),
  "main_tabs_from_App_tsx": main_tabs,
  "bottomnav_tabs_from_BottomNav_tsx": bottom_tabs,
  "switch_cases_from_App_tsx": switch_cases,
  "placeholder_cases_from_App_tsx": placeholder_cases,
  "navigate_targets_literal_from_screens": sorted(navigate_targets),
  "dynamic_templates_found": dynamic_templates,
  "history_types_from_History_tsx": history_types,
  "detail_screens_expected_from_History_tsx": detail_screens,
}

print(json.dumps(out, ensure_ascii=False, indent=2))

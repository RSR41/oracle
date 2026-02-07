import re, pathlib

src = pathlib.Path("figma_tools/figma_1/src/app/contexts/AppContext.tsx")
out = pathlib.Path("apps/flutter/oracle_flutter/lib/app/i18n/translations.dart")

print(f"Reading from: {src.resolve()}")
text = src.read_text(encoding="utf-8")

# translations 블록만 추출
m = re.search(r"const\s+translations\s*=\s*\{(.*)\};\s*\n\s*const\s+AppContext", text, re.S)
if not m:
    print("ERROR: translations block not found in AppContext.tsx")
    exit(1)

block = m.group(1)

lang = None
data = {"ko": {}, "en": {}}

for line in block.splitlines():
    line = line.strip()
    if not line: continue

    # Language block start: 'ko: {' or 'en: {'
    mlang = re.match(r"^(ko|en)\s*:\s*\{$", line)
    if mlang:
        lang = mlang.group(1)
        continue

    # Closing brace for language block or main block
    if re.match(r"^\},?$", line):
        continue

    # Key-Value pair: 'key': 'value',
    mkv = re.match(r"^'([^']+)'\s*:\s*(['\"].*['\"]),?$", line)
    if mkv and lang in data:
        k = mkv.group(1)
        v_raw = mkv.group(2)
        # Remove surrounding quotes (handle both ' and ")
        if v_raw.startswith("'") and v_raw.endswith("'"):
            v = v_raw[1:-1]
        elif v_raw.startswith('"') and v_raw.endswith('"'):
            v = v_raw[1:-1]
        else:
            v = v_raw # Should not happen based on regex
            
        data[lang][k] = v

if len(data["ko"]) == 0 or len(data["en"]) == 0:
    print("ERROR: No keys parsed. Check Regex.")
    print(f"Block preview:\n{block[:200]}")
    exit(1)

def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$")

lines = []
lines.append("// GENERATED from React AppContext.tsx translations (Phase 33). DO NOT EDIT MANUALLY.")
lines.append("//")
lines.append("// Source: oracle/figma_tools/figma_1/src/app/contexts/AppContext.tsx")
lines.append("")
lines.append("enum AppLanguage { ko, en }")
lines.append("")
lines.append("class Translations {")
lines.append("  static const Map<AppLanguage, Map<String, String>> data = {")
for lg in ("ko", "en"):
    dart_lg = "AppLanguage.ko" if lg == "ko" else "AppLanguage.en"
    lines.append(f"    {dart_lg}: {{")
    for k in sorted(data[lg].keys()):
        v = data[lg][k]
        lines.append(f"      '{esc(k)}': '{esc(v)}',")
    lines.append("    },")
lines.append("  };")
lines.append("")
lines.append("  /// React t(key): translations[language][key] || key")
lines.append("  static String t(AppLanguage language, String key) {")
lines.append("    final map = data[language];")
lines.append("    if (map == null) return key;")
lines.append("    return map[key] ?? key;")
lines.append("  }")
lines.append("}")

print(f"Writing to: {out.resolve()}")
out.write_text("\n".join(lines), encoding="utf-8")

print(f"[OK] Generated translations.dart")
print(f"KO keys: {len(data['ko'])}")
print(f"EN keys: {len(data['en'])}")

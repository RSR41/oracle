/// Solar-term table scaffolding for saju year/month resolution.
///
/// NOTE:
/// - This file intentionally starts as a structural scaffold.
/// - The long-term plan is to populate 1900~2100 KST timestamps generated
///   from a verified source (e.g. KASI-based preprocessing).
/// - Current app logic can keep using legacy approximate boundaries until the
///   table is fully populated and resolver migration is completed.

library;

enum SolarTerm {
  sohan,
  ipchun,
  gyeongchip,
  cheongmyeong,
  ipha,
  mangjong,
  soseo,
  ipchu,
  baengno,
  hallo,
  ipdong,
  daeseol,
}

class SolarTermEntry {
  final int year;
  final SolarTerm term;
  final DateTime dateTime;

  const SolarTermEntry(this.year, this.term, this.dateTime);
}

/// Year -> term -> unix timestamp(seconds), intended to be KST-based source
/// data generated offline.
const Map<int, Map<SolarTerm, int>> kSolarTermTable = {};

DateTime? getSolarTermDateTime(int year, SolarTerm term) {
  final yearData = kSolarTermTable[year];
  if (yearData == null) return null;

  final timestamp = yearData[term];
  if (timestamp == null) return null;

  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

List<SolarTermEntry> buildSolarTermSequence(int year) {
  final result = <SolarTermEntry>[];
  for (final y in [year - 1, year, year + 1]) {
    for (final term in SolarTerm.values) {
      final dt = getSolarTermDateTime(y, term);
      if (dt != null) {
        result.add(SolarTermEntry(y, term, dt));
      }
    }
  }
  result.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  return result;
}

bool isNearSolarTermBoundary(
  DateTime birthDateTime, {
  Duration threshold = const Duration(hours: 24),
}) {
  final sequence = buildSolarTermSequence(birthDateTime.year);
  if (sequence.isEmpty) return false;

  for (final entry in sequence) {
    final diff = birthDateTime.difference(entry.dateTime).abs();
    if (diff <= threshold) return true;
  }
  return false;
}

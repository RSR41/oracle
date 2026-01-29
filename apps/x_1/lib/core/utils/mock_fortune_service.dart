import 'dart:math';
import 'package:x_1/shared/domain/models/profile.dart';

class MockFortuneService {
  // Deterministic random generator based on seed
  static Random _getSeededRandom(Profile profile) {
    // Seed combining name and today's date so result is constant for the day
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final seedString = '${profile.name}-${profile.birthDate}-$todayStr';
    final seed = seedString.codeUnits.fold(0, (prev, curr) => prev + curr);
    return Random(seed);
  }

  static Map<String, dynamic> generateSaju(Profile profile) {
    final random = _getSeededRandom(profile);

    // Mock Pillars
    final stems = ['??, 'ä¹?, 'ä¸?, 'ä¸?, '??, 'å·?, 'åº?, 'è¾?, 'å£?, '??];
    final branches = [
      'å­?,
      'ä¸?,
      'å¯?,
      '??,
      'è¾?,
      'å·?,
      '??,
      '??,
      '??,
      '??,
      '??,
      'äº?
    ];

    // Simple helper
    String randPillar() =>
        '${stems[random.nextInt(stems.length)]}${branches[random.nextInt(branches.length)]}';

    final textOptions = [
      'Today brings unexpected opportunities. Embrace change with confidence.',
      'A quiet day for reflection. Focus on your inner peace.',
      'Your hard work is about to pay off. Stay persistent.',
      'Be cautious with financial decisions today. Think twice.',
      'Romance is in the air. Open your heart to new connections.',
    ];

    return {
      'year': randPillar(),
      'month': randPillar(),
      'day': randPillar(),
      'time': randPillar(),
      'luckyNumber': random.nextInt(9) + 1,
      'luckyColor': [
        'Gold',
        'Red',
        'Blue',
        'Green',
        'Silver'
      ][random.nextInt(5)],
      'summary': textOptions[random.nextInt(textOptions.length)],
    };
  }

  static Map<String, dynamic> generateCompatibility(
      Profile me, String partnerName, DateTime partnerDate) {
    final seedString =
        '${me.name}-${me.birthDate}-$partnerName-${partnerDate.toIso8601String()}';
    final seed = seedString.codeUnits.fold(0, (prev, curr) => prev + curr);
    final random = Random(seed);

    final score = 50 + random.nextInt(51); // 50-100
    final textOptions = [
      'A challenging match that requires patience.',
      'Good potential if you communicate well.',
      'A very harmonious relationship.',
      'Soulmates! You understand each other perfectly.',
      'Different energies, but complementary.',
    ];

    return {
      'score': score,
      'summary': textOptions[random.nextInt(textOptions.length)],
      'partnerName': partnerName,
      'partnerDate': partnerDate.toIso8601String().split('T')[0],
    };
  }

  static Map<String, dynamic> generateTarot() {
    final random = Random();
    final cards = [
      'The Fool',
      'The Magician',
      'The High Priestess',
      'The Empress',
      'The Emperor',
      'The Hierophant',
      'The Lovers',
      'The Chariot',
      'Strength',
      'The Hermit',
      'Wheel of Fortune',
      'Justice',
      'The Hanged Man',
      'Death',
      'Temperance',
      'The Devil',
      'The Tower',
      'The Star',
      'The Moon',
      'The Sun',
      'Judgement',
      'The World'
    ];

    // Pick 3 unique cards
    final shuffled = List<String>.from(cards)..shuffle(random);
    final picks = shuffled.take(3).toList();

    final textOptions = [
      'Focus on new beginnings and trust your instincts.',
      'A period of reflection is needed before action.',
      'Success is within reach if you stay balanced.',
      'Unexpected changes will bring positive growth.',
      'Trust in the journey, even if the path is unclear.',
    ];

    return {
      'past': picks[0],
      'present': picks[1],
      'future': picks[2],
      'summary': textOptions[random.nextInt(textOptions.length)],
    };
  }
}

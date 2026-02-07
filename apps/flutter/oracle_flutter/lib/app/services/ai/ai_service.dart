import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:oracle_flutter/app/config/api_config.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';

/// AI 분석 결과 모델
class AiReadingResult {
  final String title;
  final String summary;
  final List<AiReadingDetail> details;
  final String? caution;
  final String disclaimer;

  AiReadingResult({
    required this.title,
    required this.summary,
    required this.details,
    this.caution,
    required this.disclaimer,
  });

  factory AiReadingResult.fromJson(Map<String, dynamic> json) {
    return AiReadingResult(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => AiReadingDetail.fromJson(e))
              .toList() ??
          [],
      caution: json['caution'],
      disclaimer:
          json['disclaimer'] ?? '본 분석은 오락 목적의 참고 정보이며, 전문적인 조언을 대체하지 않습니다.',
    );
  }
}

class AiReadingDetail {
  final String category;
  final String content;
  final int? rating;

  AiReadingDetail({required this.category, required this.content, this.rating});

  factory AiReadingDetail.fromJson(Map<String, dynamic> json) {
    return AiReadingDetail(
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'],
    );
  }
}

/// AI 서비스 예외
class AiServiceException implements Exception {
  final String message;
  final int? statusCode;

  AiServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'AiServiceException: $message (statusCode: $statusCode)';
}

/// AI 서비스
///
/// 백엔드 AI API를 호출하여 사주/타로/꿈해몽/관상 해석을 제공합니다.
///
/// ⚠️ 주의: FeatureFlags.aiOnline이 true일 때만 사용 가능합니다.
class AiService {
  final http.Client _client;
  final Duration _timeout;

  AiService({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? Duration(milliseconds: ApiConfig.timeoutMs);

  /// AI 서비스 사용 가능 여부 확인
  bool get isAvailable => FeatureFlags.aiOnline && ApiConfig.isConfigured;

  /// 사주 AI 요약 요청
  Future<AiReadingResult> getSajuSummary({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    int? birthHour,
    String? gender,
  }) async {
    _checkAvailability();

    final response = await _postJson(ApiConfig.sajuSummaryUrl, {
      'birthYear': birthYear,
      'birthMonth': birthMonth,
      'birthDay': birthDay,
      if (birthHour != null) 'birthHour': birthHour,
      if (gender != null) 'gender': gender,
    });

    return AiReadingResult.fromJson(response);
  }

  /// 타로 AI 해석 요청
  Future<AiReadingResult> getTarotReading({
    required List<String> cards,
    String? question,
    String? spreadType,
  }) async {
    _checkAvailability();

    final response = await _postJson(ApiConfig.tarotReadingUrl, {
      'cards': cards,
      if (question != null) 'question': question,
      if (spreadType != null) 'spreadType': spreadType,
    });

    return AiReadingResult.fromJson(response);
  }

  /// 꿈 AI 해석 요청
  Future<AiReadingResult> getDreamMeaning({
    required String dreamDescription,
    List<String>? keywords,
  }) async {
    _checkAvailability();

    final response = await _postJson(ApiConfig.dreamMeaningUrl, {
      'dreamDescription': dreamDescription,
      if (keywords != null) 'keywords': keywords,
    });

    return AiReadingResult.fromJson(response);
  }

  /// 관상 AI 분석 요청 (이미지 없이 특징 수치만)
  Future<AiReadingResult> getFaceReading({
    required Map<String, dynamic> features,
  }) async {
    _checkAvailability();

    final response = await _postJson(ApiConfig.faceReadingUrl, {
      'features': features,
    });

    return AiReadingResult.fromJson(response);
  }

  // ========================================
  // 내부 헬퍼
  // ========================================

  void _checkAvailability() {
    if (!FeatureFlags.aiOnline) {
      throw AiServiceException('AI 기능이 비활성화되어 있습니다');
    }
    if (!ApiConfig.isConfigured) {
      throw AiServiceException('API_BASE_URL이 설정되지 않았습니다');
    }
  }

  Future<Map<String, dynamic>> _postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw AiServiceException('API 요청 실패', statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw AiServiceException('요청 시간이 초과되었습니다');
    } on http.ClientException catch (e) {
      throw AiServiceException('네트워크 오류: ${e.message}');
    }
  }

  /// 리소스 정리
  void dispose() {
    _client.close();
  }
}

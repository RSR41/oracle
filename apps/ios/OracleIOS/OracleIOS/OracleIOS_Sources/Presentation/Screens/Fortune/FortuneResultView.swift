import SwiftUI

/// 사주 결과 화면
/// Android: ui/screens/ResultScreen.kt (lines 33-220)
struct FortuneResultView: View {
    let result: FortuneResult
    let birthInfo: BirthInfo
    var onSave: () -> Void
    var onBack: () -> Void
    
    @State private var isSaved = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 오늘의 총운 (Hero)
                    OracleCard(backgroundColor: Color.oracleBrown.opacity(0.05)) {
                        OracleSectionTitle(
                            text: String(localized: "result.summary.title"),
                            color: .oracleBrown
                        )
                        
                        Text(result.interpretation)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    
                    // 사주 기둥 (Pillars)
                    OracleCard {
                        OracleSectionTitle(text: String(localized: "result.pillars.title"))
                        
                        Text(result.pillars.fullDisplay)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.oracleTerracotta)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.oracleTerracotta.opacity(0.05))
                            .cornerRadius(12)
                    }
                    
                    // 행운 아이템 (Lucky)
                    HStack(spacing: 12) {
                        // 행운 색상
                        OracleCard {
                            VStack {
                                Text(String(localized: "result.luckyColor"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if let colorHex = result.luckyColors.first {
                                    Circle()
                                        .fill(Color(hex: colorHex))
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // 행운 숫자
                        OracleCard {
                            VStack {
                                Text(String(localized: "result.luckyNumber"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if let number = result.luckyNumbers.first {
                                    Text("\(number)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oracleBrown)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // 입력 정보 요약
                    OracleCard {
                        OracleSectionTitle(text: String(localized: "result.inputSummary"))
                        
                        VStack(spacing: 8) {
                            ResultDetailRow(
                                label: String(localized: "profile.birthDate"),
                                value: birthInfo.date
                            )
                            ResultDetailRow(
                                label: String(localized: "profile.birthTime"),
                                value: birthInfo.time.isEmpty ? String(localized: "common.notEntered") : birthInfo.time
                            )
                            ResultDetailRow(
                                label: String(localized: "profile.gender"),
                                value: birthInfo.gender.displayName
                            )
                            ResultDetailRow(
                                label: String(localized: "profile.calendarType"),
                                value: birthInfo.calendarType.displayName
                            )
                            
                            Divider()
                            
                            Text(String(localized: "result.generatedAt \(result.generatedAt.formatted())"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 하단 버튼들
                    HStack(spacing: 16) {
                        OracleSecondaryButton(
                            text: String(localized: "result.retry"),
                            action: onBack
                        )
                        
                        OracleButton(
                            text: isSaved ? String(localized: "common.alreadySaved") : String(localized: "common.saveHistory"),
                            action: {
                                onSave()
                                isSaved = true
                            },
                            isEnabled: !isSaved
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .background(Color.oracleBeige)
            .navigationTitle(String(localized: "result.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

/// 결과 상세 행
private struct ResultDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

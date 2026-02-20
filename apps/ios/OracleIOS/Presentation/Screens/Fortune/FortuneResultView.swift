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
                    // 사주 기둥 (Pillars) - 그래픽
                    VStack(spacing: 8) {
                        OracleSectionTitle(text: L("result.pillars.title"))
                        FourPillarsView(pillars: result.pillars)
                    }
                    .padding(.horizontal)
                    
                    // 오행 분석 (Graph)
                    OracleCard {
                        OracleSectionTitle(text: L("result.global.title") ?? "오행 분석") // 키 없을 수 있음
                        
                        FiveElementsGraphView(elements: result.elements)
                            .padding(.bottom, 12)
                        
                        Divider()
                        
                        // 기존 텍스트 해석 표시
                        Text(result.interpretation)
                            .font(.body)
                            .lineSpacing(4)
                            .padding(.top, 8)
                    }
                    
                    // 행운 아이템 (Lucky)
                    HStack(spacing: 12) {
                        // 행운 색상
                        OracleCard {
                            VStack {
                                Text(L("result.luckyColor"))
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
                                Text(L("result.luckyNumber"))
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
                        OracleSectionTitle(text: L("result.inputSummary"))
                        
                        VStack(spacing: 8) {
                            ResultDetailRow(
                                label: L("profile.birthDate"),
                                value: birthInfo.date
                            )
                            ResultDetailRow(
                                label: L("profile.birthTime"),
                                value: birthInfo.time.isEmpty ? L("common.notEntered") : birthInfo.time
                            )
                            ResultDetailRow(
                                label: L("profile.gender"),
                                value: birthInfo.gender.displayName
                            )
                            ResultDetailRow(
                                label: L("profile.calendarType"),
                                value: birthInfo.calendarType.displayName
                            )
                            
                            Divider()
                            
                            Text(L("result.generatedAt %@", result.generatedAt.formatted(date: .numeric, time: .shortened)))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 하단 버튼들
                    HStack(spacing: 16) {
                        OracleSecondaryButton(
                            text: L("result.retry"),
                            action: onBack
                        )
                        
                        OracleButton(
                            text: isSaved ? L("common.alreadySaved") : L("common.saveHistory"),
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
            .navigationTitle(L("result.title"))
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

import SwiftUI

// MARK: - Oracle Button

/// 프라이머리 버튼
/// Android: ui/components/OracleButton
struct OracleButton: View {
    let text: String
    let action: () -> Void
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isEnabled ? Color.oracleBrown : Color.oracleBrownLight)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}

/// 세컨더리 버튼
struct OracleSecondaryButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.oracleBrown)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.oracleSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.oracleOutline, lineWidth: 1)
                )
                .cornerRadius(12)
        }
    }
}

// MARK: - Oracle Card

/// 카드 컨테이너
/// Android: ui/components/OracleCard
struct OracleCard<Content: View>: View {
    var backgroundColor: Color = .oracleSurface
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Section Title

/// 섹션 타이틀
struct OracleSectionTitle: View {
    let text: String
    var color: Color = .oracleBrown
    
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(color)
    }
}

// MARK: - Selectable Chip Row

/// 선택 가능한 칩 목록
/// Android: ui/components/SelectableChipRow
struct SelectableChipRow<T: Hashable>: View {
    let options: [T]
    @Binding var selected: T
    let labelProvider: (T) -> String
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Button {
                    selected = option
                } label: {
                    Text(labelProvider(option))
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selected == option ? Color.oracleBrown : Color.oracleSurface)
                        .foregroundColor(selected == option ? .white : .oracleBrown)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.oracleOutline, lineWidth: selected == option ? 0 : 1)
                        )
                }
            }
        }
    }
}

// MARK: - Top App Bar

/// 상단 앱 바
struct OracleTopAppBar: View {
    let title: String
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if let onBack = onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.oracleBrown)
                }
            }
            
            Spacer()
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.oracleBrown)
            
            Spacer()
            
            // 균형을 위한 투명 버튼
            if onBack != nil {
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.oracleBeige)
    }
}

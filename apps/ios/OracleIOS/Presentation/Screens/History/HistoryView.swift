import SwiftUI

/// 히스토리 화면
/// Android: ui/screens/HistoryScreen.kt
struct HistoryView: View {
    @ObservedObject var viewModel: FortuneViewModel
    var onBack: () -> Void
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.history.isEmpty {
                    // 빈 상태
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 64))
                            .foregroundColor(.oracleOutline)
                        
                        Text(String(localized: "history.empty"))
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 히스토리 목록
                    List(viewModel.history) { record in
                        HistoryRow(record: record)
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color.oracleBeige)
            .navigationTitle(String(localized: "common.history"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .task {
                await viewModel.loadHistory()
            }
        }
    }
}

/// 히스토리 행
private struct HistoryRow: View {
    let record: HistoryRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: record.type.icon)
                    .foregroundColor(.oracleBrown)
                
                Text(record.title)
                    .font(.headline)
                
                Spacer()
                
                Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(record.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}

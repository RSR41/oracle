import SwiftUI

/// Oracle 색상 팔레트
/// Android: ui/theme/Color.kt (lines 6-18)
extension Color {
    // MARK: - Oracle Custom Palette - Warm Beige/Gold Theme
    
    /// 배경용 베이지
    static let oracleBeige = Color(hex: "#FDFBF7")
    
    /// 카드 표면
    static let oracleSurface = Color(hex: "#F5F0E6")
    
    /// 골드 액센트
    static let oracleGold = Color(hex: "#D4AF37")
    
    /// 어두운 골드
    static let oracleGoldDim = Color(hex: "#C4A030")
    
    /// 다크 브라운 (Primary)
    static let oracleBrown = Color(hex: "#4A4036")
    
    /// 라이트 브라운
    static let oracleBrownLight = Color(hex: "#8D7B68")
    
    /// 에러
    static let oracleError = Color(hex: "#BA1A1A")
    
    /// 아웃라인
    static let oracleOutline = Color(hex: "#E0D8CC")
    
    /// 테라코타 (Secondary)
    static let oracleTerracotta = Color(hex: "#B8836B")
    
    /// 모래색
    static let oracleSand = Color(hex: "#E8DDD4")
    
    /// 오프화이트 (Background)
    static let oracleOffWhite = Color(hex: "#FAF8F5")
    
    /// 카드 배경
    static let oracleCard = Color(hex: "#FFFFFF")
    
    /// 세컨더리 배경 (약간 어두운 베이지)
    static let oracleSecondaryBackground = Color(hex: "#F5EDE0")
    
    // MARK: - Hex Initializer
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

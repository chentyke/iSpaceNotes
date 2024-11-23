import SwiftUI

struct AttendancePage: View {
    @State private var dates: [String] = []
    @State private var isSignedIn = false
    @State private var statusMessage = ""
    
    var today = DateFormatter.shortDate.string(from: Date())
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部课程信息卡片
            VStack(spacing: 12) {
                Text("Consumer Behavior")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(DateFormatter.fullDate.string(from: Date()))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
            )
            .padding(.horizontal)
            
            // 最近签到记录
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Attendance")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.top, 24)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(dates.suffix(5), id: \.self) { date in
                            AttendanceCard(
                                date: date,
                                isToday: date == today,
                                status: date == today ? (isSignedIn ? .signedIn : .pending) : .signedIn
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // 签到状态和按钮
            VStack(spacing: 24) {
                // 当前时间
                HStack {
                    Image(systemName: "clock")
                        .font(.title2)
                    Text("Current time: \(DateFormatter.currentTime.string(from: Date()))")
                        .font(.system(size: 18, weight: .medium))
                }
                .foregroundColor(.secondary)
                
                // 签到按钮
                Button(action: {
                    withAnimation(.spring()) {
                        isSignedIn = true
                        statusMessage = "Already signed in, fifteen minutes late"
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isSignedIn ? "checkmark.circle.fill" : "location.circle.fill")
                            .font(.title2)
                        Text(isSignedIn ? "Signed in" : "Sign in")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isSignedIn ? Color.green : Color.blue)
                    )
                    .foregroundColor(.white)
                }
                .disabled(isSignedIn)
                
                if isSignedIn {
                    Text(statusMessage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: -5)
            )
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            generateRecentDates()
        }
    }
    
    // 生成最近5天的日期
    private func generateRecentDates() {
        let calendar = Calendar.current
        let today = Date()
        dates = (0..<5).compactMap { index in
            if let date = calendar.date(byAdding: .day, value: -index, to: today) {
                return DateFormatter.shortDate.string(from: date)
            }
            return nil
        }.reversed()
    }
}

// 签到卡片状态
enum AttendanceStatus {
    case signedIn, pending, absent
    
    var color: Color {
        switch self {
        case .signedIn: return .green
        case .pending: return .blue
        case .absent: return .red
        }
    }
    
    var text: String {
        switch self {
        case .signedIn: return "Signed in"
        case .pending: return "Pending"
        case .absent: return "Absent"
        }
    }
}

// 签到卡片视图
struct AttendanceCard: View {
    let date: String
    let isToday: Bool
    let status: AttendanceStatus
    
    var body: some View {
        VStack(spacing: 12) {
            Text(date)
                .font(.system(size: 18, weight: .semibold))
            
            Circle()
                .fill(status.color)
                .frame(width: 12, height: 12)
            
            Text(status.text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(width: 100, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isToday ? status.color : Color.clear, lineWidth: 2)
        )
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let currentTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
#Preview {
    AttendancePage()
}

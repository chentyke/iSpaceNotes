import SwiftUI

struct MembershipPage: View {
    @State private var showPaymentSheet = false
    @State private var selectedPlan: MembershipPlan?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // 顶部横幅
                HeaderBanner()
                    .ignoresSafeArea()
                    .padding(.top, horizontalSizeClass == .compact ? 60 : 0)
                
                // 会员计划选择
                VStack(spacing: 24) {
                    Text("Choose Your Plan")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 20) {
                        PlanCard(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly,
                            action: { selectedPlan = .monthly }
                        )
                        
                        PlanCard(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly,
                            action: { selectedPlan = .yearly }
                        )
                    }
                    .padding(.horizontal)
                    
                    // 订阅按钮
                    Button(action: {
                        showPaymentSheet = true
                    }) {
                        Text("Subscribe Now")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .disabled(selectedPlan == nil)
                    .opacity(selectedPlan == nil ? 0.6 : 1)
                }
                
                // 功能列表
                VStack(spacing: 32) {
                    Text("Premium Features")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    FeatureGrid()
                    
                    // 详细功能列表
                    VStack(spacing: 24) {
                        FeatureSection(
                            icon: "dollarsign.circle.fill",
                            title: "Simple Pricing, Easy Profit",
                            details: [
                                "Free software and iPad for schools",
                                "Affordable monthly subscription for students",
                                "Comprehensive learning tools"
                            ]
                        )
                        
                        FeatureSection(
                            icon: "brain.head.profile",
                            title: "AI-Powered Learning",
                            details: [
                                "Smart content analysis",
                                "Personalized learning assistance",
                                "Automated quiz generation"
                            ]
                        )
                        
                        FeatureSection(
                            icon: "arrow.triangle.2.circlepath.circle.fill",
                            title: "Real-Time Sync",
                            details: [
                                "Cross-device synchronization",
                                "Live classroom interaction",
                                "Instant progress tracking"
                            ]
                        )
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.all, edges: .top)
        .sheet(isPresented: $showPaymentSheet) {
            PaymentSheet()
        }
    }
}

// 顶部横幅
struct HeaderBanner: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                Text("Upgrade to Premium")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Unlock all features and enhance your learning experience")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, horizontalSizeClass == .compact ? 30 : 40)
        }
    }
}

// 会员计划卡片
struct PlanCard: View {
    let plan: MembershipPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Text(plan.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(plan.price)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(isSelected ? .white : .blue)
                
                if plan.hasDiscount {
                    Text("Save 17%")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? .white : .green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(isSelected ? .white.opacity(0.2) : .green.opacity(0.1))
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.05),
                   radius: isSelected ? 10 : 5)
        }
    }
}

// 功能网格
struct FeatureGrid: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            FeatureItem(icon: "wand.and.stars", title: "AI Assistant")
            FeatureItem(icon: "icloud.and.arrow.up", title: "Cloud Sync")
            FeatureItem(icon: "chart.bar.fill", title: "Analytics")
            FeatureItem(icon: "person.2.fill", title: "Collaboration")
        }
        .padding(.horizontal)
    }
}

// 功能项
struct FeatureItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// 功能详情部分
struct FeatureSection: View {
    let icon: String
    let title: String
    let details: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题行
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer() // 确保标题行占满宽度
            }
            
            // 详情列表
            VStack(alignment: .leading, spacing: 12) {
                ForEach(details, id: \.self) { detail in
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                            .frame(width: 20) // 固定图标宽度
                        
                        Text(detail)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        Spacer() // 确保文本行占满宽度
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 支付表单
struct PaymentSheet: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Payment Method")
                .font(.system(size: 24, weight: .bold))
            
            PaymentMethodButton(
                icon: "wechat",
                title: "WeChat Pay",
                color: .green
            )
            
            PaymentMethodButton(
                icon: "alipay",
                title: "Alipay",
                color: .blue
            )
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .presentationDetents([.medium])
    }
}

struct PaymentMethodButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(icon) // 需要添加相应的支付方式图标
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
        .foregroundColor(color)
    }
}

// 会员计划枚举
enum MembershipPlan {
    case monthly, yearly
    
    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .monthly: return "¥15/mo"
        case .yearly: return "¥150/yr"
        }
    }
    
    var hasDiscount: Bool {
        switch self {
        case .monthly: return false
        case .yearly: return true
        }
    }
}



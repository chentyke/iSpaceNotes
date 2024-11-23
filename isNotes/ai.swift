import SwiftUI
struct AIPage: View {
    @State private var message: String = "What is the Process of Problem Recognition."
    @State private var messages: [String] = []
    @State private var typingMessage: String = ""
    @State private var isTyping: Bool = false

    var body: some View {
        ZStack {
            // 添加渐变背景
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), 
                          startPoint: .topLeading, 
                          endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 优化标题栏
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                    Text("AI Assistant")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: { /* 添加清空聊天功能 */ }) {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .shadow(radius: 2)
                
                // 优化消息列表
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(messages, id: \.self) { msg in
                                MessageBubble(message: msg, isUser: !(msg == defaultReply || msg == "Absolutely Wang Peng!"))
                            }
                            
                            if isTyping {
                                MessageBubble(message: typingMessage, isUser: false)
                                    .opacity(0.7)
                            }
                        }
                        .padding()
                        .onChange(of: messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(messages.last, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 优化输入区域
                HStack(spacing: 12) {
                    TextField("Type your message...", text: $message)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(radius: 2)
                    
                    Button(action: {
                        if !message.isEmpty {
                            messages.append(message)
                            startTypingEffect()
                            message = ""
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
            }
        }
    }
    
    // 打字效果逻辑
    // 打字效果逻辑
    // 打字效果逻辑
    private func startTypingEffect() {
        isTyping = true
        typingMessage = ""
        
        // 动态选择回复内容
        let reply: String
        if messages.last?.localizedCaseInsensitiveContains("handsome") == true {
            reply = "Absolutely Wang Peng!"
        } else {
            reply = defaultReply
        }
        
        // 打字效果逐字显示
        let characters = Array(reply)
        var currentIndex = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if currentIndex < characters.count {
                typingMessage.append(characters[currentIndex])
                currentIndex += 1
            } else {
                timer.invalidate()
                isTyping = false
                messages.append(reply) // 完成后将完整回复添加到消息列表
            }
        }
    }
    // 定义默认回复内容
    private let defaultReply: String = """
1. Desired Consumer Lifestyle:
    • Refers to the way consumers would like to live and feel.
2. Current Situation:
    • Describes the temporary factors affecting the consumer’s current state.
3. Desired State vs. Actual State:
    • Desired State: The condition the consumer wishes to be in at the moment.
    • Actual State: The condition the consumer perceives themselves to be in at the moment.
4. Nature of Discrepancy:
    • Represents the difference between the consumer’s desired and actual states.
5. Outcome of Discrepancy:
    • No Difference: The consumer feels satisfied, and no action is taken.
    • Desired State Exceeds Actual State: A problem is recognized, initiating a search for a solution.
    • Actual State Exceeds Desired State: A problem is also recognized.

Summary: This process illustrates how problem recognition arises from a comparison between a consumer’s desired and actual states, with any discrepancy prompting the consumer to take action.
"""
}

// 添加消息气泡组件
struct MessageBubble: View {
    let message: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isUser ? Color.blue : Color.white)
                .foregroundColor(isUser ? .white : .black)
                .cornerRadius(20)
                .shadow(radius: 1)
            
            if !isUser { Spacer() }
        }
    }
}


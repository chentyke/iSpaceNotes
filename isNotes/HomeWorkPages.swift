import SwiftUI

struct SubmitPage: View {
    var assignment: String
    var namespace: Namespace.ID
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFile: URL?
    @State private var uploadProgress: CGFloat = 0
    @State private var isUploading = false
    @State private var showFileImporter = false
    @State private var showSuccessAlert = false
    @State private var currentStep = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 顶部标题区域
                HeaderSection(assignment: assignment, namespace: namespace)
                
                // 进度指示器
                ProgressSteps(currentStep: currentStep)
                    .padding(.horizontal)
                
                // 作业要求卡片
                RequirementsCard()
                
                // 文件上传区域
                UploadSection(
                    selectedFile: $selectedFile,
                    isUploading: $isUploading,
                    uploadProgress: $uploadProgress,
                    showFileImporter: $showFileImporter
                )
                
                // 提交按钮
                SubmitButton(
                    selectedFile: selectedFile,
                    isUploading: $isUploading,
                    uploadProgress: $uploadProgress,
                    showSuccessAlert: $showSuccessAlert
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf, .text, .plainText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your assignment has been submitted successfully!")
        }
    }
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        do {
            guard let selectedFile = try result.get().first else { return }
            self.selectedFile = selectedFile
            withAnimation {
                currentStep = 2
            }
        } catch {
            print("File selection failed: \(error.localizedDescription)")
        }
    }
}

// 顶部标题区域
struct HeaderSection: View {
    let assignment: String
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 16) {
            Text(assignment)
                .font(.system(size: 28, weight: .bold))
                .matchedGeometryEffect(id: assignment, in: namespace)
            
            Text("Due: \(Date().addingTimeInterval(7*24*3600).formatted(date: .long, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// 进度步骤指示器
struct ProgressSteps: View {
    let currentStep: Int
    
    var body: some View {
        HStack {
            ProgressStep(number: 1, title: "Upload", isActive: currentStep >= 1)
            ProgressLine()
            ProgressStep(number: 2, title: "Review", isActive: currentStep >= 2)
            ProgressLine()
            ProgressStep(number: 3, title: "Submit", isActive: currentStep >= 3)
        }
    }
}

struct ProgressStep: View {
    let number: Int
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 30, height: 30)
                
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isActive ? .white : .gray)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(isActive ? .primary : .secondary)
        }
    }
}

struct ProgressLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

// 作业要求卡片
struct RequirementsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Assignment Requirements")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                RequirementItem(
                    icon: "1.circle.fill",
                    text: "Form a group of 5 students"
                )
                
                RequirementItem(
                    icon: "2.circle.fill",
                    text: "Select a brand from any industry"
                )
                
                RequirementItem(
                    icon: "3.circle.fill",
                    text: "Identify market expansion problems"
                )
                
                RequirementItem(
                    icon: "4.circle.fill",
                    text: "Design a new product and marketing plan"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct RequirementItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// 文件上传区域
struct UploadSection: View {
    @Binding var selectedFile: URL?
    @Binding var isUploading: Bool
    @Binding var uploadProgress: CGFloat
    @Binding var showFileImporter: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if let file = selectedFile {
                // 显示已选择的文件
                FilePreview(fileName: file.lastPathComponent)
            } else {
                // 文件选择区域
                UploadArea(showFileImporter: $showFileImporter)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct FilePreview: View {
    let fileName: String
    
    var body: some View {
        HStack {
            Image(systemName: "doc.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(fileName)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("Ready to submit")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct UploadArea: View {
    @Binding var showFileImporter: Bool
    
    var body: some View {
        Button(action: {
            showFileImporter = true
        }) {
            VStack(spacing: 12) {
                Image(systemName: "arrow.up.doc")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text("Tap to upload your file")
                    .font(.subheadline)
                
                Text("PDF, Word, or Text files")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(.blue.opacity(0.3))
            )
        }
    }
}

// 提交按钮
struct SubmitButton: View {
    let selectedFile: URL?
    @Binding var isUploading: Bool
    @Binding var uploadProgress: CGFloat
    @Binding var showSuccessAlert: Bool
    
    var body: some View {
        Button(action: submitAssignment) {
            HStack {
                if isUploading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 8)
                }
                
                Text(isUploading ? "Uploading..." : "Submit Assignment")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedFile == nil ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(selectedFile == nil || isUploading)
    }
    
    private func submitAssignment() {
        guard !isUploading else { return }
        
        isUploading = true
        uploadProgress = 0
        
        // 模拟上传过程
        withAnimation(.easeInOut(duration: 2)) {
            uploadProgress = 1
        }
        
        // 延迟显示成功提示
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isUploading = false
            showSuccessAlert = true
        }
    }
}

struct HomeworkPage: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let assignments = (1...10).map { "Assignment \($0)" }
    let colors: [Color] = [.mint, .cyan, .blue, .orange, .purple, .pink, .yellow, .teal, .indigo, .brown]
    let dates: [Date] = (0...9).map { Calendar.current.date(byAdding: .day, value: $0, to: Date())! }
    
    @State private var currentIndex = 0
    @Namespace private var namespace
    @State private var showSubmitPage = false
    @State private var selectedAssignment: String?
    @State private var cardScale: CGFloat = 1
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景渐变
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGroupedBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 顶部标题区域
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Assignments")
                                .font(.system(size: 34, weight: .bold))
                            
                            Text("Due this week")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, horizontalSizeClass == .compact ? 60 : 2)
                    
                    // 作业卡片区域
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(assignments.indices, id: \.self) { index in
                                AssignmentCard(
                                    assignment: assignments[index],
                                    color: colors[index % colors.count],
                                    dueDate: dates[index],
                                    namespace: namespace,
                                    width: geometry.size.width * 0.85,
                                    offset: calculateOffset(for: index, in: geometry.size.width),
                                    scale: calculateScale(for: index),
                                    onTap: {
                                        if index == currentIndex {
                                            selectedAssignment = assignments[index]
                                            showSubmitPage = true
                                        } else {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                currentIndex = index
                                            }
                                        }
                                    }
                                )
                                .zIndex(Double(assignments.count - abs(currentIndex - index)))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.top, 12)
                    
                    // 底部快速切换
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(assignments.indices, id: \.self) { index in
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        currentIndex = index
                                    }
                                }) {
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(currentIndex == index ? colors[index % colors.count] : Color.gray.opacity(0.3))
                                            .frame(width: currentIndex == index ? 10 : 8, height: currentIndex == index ? 10 : 8)
                                        
                                        Text(assignments[index])
                                            .font(.caption)
                                            .foregroundColor(currentIndex == index ? .primary : .secondary)
                                    }
                                }
                                .scaleEffect(currentIndex == index ? 1.2 : 1)
                                .animation(.spring(response: 0.3), value: currentIndex)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationDestination(isPresented: $showSubmitPage) {
                if let assignment = selectedAssignment {
                    SubmitPage(assignment: assignment, namespace: namespace)
                }
            }
            .navigationBarHidden(true)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    handleSwipe(value)
                }
        )
    }
    
    private func handleSwipe(_ value: DragGesture.Value) {
        let threshold: CGFloat = 50
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if value.translation.width < -threshold && currentIndex < assignments.count - 1 {
                currentIndex += 1
            } else if value.translation.width > threshold && currentIndex > 0 {
                currentIndex -= 1
            }
        }
    }
    
    private func calculateOffset(for index: Int, in width: CGFloat) -> CGFloat {
        guard !isAnimating else { return 0 }
        let baseOffset = CGFloat(index - currentIndex) * width * 0.15
        let maxOffset: CGFloat = 200
        return min(max(baseOffset, -maxOffset), maxOffset)
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        let difference = abs(index - currentIndex)
        return 1 - CGFloat(difference) * 0.05
    }
}

struct AssignmentCard: View {
    let assignment: String
    let color: Color
    let dueDate: Date
    let namespace: Namespace.ID
    let width: CGFloat
    let offset: CGFloat
    let scale: CGFloat
    let onTap: () -> Void
    
    @State private var isShowingDetails = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 20) {
                // 作业标题
                Text(assignment)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .matchedGeometryEffect(id: assignment, in: namespace)
                
                // 截止日期
                HStack {
                    Image(systemName: "calendar")
                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                // 进度指示器
                ProgressView(value: 0.3)
                    .tint(.white)
                    .padding(.horizontal)
                
                Text("30% Completed")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                
                // 查看详情按钮
                if scale == 1 {
                    HStack {
                        Text("View Details")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            .padding(24)
            .frame(width: width)
            .frame(maxHeight: 400)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 10)
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: offset)
        .scaleEffect(scale)
    }
}

struct HomeworkPage_Previews: PreviewProvider {
    static var previews: some View {
        HomeworkPage()
    }
}

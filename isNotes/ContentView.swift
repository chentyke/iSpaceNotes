import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // iPad 布局
            NavigationView {
                VStack {
                    // 左侧 Tab 菜单
                    List {
                        TabItem(label: "Home", systemImage: "house.fill", index: 0, selectedTab: $selectedTab)
                        TabItem(label: "Notes", systemImage: "note.text", index: 1, selectedTab: $selectedTab)
                        TabItem(label: "Attendance", systemImage: "checkmark.circle", index: 2, selectedTab: $selectedTab)
                        TabItem(label: "AI", systemImage: "brain", index: 3, selectedTab: $selectedTab)
                        TabItem(label: "Class Recordings", systemImage: "film.fill", index: 7, selectedTab: $selectedTab)
                        TabItem(label: "Homework", systemImage: "book.fill", index: 6, selectedTab: $selectedTab)
                        TabItem(label: "File Management", systemImage: "folder.fill", index: 5, selectedTab: $selectedTab)
                        TabItem(label: "Upgrade Membership", systemImage: "star.fill", index: 4, selectedTab: $selectedTab)
                    }
                    .listStyle(SidebarListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("iSpaceNotes")
                    
                    // Bottom "Log in" Button
                    Button(action: {
                        print("Log in button clicked")
                    }) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                            Text("Tyke")
                                .font(.headline)
                        }
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                }
                
                // Right-side Page Content
                Group {
                    switch selectedTab {
                    case 0: MainPage(selectedTab: $selectedTab)
                    case 1: NotesPage()
                    case 2: AttendancePage()
                    case 3: AIPage()
                    case 4: MembershipPage()
                    case 5: FileManagementPage()
                    case 6: HomeworkPage()
                    case 7: ClassRecordingPage()
                    default: MainPage(selectedTab: $selectedTab)
                    }
                }
            }
        } else {
            // iPhone 布局
            TabView(selection: $selectedTab) {
                MainPage(selectedTab: $selectedTab, isPhone: true)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                AttendancePage()
                    .tabItem {
                        Image(systemName: "checkmark.circle")
                        Text("Attendance")
                    }
                    .tag(2)
                
                AIPage()
                    .tabItem {
                        Image(systemName: "brain")
                        Text("AI")
                    }
                    .tag(3)
                
                HomeworkPage()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Homework")
                    }
                    .tag(6)
                
                MoreMenu(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text("More")
                    }
                    .tag(8)
            }
        }
    }
}

// 添加更多菜单视图
struct MoreMenu: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ClassRecordingPage()) {
                    Label("Class Recordings", systemImage: "film.fill")
                }
                
                NavigationLink(destination: FileManagementPage()) {
                    Label("File Management", systemImage: "folder.fill")
                }
                
                NavigationLink(destination: MembershipPage()) {
                    Label("Upgrade Membership", systemImage: "star.fill")
                }
                
                // 用户信息部分
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                        Text("Tyke")
                            .font(.headline)
                        Spacer()
                        Text("Log out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}

// Tab Item Custom Component
struct TabItem: View {
    let label: String
    let systemImage: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == index ? .white : .gray)
                    .frame(width: 24, height: 24)
                
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedTab == index ? .white : .gray)
                
                Spacer()
                
                if selectedTab == index {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        selectedTab == index ?
                        LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                     startPoint: .leading,
                                     endPoint: .trailing) :
                        LinearGradient(gradient: Gradient(colors: [.clear, .clear]),
                                     startPoint: .leading,
                                     endPoint: .trailing)
                    )
            )
            .padding(.horizontal, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
//课堂回放
struct ClassRecordingPage: View {
    private var videos = [
        Video(title: "CH1", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH2", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH3", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH4", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH5", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH6", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH7", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH8", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH9", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH10", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH11", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH12", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH13", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH14", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH15", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH16", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH17", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH18", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH19", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH20", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH21", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH22", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH23", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH24", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH25", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH26", description: "Dr. Peng WANG", thumbnailImageName: "WP"),
        Video(title: "CH27", description: "Dr. Peng WANG", thumbnailImageName: "WP")
    ]
    var body: some View {
        GeometryReader { geometry in
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadLayout(geometry: geometry)
            } else {
                iPhoneLayout()
            }
        }
        .background(Color.gray.opacity(0.1))
    }
    @ViewBuilder
    private func iPadLayout(geometry: GeometryProxy) -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 20) {
                ForEach(videos, id: \.id) { video in
                    VideoItem(video: video)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: geometry.size.width - 40) // Adjust padding as needed
        }
    }
    @ViewBuilder
    private func iPhoneLayout() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(videos, id: \.id) { video in
                    VideoItem(video: video)
                        .padding([.horizontal, .bottom])
                }
            }
        }
    }
}

struct VideoItem: View {
    var video: Video
    
    var body: some View {
        NavigationLink(destination: VideoPlayerView(video: video)) {
            HStack(spacing: 15) {
                Image("WP")  // 使用图片名称"WP"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(video.title)
                        .font(.headline)
                    Text(video.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}
import AVKit
struct VideoPlayerView: View {
    var video: Video
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    var body: some View {
        VStack {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .frame(height: 1000)
            } else {
                Text("无法加载视频")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(video.title)
        .onAppear {
            viewModel.setupPlayer(for: video)
        }
        .onDisappear {
            viewModel.pausePlayer()
        }
    }
}

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    
    func setupPlayer(for video: Video) {
        // 注意：确保在项目中添加了对应的视频文件
        guard let videoURL = Bundle.main.url(forResource: "CH1", withExtension: "mp4") else {
            print("视频文件未找到: \(video.title).mp4")
            return
        }
        
        player = AVPlayer(url: videoURL)
        player?.play()
    }
    
    func pausePlayer() {
        player?.pause()
    }
}

struct Video: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var thumbnailImageName: String
}
// 主页面
struct MainPage: View {
    @State private var currentTime = Date()
    @State private var showHandRaised = false
    @Binding var selectedTab: Int
    var isPhone: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // 顶部欢迎区域
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back,Tyke Chen")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        Text("Consumer Behavior")
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                // 实时状态卡片
                HStack(spacing: 20) {
                    // 时间卡片
                    StatusCard(
                        icon: "clock.fill",
                        title: "Current Time",
                        value: currentTime.formatted(date: .omitted, time: .shortened),
                        color: .blue
                    )
                    
                    // 笔记数量卡片
                    StatusCard(
                        icon: "note.text",
                        title: "Notes",
                        value: "135",
                        color: .green
                    )
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    // 当前教室卡片
                    StatusCard(
                        icon: "building.2.fill",
                        title: "Current Room",
                        value: "T29-604",
                        color: .orange
                    )
                    
                    // 下一个教室卡片
                    StatusCard(
                        icon: "arrow.right.circle.fill",
                        title: "Next Room",
                        value: "T7-501",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // 快速操作区域
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            if !isPhone {
                                QuickActionButton(
                                    icon: "pencil.circle.fill",
                                    title: "Take Notes",
                                    color: .blue
                                ) {
                                    selectedTab = 1
                                }
                            }
                            
                            QuickActionButton(
                                icon: "hand.raised.fill",
                                title: "Raise Hand",
                                color: .orange
                            ) {
                                withAnimation {
                                    showHandRaised.toggle()
                                }
                            }
                            
                            QuickActionButton(
                                icon: "clock.badge.checkmark.fill",
                                title: "Check In",
                                color: .pink
                            ) {
                                selectedTab = 2
                            }
                            
                            QuickActionButton(
                                icon: "video.fill",
                                title: "Recordings",
                                color: .red
                            ) {
                                selectedTab = 7
                            }
                            
                            QuickActionButton(
                                icon: "doc.text.fill",
                                title: "Homework",
                                color: .indigo
                            ) {
                                selectedTab = 6
                            }
                            
                            QuickActionButton(
                                icon: "chart.bar.fill",
                                title: "Analytics",
                                color: .teal
                            ) {
                                // 显示学习分析数据
                                print("Showing analytics...")
                            }
                            
                            QuickActionButton(
                                icon: "calendar",
                                title: "Schedule",
                                color: .brown
                            ) {
                                // 显示课程表
                                print("Opening schedule...")
                            }
                            
                            QuickActionButton(
                                icon: "bookmark.fill",
                                title: "Bookmarks",
                                color: .cyan
                            ) {
                                // 显示书签
                                print("Opening bookmarks...")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 课程进度卡片
                VStack(alignment: .leading, spacing: 16) {
                    CourseProgressCard()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .overlay(
            // 举手动画效果
            Group {
                if showHandRaised {
                    HandRaisedOverlay {
                        showHandRaised = false
                    }
                }
            }
        )
    }
}

// 状态卡片组件
struct StatusCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// 快速操作按钮组件
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
}

// 课程进度卡片组件
struct CourseProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Course Progress")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Current Chapter")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Chapter 7")
                        .fontWeight(.medium)
                }
                
                ProgressBar(progress: 0.65)
                
                HStack {
                    Text("65% Completed")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("35% Remaining")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// 进度条组件
struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.6)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

// 跳转到笔记页面的逻辑
private func navigateToNotesPage() {
    print("跳转到笔记页面") // 替换为实际的跳转逻辑
}

// 课堂签到页面

// AI页面

// 升级会员页面

// HomeWork

// 文件管理
struct FileManagementPage: View {
    let folders = [
        "Financial Management",
        "Consumer Behavior",
        "EAP",
        "Python",
        "Principal of Law"
    ]
    
    @State private var selectedFolder: String? = nil
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部搜索栏和上传按钮
            HStack(spacing: 16) {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search files...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 上传按钮
                Button(action: {
                    print("Upload File")
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.doc.fill")
                        Text("Upload")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            
            if let folder = selectedFolder {
                FolderContentView(folderName: folder) {
                    selectedFolder = nil
                }
            } else {
                // 文件夹网格视图
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 160), spacing: 20)
                    ], spacing: 20) {
                        ForEach(folders, id: \.self) { folder in
                            FolderCard(name: folder)
                                .onTapGesture {
                                    selectedFolder = folder
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// 文件夹卡片视图
struct FolderCard: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 16) {
            // 文件夹图标
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.8), .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "folder.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            // 文件夹名称
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            // 文件数量（模拟数据）
            Text("\(Int.random(in: 5...20)) files")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// 文件夹内容视图
struct FolderContentView: View {
    let folderName: String
    let backAction: () -> Void
    let documents = (1...10).map { "CH\($0)" }
    @State private var gridLayout = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部导航栏
            HStack {
                Button(action: backAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(folderName)
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button(action: {}) {
                        Label("Sort by Name", systemImage: "arrow.up.arrow.down")
                    }
                    Button(action: {}) {
                        Label("Sort by Date", systemImage: "calendar")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // 文档网格
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 20) {
                    ForEach(documents, id: \.self) { document in
                        DocumentCard(name: document)
                    }
                }
                .padding()
            }
        }
    }
}

// 文档卡片视图
struct DocumentCard: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 12) {
            // 文档图标
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 100)
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            // 文档信息
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("Modified \(Date().addingTimeInterval(-Double.random(in: 0...86400)).formatted(.relative(presentation: .named)))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
// 信息小组件
struct InfoBlock: View {
    let title: String
    let value: Any
    let formatter: DateFormatter?

    init(title: String, value: Any, formatter: DateFormatter? = nil) {
        self.title = title
        self.value = value
        self.formatter = formatter
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            if let formatter = formatter, let date = value as? Date {
                Text(formatter.string(from: date))
                    .font(.title2)
            } else {
                Text("\(value)")
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

extension DateFormatter {
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

// 添加举手动画效果视图
struct HandRaisedOverlay: View {
    let dismissAction: () -> Void
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text("Hand Raised!")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    Circle()
                        .fill(Color.orange)
                        .shadow(radius: 10)
                )
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.spring()) {
                        scale = 1.0
                    }
                    // 3秒后自动消失
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            dismissAction()
                        }
                    }
                }
                .padding(30)
            }
        }
        .background(Color.black.opacity(0.2))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            withAnimation {
                dismissAction()
            }
        }
    }
}

#Preview {
    ContentView()
}

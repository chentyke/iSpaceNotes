import SwiftUI
import PencilKit

struct NotesPage: View {
    @State private var canvasView = PKCanvasView() // Canvas view
    @State private var toolPicker = PKToolPicker() // Tool picker
    @State private var showQuestion = false // Control question modal

    var body: some View {
        ZStack {
            // Background image
            Image("note_image") // Replace with your image name
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Handwriting canvas
            CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                .background(Color.clear) // Transparent canvas background
            
            // Top-right "LIVE" icon
            VStack {
                HStack {
                    Spacer()
                    Text("LIVE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding()
                }
                Spacer()
            }
            
            // Right-side "Question" button in the center
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showQuestion = true
                    }) {
                        Text("Question")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    .padding()
                }
                Spacer()
            }

            // Bottom-right floating "Hand Raise" emoji button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("Hand Raise button tapped")
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 60, height: 60)
                            Text("✋")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                }
            }
        }
        .onDisappear {
            toolPicker.setVisible(false, forFirstResponder: canvasView) // Hide tool picker
        }
        .sheet(isPresented: $showQuestion) {
            QuestionView()
        }
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput // Allow both finger and Apple Pencil input
        canvasView.backgroundColor = .clear // Transparent background
        toolPicker.setVisible(true, forFirstResponder: canvasView) // Show tool picker
        toolPicker.addObserver(canvasView) // Enable tool picker on the canvas
        canvasView.becomeFirstResponder() // Activate the canvas
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // No additional logic needed for updates
    }
}

struct QuestionView: View {
    @State private var selectedOption: String? = nil
    @State private var isSubmitted = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Teacher is asking...")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Which option is correct?")
                .font(.headline)
                .padding(.horizontal)

            // Options
            ForEach(["A", "B", "C", "D"], id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Text("\(option)")
                            .font(.headline)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }

            // Submit button
            Button(action: {
                isSubmitted = true
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(selectedOption == nil ? Color.gray : Color.green)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .disabled(selectedOption == nil)

            if isSubmitted {
                Text("Answer submitted!")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}

import SwiftUI


struct ContentView: View {
    @State private var cameraMode = "front"
    @State private var capturedImage = UIImage(named: "TestImageAngry")
    @State private var finalPrediction: [String: Double] = ["Surprise": 0.01, "Disgust": 0.01, "Sad": 0.01, "Neutral": 0.01, "Fear": 0.01, "Angry": 0.93701171875, "Happy": 0.01]
    @State private var flashEnabled = false
    @State private var isFaceDetected = false
    @State private var selectedModel = "MobileNetV3TransferDataAugmentationBalanced"
    @State private var showCameraView = false
    
    var body: some View {
        VStack {
            if showCameraView {
                ZStack {
                    CameraView(
                        cameraMode: $cameraMode,
                        flashEnabled: $flashEnabled,
                        capturedImage: $capturedImage,
                        isFaceDetected: $isFaceDetected,
                        finalPrediction: $finalPrediction,
                        selectedModel: $selectedModel
                    ).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            CameraFlashButton(cameraMode: $cameraMode, flashEnabled: $flashEnabled)
                                .padding(.leading, 35)
                            Spacer()
                            CameraChangeButton(cameraMode: $cameraMode, flashEnabled: $flashEnabled)
                                .padding(.trailing, 35)
                        }
                        .padding(.top, 60)
                        Spacer()
                    }.edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        PredictionsListView(
                            selectedModel: $selectedModel,
                            finalPrediction: finalPrediction,
                            isFaceDetected: isFaceDetected
                        )
                    }.edgesIgnoringSafeArea(.all)
                }
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showCameraView = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

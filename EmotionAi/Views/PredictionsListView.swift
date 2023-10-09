import CoreML
import SwiftUI


struct PredictionsListView: View {
    @GestureState private var dragOffset = CGSize.zero
    @State private var viewHeight: CGFloat = 100.0
    @State private var showPredictions: Bool = false
    @State private var showModelPicker: Bool = false
    @Binding var selectedModel: String
    var finalPrediction: [String: Double]
    var isFaceDetected: Bool

    
    var body: some View {
        let dragGesture = DragGesture()
            .updating($dragOffset) { (value, state, _) in
                state = value.translation
            }
            .onEnded { value in
                if value.translation.height < 0 && !self.showPredictions && !self.showModelPicker{
                    self.viewHeight = 350
                    self.showPredictions = true
                } else if value.translation.height < 0 && self.showPredictions && !self.showModelPicker{
                    self.viewHeight = 580
                    self.showModelPicker = true
                } else if value.translation.height > 0 && self.showPredictions && self.showModelPicker{
                    self.viewHeight = 350
                    self.showModelPicker = false
                } else if value.translation.height > 0 && self.showPredictions && !self.showModelPicker{
                    self.viewHeight = 100
                    self.showPredictions = false
                }
            }
        
        let (key, _) = finalPrediction.max(by: { a, b in a.value < b.value })!
        
        return VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 10) {
                Text(isFaceDetected ? key : "No Face Detected")
                  .font(.title3)
                  .bold()
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white.opacity(0.8))
                  .frame(width: 228, alignment: .center)
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 390, height: 1)
                  .background(.white.opacity(0.3))
                  .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
            }
            .padding(.horizontal, 0)
            .padding(.top, 8)
            .padding(.bottom, 0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            if showPredictions {
                VStack(alignment: .center, spacing: 22) {
                    Prediction(emotion: "Angry", prediction: round(finalPrediction["Angry"]! * 100))
                    Prediction(emotion: "Disgust", prediction: round(finalPrediction["Disgust"]! * 100))
                    Prediction(emotion: "Fear", prediction: round(finalPrediction["Fear"]! * 100))
                    Prediction(emotion: "Happy", prediction: round(finalPrediction["Happy"]! * 100))
                    Prediction(emotion: "Neutral", prediction: round(finalPrediction["Neutral"]! * 100))
                    Prediction(emotion: "Sad", prediction: round(finalPrediction["Sad"]! * 100))
                    Prediction(emotion: "Surprise", prediction: round(finalPrediction["Surprise"]! * 100))
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if showModelPicker {
                ModelPicker(selectedModel: $selectedModel)
            }
        }
        .padding(0)
        .frame(width: 390, height: viewHeight, alignment: .top)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(45)
        .gesture(dragGesture)
        .animation(.easeIn)
    }
}

struct PredictionsListView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsListView(
            selectedModel: .constant("MobileNetV3TransferDataAugmentationBalanced"),
            finalPrediction: ["Surprise": 0.31, "Disgust": 0.21, "Sad": 0.11, "Neutral": 0.11, "Fear": 0.11, "Angry": 0.11, "Happy": 0.04],
            isFaceDetected: true
        )
    }
}

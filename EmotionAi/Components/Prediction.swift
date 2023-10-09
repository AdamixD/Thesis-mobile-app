import SwiftUI


struct Prediction: View {
    var emotion: String
    var prediction: Double
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(emotion)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 64, alignment: .leading)
            
            HStack(alignment: .center, spacing: 5) {
                ProgressBar(percentage: prediction)
            }
            
            Text(String(format: "%.f", prediction) + " %")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 50, alignment: .trailing)
        }
        .padding(0)
//        .preferredColorScheme(.dark)
    }
}

struct Prediction_Previews: PreviewProvider {
    static var previews: some View {
        Prediction(emotion: "Surprise", prediction: 69)
    }
}

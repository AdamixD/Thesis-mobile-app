import SwiftUI


struct ProgressBar: View {
    var percentage: Double
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.64, green: 0.05, blue: 0.53), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.26, green: 0.69, blue: 0.93), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: -0.02, y: 0.5),
                        endPoint: UnitPoint(x: 1.34, y: 0.5)
                    )
                )
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .cornerRadius(35)
        }
        .padding(.leading, 0)
        .padding(.trailing, 240 - (CGFloat(percentage)/100)*240)
        .padding(.vertical, 0)
        .frame(width: 240, alignment: .center)
        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.15))
        .cornerRadius(35)
//            .preferredColorScheme(.dark)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(percentage: 69)
    }
}

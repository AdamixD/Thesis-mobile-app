import SwiftUI


struct LoadingIndicator: View {
    @State private var rotation = Angle(degrees: 0)
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1.0)
            .stroke(Color(hue: 0.838, saturation: 0.0, brightness: 0.76), lineWidth: 8)
            .rotationEffect(rotation)
            .frame(width: 35, height: 35)
            .onAppear() {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = Angle(degrees: 360)
                }
            }.preferredColorScheme(.dark)
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}

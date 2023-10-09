import SwiftUI


struct WelcomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 0, green: 0.03, blue: 0.09), location: 0.05),
                Gradient.Stop(color: Color(red: 0, green: 0, blue: 0.05), location: 0.45),
                Gradient.Stop(color: Color(red: 0, green: 0, blue: 0.03), location: 0.97),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.98)
            ).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height / 20)
                
                Image("AppLogoImage")
                    .resizable()
                    .frame(width: 200, height: 200)

                Spacer().frame(height: UIScreen.main.bounds.height / 30)
                
                Text("EMOTIONAI")
                    .foregroundColor(Color(hue: 0.838, saturation: 0.0, brightness: 0.76))
                    .font(Font.custom("Roboto", size: 30)
                        .weight(.bold)
                    )
                    .kerning(4)
                    
                Spacer().frame(height: UIScreen.main.bounds.height / 7)
                
                LoadingIndicator()
            }
            .padding()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

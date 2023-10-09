import SwiftUI


struct CameraChangeButton: View {
    @Binding var cameraMode: String
    @Binding var flashEnabled: Bool
    
    var body: some View {
        Button(action: {
            cameraMode = (cameraMode == "front") ? "back" : "front"
            flashEnabled = (cameraMode == "front") ? false : flashEnabled
        }) {
            Image(systemName: "camera.rotate")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

struct CameraChangeButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraChangeButton(cameraMode: .constant("front"), flashEnabled: .constant(false))
    }
}

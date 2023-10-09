import SwiftUI


struct CameraFlashButton: View {
    @Binding var cameraMode: String
    @Binding var flashEnabled: Bool
    
    var body: some View {
        Button(action: {
            if cameraMode == "back" {
                flashEnabled.toggle()
            }
        }) {
            Image(systemName: flashEnabled ? "bolt.fill" : "bolt.slash.fill")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

struct CameraFlashButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraFlashButton(cameraMode: .constant("front"), flashEnabled: .constant(false))
    }
}

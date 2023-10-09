import SwiftUI


struct ModelPicker: View {
    @Binding var selectedModel: String
    
    let models = [
        "EfficientNetB0Base",
        "MobileNetBase",
        "MobileNetTransfer",
        "MobileNetTransferDataAugmentation",
        "MobileNetTransferDataAugmentationBalanced",
        "MobileNetV2Base",
        "MobileNetV2Transfer",
        "MobileNetV2TransferDataAugmentation",
        "MobileNetV2TransferDataAugmentationBalanced",
        "MobileNetV3Base",
        "MobileNetV3Transfer",
        "MobileNetV3TransferDataAugmentation",
        "MobileNetV3TransferDataAugmentationBalanced",
        "ResNet50Base",
    ]
    
    var body: some View {
        VStack {
            Picker("Model Selection", selection: $selectedModel) {
                ForEach(models, id: \.self) { model in
                    Text(model).tag(model)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)
            .clipped()
        }
    }
}

struct ModelPicker_Previews: PreviewProvider {
    static var previews: some View {
        ModelPicker(selectedModel: .constant("MobileNetV3TransferDataAugmentationBalanced"))
    }
}

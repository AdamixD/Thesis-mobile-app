import CoreML
import SwiftUI
import Vision


class ModelController: ObservableObject {
    @Published var classificationResults: [String: Double] = [:]
    var selectedModel: String = "MobileNetV3TransferDataAugmentationBalanced"
    
    func classify(image: UIImage?) {
        guard let image = image else {
            print("Invalid Image error")
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            print("UIImage to CIImage convertion error")
            return
        }
        
        do {
            let config = MLModelConfiguration()
            var visionModel: VNCoreMLModel
            
            switch self.selectedModel {
                case "EfficientNetB0Base":
                    let mlmodel = try EfficientNetB0Base(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("EfficientNetB0Base")
            
                case "MobileNetBase":
                    let mlmodel = try MobileNetBase(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetBase")
                    
                case "MobileNetTransfer":
                    let mlmodel = try MobileNetTransfer(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetTransfer")
                    
                case "MobileNetTransferDataAugmentation":
                    let mlmodel = try MobileNetTransferDataAugmentation(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetTransferDataAugmentation")
                    
                case "MobileNetTransferDataAugmentationBalanced":
                    let mlmodel = try MobileNetTransferDataAugmentationBalanced(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetTransferDataAugmentationBalanced")
                    
                case "MobileNetV2Base":
                    let mlmodel = try MobileNetV2Base(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV2Base")
                    
                case "MobileNetV2Transfer":
                    let mlmodel = try MobileNetV2Transfer(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV2Transfer")
                
                case "MobileNetV2TransferDataAugmentation":
                    let mlmodel = try MobileNetV2TransferDataAugmentation(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV2TransferDataAugmentation")
                    
                case "MobileNetV2TransferDataAugmentationBalanced":
                    let mlmodel = try MobileNetV2TransferDataAugmentationBalanced(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV2TransferDataAugmentationBalanced")
                    
                case "MobileNetV3Base":
                    let mlmodel = try MobileNetV3Base(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV3Base")
                    
                case "MobileNetV3Transfer":
                    let mlmodel = try MobileNetV3Transfer(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV3Transfer")
                
                case "MobileNetV3TransferDataAugmentation":
                    let mlmodel = try MobileNetV3TransferDataAugmentation(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV3TransferDataAugmentation")
                    
                case "MobileNetV3TransferDataAugmentationBalanced":
                    let mlmodel = try MobileNetV3TransferDataAugmentationBalanced(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV3TransferDataAugmentationBalanced")
                    
                case "ResNet50Base":
                    let mlmodel = try ResNet50Base(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("ResNet50Base")
                    
                default:
                    let mlmodel = try MobileNetV3TransferDataAugmentationBalanced(configuration: config)
                    visionModel = try VNCoreMLModel(for: mlmodel.model)
                    print("MobileNetV3TransferDataAugmentationBalanced")
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation] else {
                    print("Failed to get classification results")
                    return
                }
                var predictions: [String: Double] = [:]
                for result in results {
                    predictions[result.identifier] = Double(result.confidence)
                }
                DispatchQueue.main.async {
                    self?.classificationResults = predictions
                }
            }
            
            try handler.perform([request])
        } catch {
            print("Failed to perform classification: \(error)")
        }
    }
}

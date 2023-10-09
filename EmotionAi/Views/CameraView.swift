import AVFoundation
import Photos
import SwiftUI
import Vision


struct CameraView: UIViewRepresentable {
    @Binding var cameraMode: String
    @Binding var flashEnabled: Bool
    @Binding var capturedImage: UIImage?
    @Binding var isFaceDetected: Bool
    @Binding var finalPrediction: [String: Double]
    @Binding var selectedModel: String
    @StateObject private var modelController = ModelController()

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var captureSession: AVCaptureSession
        var currentBuffer: CVPixelBuffer?
        var parent: CameraView
        
        init(parent: CameraView, session: AVCaptureSession) {
            self.parent = parent
            self.captureSession = session
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            currentBuffer = pixelBuffer
        }
        
        func processCurrentFrame() {
            guard let pixelBuffer = currentBuffer else { return }
            
            let faceDetectionRequest = VNDetectFaceRectanglesRequest { request, error in
                guard error == nil else {
                    print("Face detection error: \(error!.localizedDescription)")
                    return
                }
                self.handleDetectedFaces(request)
            }
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try imageRequestHandler.perform([faceDetectionRequest])
            } catch {
                print("Image request error: \(error.localizedDescription)")
            }
        }
        
        func handleDetectedFaces(_ request: VNRequest) {
            guard let results = request.results as? [VNFaceObservation] else { return }
            parent.isFaceDetected = !results.isEmpty
            
            if let firstFace = results.first {
                processFace(firstFace.boundingBox)
            }
        }
        
        func processFace(_ faceRect: CGRect) {
            guard let pixelBuffer = currentBuffer else { return }
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
            let imageSize = ciImage.extent.size
            
            let faceUICoordinates = VNImageRectForNormalizedRect(faceRect, Int(imageSize.width), Int(imageSize.height))
            
            guard let croppedCGImage = context.createCGImage(ciImage, from: faceUICoordinates) else { return }
            let faceImage = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: .right)
            
            guard let resizedFaceImage = resizeImage(faceImage, to: CGSize(width: 224, height: 224)) else { return }
            
            DispatchQueue.main.async {
                self.parent.capturedImage = resizedFaceImage
                self.parent.modelController.selectedModel = self.parent.selectedModel
                self.parent.modelController.classify(image: self.parent.capturedImage)
    
                let prediction = self.parent.modelController.classificationResults
                let sortedPrediction = prediction.sorted(by: { $0.key < $1.key })
                if !sortedPrediction.isEmpty {
                    self.parent.finalPrediction = Dictionary(uniqueKeysWithValues: sortedPrediction)
                }
            }
        }
        
        private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, session: AVCaptureSession())
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = CameraUIView(coordinator: context.coordinator, cameraMode: cameraMode, flashEnabled: flashEnabled)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let cameraView = uiView as? CameraUIView {
            cameraView.cameraMode = cameraMode
            cameraView.flashEnabled = self.flashEnabled
            cameraView.setupCaptureSession()
        }
    }
}

class CameraUIView: UIView {
    var cameraMode: String
    var captureSession: AVCaptureSession
    var coordinator: CameraView.Coordinator?
    var flashEnabled: Bool
    var timer: Timer?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var previousCameraMode: String

    init(coordinator: CameraView.Coordinator, cameraMode: String, flashEnabled: Bool) {
        self.coordinator = coordinator
        self.captureSession = coordinator.captureSession
        self.cameraMode = cameraMode
        self.flashEnabled = flashEnabled
        self.previousCameraMode = "back"
        super.init(frame: .zero)
        self.setupCaptureSession()
        self.toggleTorch(on: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCaptureSession() {
        if self.previousCameraMode != cameraMode {
            self.toggleTorch(on: false)
            captureSession.stopRunning()
            timer?.invalidate()
            
            self.captureSession.inputs.forEach { input in
                self.captureSession.removeInput(input)
            }
            self.captureSession.outputs.forEach { output in
                self.captureSession.removeOutput(output)
            }
            
            captureSession.beginConfiguration()
            
            let cameraPosition: AVCaptureDevice.Position = self.cameraMode == "front" ? .front : .back
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else { return }
            captureSession.addInput(videoDeviceInput)
            
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(coordinator, queue: DispatchQueue(label: "videoQueue"))
            guard captureSession.canAddOutput(videoDataOutput) else { return }
            captureSession.addOutput(videoDataOutput)
            
            captureSession.commitConfiguration()
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer!)
            
            captureSession.startRunning()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { [weak self] _ in
                self?.coordinator?.processCurrentFrame()
            }
                
            self.previousCameraMode = cameraMode
        }
        
        self.toggleTorch(on: self.flashEnabled)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch cannot be used: \(error)")
        }
    }

    deinit {
        self.toggleTorch(on: false)
        captureSession.stopRunning()
        timer?.invalidate()
    }
}

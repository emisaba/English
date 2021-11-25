import UIKit
import AVFoundation

extension CameraViewController {
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    func setupCamera() {
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
                output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                captureSession = session
                
            } catch {
                print("error")
            }
        }
    }
    
    func createRectForTextAreaView(image: UIImage) -> CGRect {
        
        let imgWidth = image.size.width
        let imageHeight = image.size.height
        
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        
        let widthLatio = imgWidth / viewWidth
        let heightLatio = imageHeight / viewHeight
        
        let originalWidth = targetAreaView.frame.size.width
        let originalHeight = targetAreaView.frame.size.height
        
        let cropWidth = originalWidth * widthLatio
        let cropHeight = originalHeight * heightLatio

        let rect = CGRect(x: targetAreaView.frame.origin.x,
                          y: targetAreaView.frame.origin.y,
                          width: cropWidth,
                          height: cropHeight)
        return rect
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let image = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        backgroundImageView.image = image
        
        let textAreaImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        let textAreaViewRect = createRectForTextAreaView(image: textAreaImage)
        guard let croppedImage = textAreaImage.croppingImage(to: textAreaViewRect) else { return }
        targetAreaView.image = croppedImage
    }
    
    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let base = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        let bytesPerRow = UInt(CVPixelBufferGetBytesPerRow(imageBuffer))
        let width = UInt(CVPixelBufferGetWidth(imageBuffer))
        let height = UInt(CVPixelBufferGetHeight(imageBuffer))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerCompornent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext = CGContext(data: base, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerCompornent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)! as CGContext
        
        let imageRef = newContext.makeImage()!
        let image = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImage.Orientation.right)
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return image
    }
}

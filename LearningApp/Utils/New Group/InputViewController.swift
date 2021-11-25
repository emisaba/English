import UIKit
import AVFoundation
//import googleapis

//class InputViewController: UIViewController, AudioControllerDelegate {
    
    
    // MARK: - Properties
    
//    var audioData: NSMutableData!
//
//    lazy var createCardView: CreateCardView = {
//        let view = CreateCardView()
//        view.tapFunctionDelegate = self
//        return view
//    }()
    
    // MARK: - Lifecycle
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        AudioController.sharedInstance.delegate = self
//
//        view.addSubview(createCardView)
//        createCardView.fillSuperview()
//    }
    
    // MARK: - Helpers
    
//    func processSampleData(_ data: Data) -> Void {
//      audioData.append(data)
//      var text: String?
//
//      let chunkSize : Int = Int(0.1 * Double(SAMPLE_RATE) * 2);
//
//      if (audioData.length > chunkSize) {
//        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
//                                                                completion:
//          { [weak self] (response, error) in
//              guard let strongSelf = self else {
//                  return
//              }
//
//              if let error = error {
//                strongSelf.createCardView.textView.text = error.localizedDescription
//
//              } else if let response = response {
//                var finished = false
//
//                for result in response.resultsArray! {
//
//                    if let result = result as? StreamingRecognitionResult {
//
//                        text = (result.alternativesArray?.firstObject as? SpeechRecognitionAlternative)?.transcript ?? ""
//
//                        if result.isFinal {
//                            finished = true
//                        }
//                    }
//                }
//
//                strongSelf.createCardView.textView.text = text
//
//                if finished {
//                    //                      strongSelf.didTapMicButton(strongSelf)
//                    _ = AudioController.sharedInstance.stop()
//                    SpeechRecognitionService.sharedInstance.stopStreaming()
//                }
//              }
//          })
//        self.audioData = NSMutableData()
//      }
//    }
//}

// MARK: - InputViewDelegate

//extension InputViewController: TapFunctionDelegate {
//
//    func didTapCameraButton() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSession.Category.record)
//        } catch {
//
//        }
//        audioData = NSMutableData()
//        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
//        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
//        _ = AudioController.sharedInstance.start()
//    }
//
//    func didTapMicButton() {
//
//    }
//}

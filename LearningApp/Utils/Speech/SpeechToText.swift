import UIKit
import Speech

class SpeechToText: UIViewController, SFSpeechRecognizerDelegate {
    
    // MARK: - Properties
    
    static let audioEngine = AVAudioEngine()
    static let speechRecognizer = SFSpeechRecognizer()
    static let request = SFSpeechAudioBufferRecognitionRequest()
    static var task: SFSpeechRecognitionTask?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helper
    
    static func didTapStartButton() -> [String] {
        
        var wordArray = [String]()
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _  in
            self.request.append(buffer)
        }
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
            let message = result?.bestTranscription.formattedString ?? ""
            let dividedMessage = message.split(separator: " ")
            wordArray = dividedMessage.map { String($0) }
        })
        
        print("###元inputWordArray: \(wordArray)")
        return wordArray
    }
    
    static func reqestPermission() {
        
        SFSpeechRecognizer.requestAuthorization { authState in
            switch authState {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            default:
                break
            }
        }
    }
}

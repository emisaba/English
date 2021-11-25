import Foundation
import AVFoundation

struct TextToSpeechService {
    
    // MARK: - Properties
    
    static let speechSynthesizer = AVSpeechSynthesizer()
    static var rate = AVSpeechUtteranceDefaultSpeechRate
    
    // MARK: - Helpers
    
    static func startSpeech(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        speechSynthesizer.speak(utterance)
    }
    
    static func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

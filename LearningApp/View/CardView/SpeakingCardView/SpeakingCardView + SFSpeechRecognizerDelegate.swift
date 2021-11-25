import UIKit
import Speech

// MARK: - SFSpeechRecognizerDelegate

extension SpeakingCardView: SFSpeechRecognizerDelegate {
    
    func startRecording() {
        
        var isPreparedForNextResult = false
        
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
            
            if let error = error { print(error.localizedDescription) }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in isPreparedForNextResult = false }
            if isPreparedForNextResult == true { return }
            
            guard let result = result else { return }
            self.checkIfInputTextIsCorrect(result: result)
            
            isPreparedForNextResult = true
        })
    }
    
    func checkIfInputTextIsCorrect(result: SFSpeechRecognitionResult) {
        var splitMessage = [String]()
        var checkNumber = 0
        
        if checkNumber >= self.viewmodel.englishArray.count { return }
        
        let message = result.bestTranscription.formattedString
        splitMessage = message.split(separator: " ").map { String($0) }
        
        guard let lastText = splitMessage.last else { return }
        self.speakingLabel.text = lastText
        
        if self.viewmodel.englishArray[checkNumber].lowercased() == lastText.lowercased() {
            NotificationCenter.default.post(name: Notification.Name("speach"), object: lastText)
            checkNumber += 1
        }
    }
    
    func reqestPermission() {
        
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


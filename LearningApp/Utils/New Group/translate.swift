
import MLKitTranslate
import UIKit

class Translate {
    func translate(text: String) {

        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .japanese)
        let translator = Translator.translator(options: options)

        let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)

        translator.downloadModelIfNeeded(with: conditions) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            translator.translate(text) { translatedText, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("translatedText:\(translatedText ?? "")")
            }
        }
    }
}

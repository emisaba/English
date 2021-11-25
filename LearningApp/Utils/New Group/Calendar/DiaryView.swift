import UIKit
import AVFoundation

protocol DiaryViewDelegate {
    func didTapSave(textView: UITextView)
}

class DiaryView: UIView, AVAudioRecorderDelegate {
    
    // MARK: - Properties
    
    var delegate: DiaryViewDelegate?
    var diaryTextView = UITextView()
    private lazy var diaryView = createDiaryView()
    private let startButton = UIButton()
    private let micButton = UIButton()
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer?
    
    let today = Calendar.monthAndDate(selectedDate: Date())
    var selectedDate: Date?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(diaryView)
        diaryView.fillSuperview()
        
        prepareAudio()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapMicButton() {
        
        if audioRecorder == nil {
            
            let filename = getDirectory()
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                
                audioRecorder.record()
                audioRecorder.record()
                
                micButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            } catch {
                print("fail to record")
            }
        } else {
            audioRecorder?.stop()
            audioRecorder = nil
            
            micButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        }
    }
    
    @objc func didTapStartButton() {
        
        let filename = getDirectory()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: filename)
            audioPlayer?.volume = 20
            audioPlayer?.play()
        } catch {
            print("###fail")
        }
    }
    
    @objc func didTapSaveButton() {
        delegate?.didTapSave(textView: diaryTextView)
    }
    
    @objc func didTapDictionaryButton() {
//        let vc = SearchViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapCheckListButton() {
//        delegate?.checkList()
    }
    
    // MARK: - Helpers
    
    func prepareAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        recordingSession?.requestRecordPermission{ hasPermission in
            if hasPermission {
                print("ACCEPTED!")
            }
        }
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        var filename: URL
        
        if selectedDate != Date() {
            let selectedDateString = Calendar.monthAndDate(selectedDate: selectedDate ?? Date())
            filename = documentDirectory.appendingPathComponent("\(selectedDateString).m4a")
        } else {
            filename = documentDirectory.appendingPathComponent("\(today).m4a")
        }
        
        return filename
    }
    
    func createDiaryView() -> UIView {
        let diaryView = UIView()
        diaryView.backgroundColor = .white
        diaryView.layer.cornerRadius = 30
        diaryView.layer.shadowColor = UIColor.black.cgColor
        diaryView.layer.shadowRadius = 10
        diaryView.layer.shadowOffset = .zero
        diaryView.layer.shadowOpacity = 0.2
        
        
        diaryTextView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        diaryTextView.layer.cornerRadius = 20
        diaryTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        diaryTextView.font = .lexendDecaRegular(size: 16)
        diaryView.addSubview(diaryTextView)
        diaryTextView.anchor(top: diaryView.topAnchor,
                        left: diaryView.leftAnchor,
                        right: diaryView.rightAnchor,
                        paddingTop: 50,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 280)
        
        let dictionaryButton = UIButton()
        dictionaryButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        dictionaryButton.layer.cornerRadius = 25
        dictionaryButton.addTarget(self, action: #selector(didTapDictionaryButton), for: .touchUpInside)
        diaryView.addSubview(dictionaryButton)
        dictionaryButton.anchor(top: diaryView.topAnchor,
                                right: diaryTextView.rightAnchor,
                                paddingTop: 270,
                                paddingRight: 10)
        dictionaryButton.setDimensions(height: 50, width: 50)
        
//        micButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        micButton.layer.cornerRadius = 25
        micButton.backgroundColor = .systemPink
        micButton.addTarget(self, action: #selector(didTapMicButton), for: .touchUpInside)
        diaryView.addSubview(micButton)
        micButton.anchor(top: diaryTextView.bottomAnchor,
                         paddingTop: 30)
        micButton.centerX(inView: diaryView)
        micButton.setDimensions(height: 50, width: 50)
        
        startButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        startButton.layer.cornerRadius = 25
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        diaryView.addSubview(startButton)
        startButton.anchor(top: diaryTextView.bottomAnchor,
                           left: micButton.rightAnchor,
                           paddingTop: 30,
                           paddingLeft: 30)
        startButton.setDimensions(height: 50, width: 50)
        
        let saveButton = UIButton()
        saveButton.layer.cornerRadius = 25
        saveButton.setTitle("save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = .lexendDecaBold(size: 16)
        saveButton.layer.borderWidth = 2
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        diaryView.addSubview(saveButton)
        saveButton.anchor(top: micButton.bottomAnchor,
                          paddingTop: 30)
        saveButton.setDimensions(height: 50, width: 150)
        saveButton.centerX(inView: diaryView)
        
        return diaryView
    }
}

//// MARK: - AVAudioRecorderDelegate
//
//extension DiaryView: AVAudioRecorderDelegate {
//
//}

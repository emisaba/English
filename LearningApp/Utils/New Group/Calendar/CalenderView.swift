import UIKit
import FSCalendar

protocol CalenderViewDelegate {
    func search()
    func checkList()
    func hideMenuBar()
    func showMenuBar()
    func didTapToday()
    func didTapOtherDay(dateForURL: Date)
}

class CalenderView: UIView {
    
    // MARK: - Properties
    
    var delegate: CalenderViewDelegate?
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleFont = .lexendDecaBold(size: 18)
        calendar.appearance.headerTitleFont = .lexendDecaBold(size: 18)
        calendar.appearance.weekdayFont = .lexendDecaRegular(size: 14)
        calendar.appearance.todayColor = .systemPink
        calendar.appearance.weekdayTextColor = .systemGray
        calendar.appearance.selectionColor = .systemYellow
        calendar.appearance.headerTitleColor = .systemGray
        return calendar
    }()
    
//    private let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter
//    }()
    
    private let formatter = DateFormatter.createDate()
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["all", "month"])
        sc.selectedSegmentIndex = 0
        let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 15)]
        sc.setTitleTextAttributes(attribute, for: .normal)
        return sc
    }()
    
    private lazy var registerCardView = createDataView(image: #imageLiteral(resourceName: "pooh"), text: "Register", unit: "枚")
    private lazy var masterCardView = createDataView(image: #imageLiteral(resourceName: "pooh"), text: "Master", unit: "枚")
    private lazy var hoursCardView = createDataView(image: #imageLiteral(resourceName: "pooh"), text: "hours", unit: "h")
    
//    private lazy var diaryView = createDiaryView()
//    private let diaryTextView = UITextView()
    
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let checkListButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapCheckListButton), for: .touchUpInside)
       return button
    }()
    
    private let studiedButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapCheckListButton), for: .touchUpInside)
       return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.diaryView.frame = CGRect(x: 0, y: frame.height + 100, width: frame.width, height: frame.height)
//        addSubview(diaryView)
    }
    
    // MARK: - Actions
    
    @objc func didTapSaveButton() {
        
//        delegate?.showMenuBar()
//
//        UIView.animate(withDuration: 0.25) {
//            self.blackView.backgroundColor = .black.withAlphaComponent(0)
            
//            self.diaryView.frame = CGRect(x: 0,
//                                          y: self.frame.height + 100,
//                                          width: self.frame.width,
//                                          height: self.frame.height)
//            self.diaryTextView.resignFirstResponder()
//        }
    }
    
    @objc func didTapDictionaryButton() {
        delegate?.search()
    }
    
    @objc func didTapCheckListButton() {
        delegate?.checkList()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        addSubview(calendar)
        calendar.anchor(top: safeAreaLayoutGuide.topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 380)
        
        addSubview(segmentControl)
        segmentControl.anchor(top: calendar.bottomAnchor,
                              paddingTop: 40)
        segmentControl.setDimensions(height: 30, width: 200)
        segmentControl.centerX(inView: self)
        
        let stackView = UIStackView(arrangedSubviews: [registerCardView, masterCardView, hoursCardView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: segmentControl.bottomAnchor,
                         left: leftAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 20,
                         paddingBottom: 20)
        
        addSubview(blackView)
        blackView.fillSuperview()
        
        addSubview(checkListButton)
        checkListButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 10)
        checkListButton.setDimensions(height: 44, width: 44)
        
        addSubview(studiedButton)
        studiedButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: checkListButton.leftAnchor, paddingTop: 10, paddingRight: 10)
        studiedButton.setDimensions(height: 44, width: 44)
    }
    
    func createDataView(image: UIImage, text: String, unit: String) -> UIView {
        let view = UIView()
        
        let icon = UIImageView()
        icon.image = image
        icon.contentMode = .scaleAspectFill
        view.addSubview(icon)
        icon.anchor(left: view.leftAnchor,
                    paddingLeft: 20)
        icon.setDimensions(height: 50, width: 50)
        icon.centerY(inView: view)
        
        let titleLabel = UILabel()
        titleLabel.font = .lexendDecaBold(size: 20)
        titleLabel.text = text
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor,
                          left: icon.rightAnchor,
                          bottom: view.bottomAnchor,
                          paddingLeft: 20,
                          height: 50)
        
        let unitLabel = UILabel()
        unitLabel.font = .lexendDecaRegular(size: 18)
        unitLabel.text = unit
        unitLabel.textColor = .lightGray
        view.addSubview(unitLabel)
        unitLabel.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingRight: 20,
                         height: 50)
        
        let countLabel = UILabel()
        countLabel.font = .lexendDecaBold(size: 38)
        countLabel.text = "33"
        view.addSubview(countLabel)
        countLabel.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          right: unitLabel.leftAnchor,
                          paddingRight: 20,
                          height: 50)
        
        return view
    }
    
//    func createDiaryView() -> UIView {
//        let diaryView = UIView()
//        diaryView.backgroundColor = .white
//        diaryView.layer.cornerRadius = 30
//        diaryView.layer.shadowColor = UIColor.black.cgColor
//        diaryView.layer.shadowRadius = 10
//        diaryView.layer.shadowOffset = .zero
//        diaryView.layer.shadowOpacity = 0.2
//
//
//        diaryTextView.backgroundColor = .lightGray.withAlphaComponent(0.1)
//        diaryTextView.layer.cornerRadius = 20
//        diaryTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        diaryTextView.font = .lexendDecaRegular(size: 16)
//        diaryView.addSubview(diaryTextView)
//        diaryTextView.anchor(top: diaryView.topAnchor,
//                        left: diaryView.leftAnchor,
//                        right: diaryView.rightAnchor,
//                        paddingTop: 50,
//                        paddingLeft: 20,
//                        paddingRight: 20,
//                        height: 280)
//
//        let dictionaryButton = UIButton()
//        dictionaryButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
//        dictionaryButton.layer.cornerRadius = 25
//        dictionaryButton.addTarget(self, action: #selector(didTapDictionaryButton), for: .touchUpInside)
//        diaryView.addSubview(dictionaryButton)
//        dictionaryButton.anchor(top: diaryView.topAnchor,
//                                right: diaryTextView.rightAnchor,
//                                paddingTop: 270,
//                                paddingRight: 10)
//        dictionaryButton.setDimensions(height: 50, width: 50)
//
//        let micButton = UIButton()
//        micButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
//        micButton.layer.cornerRadius = 25
//        diaryView.addSubview(micButton)
//        micButton.anchor(top: diaryTextView.bottomAnchor,
//                         paddingTop: 30)
//        micButton.centerX(inView: diaryView)
//        micButton.setDimensions(height: 50, width: 50)
//
//        let startButton = UIButton()
//        startButton.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
//        startButton.layer.cornerRadius = 25
//        diaryView.addSubview(startButton)
//        startButton.anchor(top: diaryTextView.bottomAnchor,
//                           left: micButton.rightAnchor,
//                           paddingTop: 30,
//                           paddingLeft: 30)
//        startButton.setDimensions(height: 50, width: 50)
//
//        let saveButton = UIButton()
//        saveButton.layer.cornerRadius = 25
//        saveButton.setTitle("save", for: .normal)
//        saveButton.setTitleColor(.black, for: .normal)
//        saveButton.titleLabel?.font = .lexendDecaBold(size: 16)
//        saveButton.layer.borderWidth = 2
//        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
//        diaryView.addSubview(saveButton)
//        saveButton.anchor(top: micButton.bottomAnchor,
//                          paddingTop: 30)
//        saveButton.setDimensions(height: 50, width: 150)
//        saveButton.centerX(inView: diaryView)
//
//        return diaryView
//    }
}

// MARK: - FSCalendarDataSource

extension CalenderView: FSCalendarDataSource {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        return #imageLiteral(resourceName: "phoo_mini")
    }
}

// MARK: - FSCalendarDelegate

extension CalenderView: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        delegate?.hideMenuBar()
        
        let selectedDate = formatter.string(from: date)
        let now = formatter.string(from: Date())
        
        let dateForURL = date.addingTimeInterval(TimeInterval(60*60*9))
        
        if selectedDate == now {
//            UIView.animate(withDuration: 0.25) {
//                self.diaryView.frame.origin.y = 0
//                self.diaryTextView.isEditable = true
//                self.diaryTextView.becomeFirstResponder()
//            }
            delegate?.didTapToday()
        } else {
//            UIView.animate(withDuration: 0.25) {
//                self.blackView.backgroundColor = .black.withAlphaComponent(0.7)
//                self.diaryView.frame.origin.y = 100
//                self.diaryTextView.isEditable = false
//            }
            delegate?.didTapOtherDay(dateForURL: dateForURL)
        }
    }
}

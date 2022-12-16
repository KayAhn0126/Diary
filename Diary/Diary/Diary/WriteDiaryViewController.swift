//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Kay on 2022/11/28.
//

import UIKit

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryDelegateProtocol?
    var diaryMode: DiaryMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.delegate = self
        self.configureBorderStyle()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    // MARK: - 수정 버튼을 통해 WriteDiaryViewController에 진입했을 때 설정 모드로 보이기 위해 설정하는 메서드
    private func configureEditMode() {
        if case let .edit(_, diary) = self.diaryMode {
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        }
    }
    
    // MARK: - 각 입력창이 특정 이벤트를 발생시킬때 실행될 메서드를 연결하는 메서드
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    private func configureBorderStyle() {
        let borderColor = UIColor(named: "LDColor")!
        self.contentsTextView.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
        self.titleTextField.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
        self.dateTextField.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
    }
    
    // MARK: - DatePicker 구성 메서드 정의
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker
        self.diaryDate = datePicker.date
        self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: self.diaryDate!)
    }
    
    // MARK: - 등록 버튼이 눌렸을 때 diaryMode에 따라 달리 실행되는 메서드 정의
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let content = contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: content, date: date, isStar: false)
        switch self.diaryMode {
        case .new :
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(indexPath: indexPath, diary: _) :
            NotificationCenter.default.post(name: NSNotification.Name("editDiary"),
                                            object: diary,
                                            userInfo: [
                                                "indexPath.row" : indexPath.row
                                            ]
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - datePicker는 변경될 때 valueChanged 이벤트를 발생, dateTextField는 valueChanged를 감지하지 못하니 editingChanged 이벤트를 전송
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        self.diaryDate = datePicker.date
        self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: self.diaryDate!)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    // MARK: - 화면의 다른곳을 클릭하면 실행되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - 메서드 내 조건을 통해 '등록' 버튼 활성화 여부를 판단하는 메서드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

// MARK: - textView 클래스는 UIControl 클래스를 상속하지 않기 때문에 아래와 같이 textViewDidChange로 감지하는 메서드 구현
extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}

extension WriteDiaryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

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
    var diaryEditMode: DiaryMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode() {
        if case let .edit(_, diary) = self.diaryEditMode {
            self.titleTextField.text = diary.titile
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        }
    }
    
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
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker
        self.diaryDate = datePicker.date
        self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: self.diaryDate!)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let content = contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(titile: title, contents: content, date: date, isStar: false)
        switch self.diaryEditMode {
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
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        self.diaryDate = datePicker.date
        self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: self.diaryDate!)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}

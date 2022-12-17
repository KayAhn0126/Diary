//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Kay on 2022/11/28.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    var starButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    weak var deleteDelegate: DiaryDeleteDelegateProtocol?
    weak var starDelegate: DiaryStarDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailView()
    }
    
    private func configureDetailView() {
        guard let diary = self.diary else { return }
        
        self.titleTextField.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateTextField.text = DiaryFormat.swapToDiaryFormat(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
        
        let borderColor = UIColor(named: "LDColor")!
        self.titleTextField.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
        self.contentsTextView.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
        self.dateTextField.layer.settingBorderWithOptions(color: borderColor, width: 0.5, cornerRadius: 5.0)
    }
    
    // MARK: - 노티가 오면 실행되는 메서드
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configureDetailView()
    }
    
    // MARK: - 수정 버튼을 눌렀을 때 실행되는 메서드 / 실행됨과 동시에 구독을 하고 있다.
    @IBAction func tapEditButton(_ sender: UIButton) {
        let detailStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let writeDiaryViewController = detailStoryboard.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        writeDiaryViewController.diaryMode = .edit(indexPath: indexPath, diary: diary)
        writeDiaryViewController.navigationItem.title = "일기 수정"
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: Notification.Name("editDiary"), object: nil)
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    // MARK: - 삭제 버튼 클릭시 실행되는 메서드
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.deleteDelegate?.didSelectDelete(cellLocation: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - star(즐겨찾기) 버튼이 눌렸을 때 실행되는 메서드
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        guard let indexPath = self.indexPath else { return }
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        self.starDelegate?.didSelectStar(cellLocation: indexPath, isStar: !isStar)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

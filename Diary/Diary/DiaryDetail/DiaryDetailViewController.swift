//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Kay on 2022/11/28.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    weak var delegate: DiaryDeleteDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailView()
    }
    
    private func configureDetailView() {
        guard let title = diary?.titile else { return }
        guard let contents = diary?.contents else { return }
        guard let date = diary?.date else { return }
        
        titleLabel.text = title
        contentsTextView.text = contents
        dateLabel.text = DiaryFormat.swapToDiaryFormat(date: date)
        
        let borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        self.titleLabel.layer.settingBorderWithOptions(color: borderColor, width: 0.1, cornerRadius: 3.0)
        self.contentsTextView.layer.settingBorderWithOptions(color: borderColor, width: 0.1, cornerRadius: 3.0)
        self.dateLabel.layer.settingBorderWithOptions(color: borderColor, width: 0.1, cornerRadius: 3.0)
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
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: Notification.Name("editDiary"), object: nil)
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    // MARK: - 삭제 버튼 클릭시 실행되는 메서드
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.delegate?.didSelectDelete(cellLocation: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

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
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureDetailView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        let detailStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let writeDiaryViewController = detailStoryboard.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        writeDiaryViewController.diaryEditMode = .edit(indexPath: indexPath, diary: diary)
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: Notification.Name("editDiary"), object: nil)
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.delegate?.didSelectDelete(cellLocation: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

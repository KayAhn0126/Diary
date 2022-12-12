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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let date = diary?.date else { return }
        
        titleLabel.text = title
        contentsTextView.text = contents
        dateLabel.text = formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.delegate?.didSelectDelete(cellLocation: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
}

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
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.delegate?.didSelectDelete(cellLocation: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
}

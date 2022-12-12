//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Kay on 2022/11/27.
//

import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(diary: Diary) {
        let borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
        titleLabel.text = diary.titile
        dateLabel.text = DiaryFormat.shared.swapToDiaryFormat(date: diary.date, isSimplify: true)
    }
}

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
        let borderColor = UIColor(named: "LDColor")!
        self.layer.settingBorderWithOptions(color: borderColor, width: 1.0, cornerRadius: 3.0)
        titleLabel.text = diary.title
        dateLabel.text = DiaryFormat.swapToDiaryFormat(date: diary.date, isSimplify: true)
    }
}

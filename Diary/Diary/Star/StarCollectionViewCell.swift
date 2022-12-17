//
//  StarCollectionViewCell.swift
//  Diary
//
//  Created by Kay on 2022/11/27.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(diary: Diary) {
        self.titleLabel.text = diary.title
        self.dateLabel.text = DiaryFormat.swapToDiaryFormat(date: diary.date, isSimplify: false)
        self.layer.settingBorderWithOptions(color: UIColor(named: "LDColor")!, width: 1.0, cornerRadius: 5.0)
    }
}

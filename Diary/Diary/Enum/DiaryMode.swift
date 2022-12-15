//
//  DiaryMode.swift
//  Diary
//
//  Created by Kay on 2022/12/13.
//
import Foundation

// MARK: - WriteDiaryViewController에 들어갔을때 신규작성, 수정 분류를 위한 열거형
enum DiaryMode {
    case new
    case edit(indexPath: IndexPath, diary: Diary)
}


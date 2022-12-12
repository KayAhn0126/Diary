//
//  DiaryFormat.swift
//  Diary
//
//  Created by Kay on 2022/12/12.
//

import Foundation

final class DiaryFormat {
    static let shared = DiaryFormat()
    
    private func swapToDiaryFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

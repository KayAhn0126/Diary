//
//  DiaryFormat.swift
//  Diary
//
//  Created by Kay on 2022/12/12.
//

import Foundation

// MARK: - 기본 화면의 양식과 작성 화면의 양식 세분화 -> 마지막 파라미터의 값으로 판단
struct DiaryFormat {
    static func swapToDiaryFormat(date: Date, isSimplify: Bool = false) -> String {
        let formatter = DateFormatter()
        if isSimplify {
            formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        } else {
            formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        }
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

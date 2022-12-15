//
//  Diary.swift
//  Diary
//
//  Created by Kay on 2022/12/07.
//

import Foundation

// MARK: - Diary 구조체 Hashable -> DiffableDataSource Item, Codable -> UserDefaults 객체 직렬화
struct Diary: Hashable, Codable {
    var titile: String
    var contents: String
    var date: Date
    var isStar: Bool 
}

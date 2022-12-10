//
//  Diary.swift
//  Diary
//
//  Created by Kay on 2022/12/07.
//

import Foundation

struct Diary: Hashable, Codable {
    var titile: String
    var contents: String
    var date: Date
    var isStar: Bool 
}

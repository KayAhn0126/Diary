//
//  DiaryMode.swift
//  Diary
//
//  Created by Kay on 2022/12/13.
//
import Foundation

enum DiaryMode {
    case new
    case edit(indexPath: IndexPath, diary: Diary)
}


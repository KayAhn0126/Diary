//
//  DiaryStarDelegateProtocol.swift
//  Diary
//
//  Created by Kay on 2022/12/17.
//

import Foundation

protocol DiaryStarDelegateProtocol: AnyObject {
    func didSelectStar(cellLocation: IndexPath, isStar: Bool)
}

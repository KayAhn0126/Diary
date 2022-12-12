//
//  DiaryDeleteDelegateProtocol.swift
//  Diary
//
//  Created by Kay on 2022/12/12.
//

import Foundation

protocol DiaryDeleteDelegateProtocol: AnyObject {
    func didSelectDelete(cellLocation: IndexPath)
}

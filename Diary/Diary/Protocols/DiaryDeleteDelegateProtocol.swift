//
//  DiaryDeleteDelegateProtocol.swift
//  Diary
//
//  Created by Kay on 2022/12/12.
//

import Foundation

// MARK: - 삭제 버튼 눌렀을때 두 VC간 연결을 도와줄 프로토콜
protocol DiaryDeleteDelegateProtocol: AnyObject {
    func didSelectDelete(cellLocation: IndexPath)
}

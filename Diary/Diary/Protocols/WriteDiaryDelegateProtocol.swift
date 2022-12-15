//
//  WriteDiaryDelegateProtocol.swift
//  Diary
//
//  Created by Kay on 2022/12/07.
//

import Foundation

// MARK: - 등록 버튼 눌렀을때 두 VC간 연결을 도와줄 프로토콜
protocol WriteDiaryDelegateProtocol: AnyObject {
    func didSelectRegister(diary: Diary)
}

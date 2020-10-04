//
//  CalendarRealm.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/03.
//

import Foundation
import RealmSwift
//モデルクラスの作成
class CalendarRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var hosu: Double = 0.0
    
}


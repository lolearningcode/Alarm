//
//  Alarm.swift
//  Alarm
//
//  Created by Lo Howard on 5/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class Alarm: Codable {
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm"
            formatter.locale = Locale(identifier: "en_US")
            let timeAsString = formatter.string(from: fireDate)
            return timeAsString
        }
    }
    
    init(fireDate: Date, name: String, enabled: Bool = false, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate &&
        lhs.name == rhs.name &&
        lhs.enabled == rhs.enabled
    }
    
}

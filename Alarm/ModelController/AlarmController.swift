//
//  AlarmController.swift
//  Alarm
//
//  Created by Lo Howard on 5/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController: AlarmScheduler {
    
    static let shared = AlarmController.init()
    
    init() {
        loadFromPersistentStore()
    }
    
    var alarms: [Alarm] = []
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(alarm)
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let alarmToDelete = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: alarmToDelete)
        saveToPersistentStore()
    }
    
    func toggleEnabled(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    // MARK: Persistence
    
    //GET URL where were saving data
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarm.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    //SAVE DATA
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print(error)
        }
    }
    //FETCH DATA
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarm = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarm
        } catch let error {
            print(error)
        }
    }
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Is Going Off"
        content.body = "Time To Get Up"
        content.sound = .default
        let fireDate = alarm.fireDate
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: dateTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to schedule local notification request: \(error) : \(error.localizedDescription)")
            }
        }
        
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

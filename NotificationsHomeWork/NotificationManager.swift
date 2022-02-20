//
//  NotificationManager.swift
//  NotificationsHomeWork
//
//  Created by Сергей Матвеенко on 17.02.2022.
//

import Foundation
import UIKit

class NotificationManager {
    let notificationCenter = UNUserNotificationCenter.current()
    
    let defaults = UserDefaults.standard
    var alarmDate = Date()
    var titleText: String? {
        set {
            defaults.set(newValue, forKey: "Title")
        }
        get {
            defaults.object(forKey: "Title") as? String
        }
    }
    var subtitleText: String? {
        set {
            defaults.set(newValue, forKey: "Subtitle")
        }
        get {
            defaults.object(forKey: "Subtitle") as? String
        }
    }
    
    // функция запроса разрешения на push уведомления
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            //            self.notificationCenter.getNotificationSettings { (settings) in
            //                guard settings.authorizationStatus == .authorized else { return }
            //            }
        }
    }

    func applyNotification() {
        let content = UNMutableNotificationContent()
        content.title = titleText ?? "No Title"
        content.subtitle = subtitleText ?? "No Subtitle"
        content.body = "Congratulations for Sergey 🙂"
        content.sound = UNNotificationSound.defaultRingtone
        let dateFromPicker = alarmDate
        var date = DateComponents()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateFromPicker)
        date.year = components.year
        date.month = components.month
        date.day = components.day
        date.hour = components.hour
        date.minute = components.minute
        date.second = components.second
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "notificationtesthw", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            return
        }
    }
}

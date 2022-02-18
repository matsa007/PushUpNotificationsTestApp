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
    var alarmDate = Date()
    let fvc = FirstViewController()
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            //            self.notificationCenter.getNotificationSettings { (settings) in
            //                guard settings.authorizationStatus == .authorized else { return }
            //            }
        }
    }
    
    
    
    
    
    func checkForAuthorization() {
        notificationCenter.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                DispatchQueue.main.async {
                    self.fvc.unAuthorizedView.isHidden = true
                    self.fvc.authorizedView.isHidden = false
                    
                }
                print("*******User granted permission for notification")
            case .denied:
                DispatchQueue.main.async {
                    self.fvc.unAuthorizedView.isHidden = false
                    self.fvc.authorizedView.isHidden = true
                }
                print("User denied notification permission")
            case .notDetermined:
                DispatchQueue.main.async {
                    self.fvc.authorizedView.isHidden = false
                    self.fvc.unAuthorizedView.isHidden = true
                    
                }
                print("Notification permission haven't been asked yet")
            case .provisional:
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
    
    
    
    
    func applyNotification() {
        print("VKL UOUOUOUOU")
        print(fvc.timePicker.date)
        print("alarm date \(alarmDate)")
        let content = UNMutableNotificationContent()
        content.title = fvc.titleTextField.text ?? "Title isn't entered"
        content.subtitle = fvc.subtitleTextField.text ?? "Subtitle isn't entered"
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

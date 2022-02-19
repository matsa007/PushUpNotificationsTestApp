//
//  MemoryManager.swift
//  NotificationsHomeWork
//
//  Created by Сергей Матвеенко on 19.02.2022.
//

import Foundation
import UIKit

class MemoryManager {
    let userDefaults = UserDefaults.standard
    
    func savelanguage (_ lang: String?) {
        userDefaults.set(lang, forKey: "language")
    }
    
    func loadlanguage () -> String {
        if let language = userDefaults.object(forKey: "language") as? String {
            return language
        } else {
            return "en"
        }
    }
}

//
//  ViewController.swift
//  DemoLocalNotification
//
//  Created by Oleksandr Seminov on 1/2/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForPermission()
    }

    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) {didAllow,error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .denied:
                return
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let identifier = "my-morning-notification"
        let title = "Time to work out!"
        let body = "Don't be a lazy little butt!"
        let hour = 14
        let minute = 49
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: .current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }

}


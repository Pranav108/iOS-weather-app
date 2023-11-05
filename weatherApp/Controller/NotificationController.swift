//
//  NotificationController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 05/11/23.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
    var body: String
    var dateComponent : DateComponents
}

class NotificationHandler {
    
    private let center = UNUserNotificationCenter.current()
    
    var notifications = [Notification]()
    
    func addNotification(title: String,body: String, dateComponent : DateComponents) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title,body: body,dateComponent: dateComponent))
    }
    
    func schedule() -> Void {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    private func requestPermission() -> Void {
        center.requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
                // We have permission!
            }else{
                // We do not have permission!
                print(error!.localizedDescription)
            }
        }
    }
    
   private func scheduleNotifications() -> Void {
       center.removeAllPendingNotificationRequests()
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            center.add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id), \(notification.dateComponent)")
            }
        }
    }
    
}

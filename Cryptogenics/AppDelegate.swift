//
//  AppDelegate.swift
//  Cryptogenics
//
//  Created by user on 4/17/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Cloud Messaging Setup
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        setupUserInfoForNotification(userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Hello")
    }
    
    func setupUserInfoForNotification(userInfo: [AnyHashable: Any]) {
        guard let data = userInfo["aps"] as? [String: AnyObject] else {
          return
        }
        
        guard let title = userInfo["title"] as? String,
              let body = userInfo["body"] as? String else {
            print(userInfo)
            print(data)
            return
        }

        print("\nNotification:\nTitle: \(title)\nBody: \(body)")
//
        createNotification(title: title, body: body)
    }
    
    func createNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest.init(identifier: "pushNotif", content: content, trigger: nil)

        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}

// Cloud Messaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        
        // Store token in Firestore for sending notifications from server in the future
        UserDefaults.standard.setValue(dataDict["token"], forKey: "token")
        print(dataDict)
    
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        setupUserInfoForNotification(userInfo: userInfo)
        
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }

}

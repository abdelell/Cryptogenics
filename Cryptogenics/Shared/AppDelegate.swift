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
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        
//        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
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
        
        print("DID RECEIVE REMOTE NOTIFICATION")
        
        receivedPriceAlert(userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

}

// Cloud Messaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        
        // Store token in Firestore for sending notifications from server in the future
        
        UserDefaults.standard.setValue(dataDict["token"], forKey: "token")
//        print(dataDict)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("WILL PRESENT NOTIFICATION")
        
        receivedPriceAlert(userInfo: userInfo)
        
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }
    
    func receivedPriceAlert(userInfo: [AnyHashable: Any]) {
        guard let data = userInfo["aps"] as? [String: AnyObject],
              let alert = data["alert"] as? [String: String],
              let title = alert["title"],
              let body = alert["body"] else {
            return
        }
        
        guard let documentId = userInfo["documentId"] as? String else {
            print("Error getting document id of notification price alert")
            return
        }
        
        PriceAlertUserDefaultsStore.deletePriceAlert(documentID: documentId)
        
        let documentIdDict = ["documentId": documentId]
        
        NotificationCenter.default.post(name: Notification.Name("DeletePriceAlerts"), object: nil, userInfo: documentIdDict)
        
        print("Price alert local count: \(PriceAlertUserDefaultsStore.getLocalPriceAlerts().count)")
        print("NOTIFICATION:\nTitle: \(title)\nBody: \(body)\nDocumentId: \(documentId)")
    }

}

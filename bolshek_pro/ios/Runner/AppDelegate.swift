import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Инициализация Firebase
    FirebaseApp.configure()

    // Настройка уведомлений
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .badge, .sound]
    ) { granted, error in
      if let error = error {
        print("Ошибка при запросе разрешений на уведомления: \(error)")
      } else if granted {
        print("Пользователь разрешил уведомления")
      } else {
        print("Пользователь отклонил уведомления")
      }
    }

    // Регистрация для удалённых уведомлений
    application.registerForRemoteNotifications()

    // Установить делегат Firebase Messaging
    Messaging.messaging().delegate = self

    // Регистрация плагинов Flutter
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Установка APNs токена для Firebase
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
}

// MARK: - Расширение для уведомлений
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
  // Получение FCM токена
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase FCM Token: \(String(describing: fcmToken))")
  }

  // Обработка уведомлений, полученных в foreground
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([[.alert, .sound, .badge]])
  }

  // Обработка уведомлений при взаимодействии
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    print("Пользователь взаимодействовал с уведомлением: \(response.notification.request.content.userInfo)")
    completionHandler()
  }
}

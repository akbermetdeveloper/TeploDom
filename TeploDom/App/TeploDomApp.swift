import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

// MARK: - AppDelegate (для Firebase + Push)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // Разрешение на пуш-уведомления
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("❌ Ошибка запроса пушей: \(error.localizedDescription)")
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown) // .prod или .sandbox в зависимости от сборки
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Не удалось зарегистрировать пуши: \(error.localizedDescription)")
    }
}

// MARK: - Основной App
@main
struct TeploDomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var showSplashScreen = true
    @State private var showSubview = false

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var iapViewModel = IAPViewModel()
    @StateObject private var subViewModel = SubViewModel()

    var body: some Scene {
        WindowGroup {
            contentView
                .environmentObject(authViewModel)
                .environmentObject(iapViewModel)
                .environmentObject(subViewModel)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if showSplashScreen {
            SplashScreenView(subViewModel: subViewModel)
                .onAppear {
                    handleSplashScreenAppearance()
                }
        } else if showSubview {
            SubView(subViewModel: subViewModel, showSubview: $showSubview)
        } else {
            mainNavigationView
        }
    }

    @ViewBuilder
    private var mainNavigationView: some View {
        NavigationStack {
            switch authViewModel.authState {
            case .enterAccountNumber, .enterPassword:
                SignInWithAccountView()
            case .signedIn:
                MainTabContainer(subViewModel: SubViewModel())
            case .signedOut:
                SignInWithAccountView()
            }
        }
    }

    private func handleSplashScreenAppearance() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 секунды
            await authViewModel.restoreSession()

            withAnimation {
                showSplashScreen = false
            }

            // Пример логики подписки:
            // if iapViewModel.subscriptionEndDate < Date() {
            //     showSubview = true
            // }
        }
    }
}


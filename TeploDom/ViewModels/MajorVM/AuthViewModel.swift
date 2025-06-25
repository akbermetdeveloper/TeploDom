//import Foundation
//import SwiftUI
//import FirebaseFirestore
//
//@MainActor
//class AuthViewModel: ObservableObject {
//
//    enum AuthState {
//        case enterAccountNumber
//        case enterPassword
//        case signedIn
//        case signedOut
//    }
//
//    @Published var authState: AuthState = .enterAccountNumber
//    @Published var isAuthenticated: Bool = false
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var currentAccountNumber: String?
//
//
//    private let db = Firestore.firestore()
//
//    private let sessionKey = "currentAccountNumber"
//
//    init() {}
//
//    // MARK: - Вход
//    func signIn(accountNumber: String, password: String) async -> Bool {
//        guard !accountNumber.isEmpty, !password.isEmpty else {
//            errorMessage = "Введите лицевой счёт и пароль"
//            return false
//        }
//
//        isLoading = true
//        errorMessage = nil
//        defer { isLoading = false }
//
//        do {
//            let snapshot = try await db.collection("users")
//                .whereField("accountNumber", isEqualTo: accountNumber)
//                .limit(to: 1)
//                .getDocuments()
//
//            guard let doc = snapshot.documents.first else {
//                errorMessage = "Лицевой счёт не найден"
//                return false
//            }
//        
//
//            let data = doc.data()
//            let storedPassword = data["passwordHash"] as? String ?? ""
//
//            if password == storedPassword {
//                print("✅ Вход выполнен: \(accountNumber)")
//                currentAccountNumber = accountNumber
//                authState = .signedIn
//                isAuthenticated = true
//                saveSession(accountNumber: accountNumber)
//                return true
//            } else {
//                errorMessage = "Неверный пароль"
//                return false
//            }
//
//        } catch {
//            errorMessage = "Ошибка базы данных: \(error.localizedDescription)"
//            return false
//        }
//    }
//
//    // MARK: - Сохранение сессии
//    private func saveSession(accountNumber: String) {
//        UserDefaults.standard.set(accountNumber, forKey: sessionKey)
//      
//
//    }
//
//    // MARK: - Восстановление сессии
//    func restoreSession() async {
//        let savedAccountNumber = UserDefaults.standard.string(forKey: sessionKey)
//        if let accountNumber = savedAccountNumber {
//            print("🔁 Восстановлена сессия для счёта: \(accountNumber)")
//            // Можно дополнительно проверить, существует ли пользователь в Firestore
//            authState = .signedIn
//            isAuthenticated = true
//            currentAccountNumber = accountNumber
//
//        } else {
//            authState = .enterAccountNumber
//            isAuthenticated = false
//        }
//    }
//
//    // MARK: - Выход
//    func signOut() {
//        isAuthenticated = false
//        authState = .signedOut
//        errorMessage = nil
//        UserDefaults.standard.removeObject(forKey: sessionKey)
//        print("🔒 Пользователь вышел из сессии")
//    }
//}

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum AuthState {
    case undefined // - Начальное состояние
    case signedIn
    case signedOut
}

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var authState: AuthState = .undefined
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var appUser: User?
    
    @Published var meter: Meter?
    @Published var reading: Reading?
    
    private let db = Firestore.firestore()
    private let sessionKey = "currentAccountNumber"
    private let passwordKey = "currentAccountPassword"
    
    @Published var readings: [Reading] = []
    
    init() {
        Task { await restoreSession() }
    }
    
    // MARK: - Расходы
    
    func fetchReadings() async {
        guard let userID = appUser?.id else { return }
        
        do {
            let snapshot = try await db.collection("users")
                .document(userID)
                .collection("readings")
                .order(by: "date", descending: true)
                .getDocuments()
            
            readings = snapshot.documents.compactMap { doc in
                try? doc.data(as: Reading.self)
                
            }
        } catch {
            print("Ошибка загрузки расходов: \(error.localizedDescription)")
        }
    }

    // MARK: - Вход
    func signIn(accountNumber: String, password: String) async -> Bool {
        guard !accountNumber.isEmpty, !password.isEmpty else {
            errorMessage = "Введите лицевой счёт и пароль"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let snapshot = try await db.collection("users")
                .whereField("accountNumber", isEqualTo: accountNumber)
                .limit(to: 1)
                .getDocuments()

            guard let doc = snapshot.documents.first,
                  let user = try? doc.data(as: User.self) else {
                errorMessage = "Лицевой счёт не найден"
                return false
            }

            if password == user.passwordHash {
                // Успешный вход
                appUser = user
                authState = .signedIn
                //isAuthenticated = true
                saveSession(accountNumber: accountNumber, password: password)
                return true
            } else {
                errorMessage = "Неверный пароль"
                authState = .signedOut
                return false
            }

        } catch {
            errorMessage = "Ошибка базы данных: \(error.localizedDescription)"
            authState = .signedOut
            return false
        }
    }

    // MARK: - Сохранение сессии
    private func saveSession(accountNumber: String, password: String) {
        UserDefaults.standard.set(accountNumber, forKey: sessionKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
    }

    // MARK: - Восстановление сессии
    func restoreSession() async {
        guard let accountNumber = UserDefaults.standard.string(forKey: sessionKey),
              let password = UserDefaults.standard.string(forKey: passwordKey) else {
            authState = .signedOut
            return
        }
        let success = await signIn(accountNumber: accountNumber, password: password)
        if !success {
            authState = .signedOut
        }
        
    }

    // MARK: - Обновление профиля
    func updateProfile(userId: String, name: String, address: String, phone: String) async throws {
        try await db.collection("users").document(userId).updateData([
            "name": name,
            "address": address,
            "phone": phone
        ])
        // Обновляем локально
        appUser?.name = name
        appUser?.address = address
        appUser?.phone = phone
    }

    // MARK: - Выход
    func signOut() {
        authState = .signedOut
        appUser = nil
        errorMessage = nil
        UserDefaults.standard.removeObject(forKey: sessionKey)
        UserDefaults.standard.removeObject(forKey: passwordKey)
    }
}

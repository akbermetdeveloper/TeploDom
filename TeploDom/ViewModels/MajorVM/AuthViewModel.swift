import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: NSObject, ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var authState: AuthState = .enterAccountNumber

    enum AuthState {
           case enterAccountNumber
           case smsCodeSent
           case enterPassword
           case signedIn
           
           case signedOut
           case authenticated
           case profileComplete
       }
       

    private var db = Firestore.firestore()

    override init() {
        super.init()
    }

    /// Проверка лицевого счёта + пароля
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

            guard let doc = snapshot.documents.first else {
                errorMessage = "Лицевой счёт не найден"
                return false
            }

            let data = doc.data()

            guard let storedPassword = data["passwordHash"] as? String else {
                errorMessage = "Пароль не задан в системе"
                return false
            }

            if password == storedPassword {
                print("✅ Успешный вход: \(accountNumber)")
                authState = .signedIn
                isAuthenticated = true
                return true
            } else {
                errorMessage = "Неверный пароль"
                return false
            }

        } catch {
            errorMessage = "Ошибка Firestore: \(error.localizedDescription)"
            return false
        }
    }

    /// Выход
    func signOut() {
        isAuthenticated = false
        authState = .signedOut
        errorMessage = nil
        print("Пользователь вышел")
    }
}


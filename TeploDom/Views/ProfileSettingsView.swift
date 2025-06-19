////
////  ProfileSettingsView.swift
////  TeploDom
////
////  Created by Bema on 19/6/25.
////
//
//import Foundation
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct ProfileSettingsView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @State private var name: String = ""
//    @State private var address: String = ""
//    @State private var phone: String = ""
//    @State private var isSaving = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        Form {
//            Section(header: Text("Данные профиля")) {
//                TextField("Имя и фамилия", text: $name)
//                TextField("Адрес", text: $address)
//                TextField("Телефон", text: $phone)
//                    .keyboardType(.phonePad)
//            }
//
//            Section {
//                Button(action: saveProfile) {
//                    HStack {
//                        if isSaving { ProgressView().padding(.trailing, 8) }
//                        Text("Сохранить")
//                            .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                }
//                .disabled(isSaving || name.isEmpty || address.isEmpty || phone.isEmpty)
//            }
//        }
//        .navigationTitle("Профиль")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            // prefill fields from authViewModel
//            name = authViewModel.appUser?.name ?? ""
//            address = authViewModel.appUser?.address ?? ""
//            phone = authViewModel.appUser?.phone ?? ""
//        }
//        .alert("Ошибка", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {}
//        } message: {
//            Text(alertMessage)
//        }
//    }
//
//    private func saveProfile() {
//        guard let user = authViewModel.appUser else { return }
//        isSaving = true
//        Task {
//            do {
//                try await authViewModel.updateProfile(userId: user.id ?? "", name: name, address: address, phone: phone)
//                isSaving = false
//            } catch {
//                alertMessage = error.localizedDescription
//                showAlert = true
//                isSaving = false
//            }
//        }
//    }
//}
//
//@available(iOS 17.0, *)
//struct AppSettingsView: View {
//    @AppStorage("darkMode") private var darkMode = false
//    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
//
//    var body: some View {
//        Form {
//            Section(header: Text("Тема")) {
//                Toggle(isOn: $darkMode) {
//                    Label("Тёмная тема", systemImage: darkMode ? "moon.fill" : "sun.max")
//                }
//            }
//            Section(header: Text("Уведомления")) {
//                Toggle(isOn: $notificationsEnabled) {
//                    Label("Включить уведомления", systemImage: "bell.fill")
//                }
//                .onChange(of: notificationsEnabled) { value in
//                    // register/unregister notifications
//                }
//            }
//            Section(header: Text("О приложении")) {
//                HStack {
//                    Text("Версия")
//                    Spacer()
//                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")
//                }
//                Link(destination: URL(string: "https://github.com/your-repo")!) {
//                    Label("Исходный код", systemImage: "chevron.left.slash.chevron.right")
//                }
//            }
//        }
//        .navigationTitle("Параметры приложения")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}


import SwiftUI

@available(iOS 17.0, *)
struct ProfileSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Данные профиля")) {
                    TextField("Имя и фамилия", text: $name)
                    TextField("Адрес", text: $address)
                    TextField("Телефон", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section {
                    Button {
                        saveProfile()
                    } label: {
                        HStack {
                            if isSaving {
                                ProgressView().padding(.trailing, 8)
                            }
                            Text("Сохранить")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(isSaving || name.isEmpty || address.isEmpty || phone.isEmpty)
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                let user = authViewModel.appUser
                name = user?.name ?? ""
                address = user?.address ?? ""
                phone = user?.phone ?? ""
            }
            .alert("Ошибка", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func saveProfile() {
        guard let user = authViewModel.appUser else { return }
        isSaving = true
        Task {
            do {
                try await authViewModel.updateProfile(
                    userId: user.id ?? "",
                    name: name,
                    address: address,
                    phone: phone
                )
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
            isSaving = false
        }
    }
}

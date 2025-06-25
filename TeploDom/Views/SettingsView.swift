//import Foundation
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct SettingsView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @ObservedObject var viewModel: SettingsViewModel
//    @Binding var selectedTab: CustomTabBarView.Tab
//    @EnvironmentObject private var iapViewModel: IAPViewModel
//    @ObservedObject var subViewModel: SubViewModel
//
//    @State private var showLogoutAlert = false
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Аккаунт")) {
//                    HStack {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundStyle(Color.blue)
//                        VStack(alignment: .leading) {
//                            Text(authViewModel.currentAccountNumber ?? "Неизвестно")
//                                .font(.headline)
//                            Text("Семейный профиль")
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                }
//
//                Section(header: Text("Кошелёк")) {
//                    HStack {
//                        Text("Баланс" )
//                        Spacer()
//                        Text("\(ReadingsViewModel().pricePerUnit, specifier: "%.2f") сом")
//                            .foregroundStyle(.green)
//                            .font(.headline)
//                    }
//                    NavigationLink {
//                        PurchasesView()
//                    } label: {
//                        Text("Пополнить баланс")
//                    }
//                }
//
//                Section(header: Text("Настройки")) {
//                    NavigationLink {
//                        ProfileSettingsView()
//                    } label: {
//                        Label("Профиль", systemImage: "gearshape")
//                    }
//
//                    NavigationLink {
//                        AppSettingsView()
//                    } label: {
//                        Label("Параметры приложения", systemImage: "slider.horizontal.3")
//                    }
//                }
//
//                Section {
//                    Button(role: .destructive) {
//                        showLogoutAlert = true
//                    } label: {
//                        Label("Выйти", systemImage: "arrow.backward.circle")
//                    }
//                }
//            }
//            .navigationTitle("Настройки")
//            .navigationBarTitleDisplayMode(.inline)
//            .alert("Вы действительно хотите выйти?", isPresented: $showLogoutAlert) {
//                Button("Выйти", role: .destructive) {
//                    authViewModel.signOut()
//                }
//                Button("Отмена", role: .cancel) {}
//            }
//        }
//    }
//}
//

import SwiftUI

@available(iOS 17.0, *)
struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var selectedTab: CustomTabBarView.Tab
    @EnvironmentObject private var iapViewModel: IAPViewModel
    @ObservedObject var subViewModel: SubViewModel

    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Form {
                    // MARK: — Аккаунт
                    Section(header: Text("Аккаунт")) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                // Здесь мы читаем accountNumber из appUser, а не пытаемся привязать строку
                                Text(authViewModel.appUser?.accountNumber ?? "Неизвестно")
                                    .font(.headline)
                                
                                Text("Семейный профиль")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // MARK: — Кошелёк
                    Section(header: Text("Кошелёк")) {
                        HStack {
                            Text("Баланс")
                            Spacer()
                            //                        Text("\(iapViewModel.balance, specifier: \"%.2f\") сом")
                            //                            .font(.headline)
                            //                            .foregroundColor(.green)
                        }
                        
                        NavigationLink {
                            PurchasesView()
                        } label: {
                            Label("Пополнить баланс", systemImage: "creditcard.fill")
                        }
                    }
                    
                    // MARK: — Общие настройки
                    Section(header: Text("Настройки")) {
                        NavigationLink {
                            ProfileSettingsView()
                                .environmentObject(authViewModel)
                        } label: {
                            Label("Профиль", systemImage: "person.fill")
                        }
                        
                        NavigationLink {
                            // AppSettingsView()
                        } label: {
                            Label("Параметры приложения", systemImage: "slider.horizontal.3")
                        }
                    }
                    
                    // MARK: — Выход
                    Section {
                        Button(role: .destructive) {
                            showLogoutAlert = true
                        } label: {
                            Label("Выйти", systemImage: "arrow.backward.circle.fill")
                        }
                    }
                }
                //.scrollContentBackground(.hidden) 
                .background(Color.clear)
                .navigationTitle("Настройки")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Вы действительно хотите выйти?", isPresented: $showLogoutAlert) {
                    Button("Выйти", role: .destructive) {
                        authViewModel.signOut()
                    }
                    Button("Отмена", role: .cancel) { }
                }
            }
        }
    }
}

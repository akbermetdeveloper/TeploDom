//
//  MainView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation

//@available(iOS 17.0, *)
//struct MainView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    //@ObservedObject var viewModel: MainViewModel
//    @Binding var selectedTab: CustomTabBarView.Tab
//    @EnvironmentObject private var iapViewModel: IAPViewModel
//    @ObservedObject var subViewModel: SubViewModel
//    @State private var showSubview: Bool = false
//
//    @State private var showingAuthScreen = false
//    @State private var selectedAccount: String?
//    
//    @StateObject private var viewModel = MainViewModel()
//
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//               
//                VStack(spacing: 8) {
//                    Text("TeploDom")
//                        .font(.largeTitle.bold())
//                        .foregroundStyle(.blue)
//
//                    Text("Передавайте показания за себя и близких")
//                        .multilineTextAlignment(.center)
//                        .foregroundStyle(.secondary)
//                }
//                .padding(.top)
//
//      
//                if viewModel.savedAccounts.isEmpty {
//                    Spacer()
//                    Text("Нет добавленных аккаунтов")
//                        .foregroundStyle(.gray)
//                        .padding(.top, 50)
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(viewModel.savedAccounts, id: \.self) { account in
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Лицевой счёт")
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                    Text(account)
//                                        .font(.headline)
//                                }
//
//                                Spacer()
//
//                                Button {
//                                    selectedAccount = account
//                                    Task {
//                                        let success = await authViewModel.signIn(accountNumber: account, password: "1234")        //  ввод пароля
//                                        if success {
//                                            showingAuthScreen = true
//                                        }
//                                    }
//                                } label: {
//                                    Text("Войти")
//                                        .padding(.horizontal)
//                                        .padding(.vertical, 6)
//                                        .background(Color.blue)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(10)
//                                }
//
//                                Button(role: .destructive) {
//                                    viewModel.removeAccount(account)
//                                } label: {
//                                    Image(systemName: "trash")
//                                }
//                                .buttonStyle(.plain)
//                            }
//                            .padding(.vertical, 4)
//                        }
//                    }
//                    .listStyle(.plain)
//                }
//
//                Spacer()
//
//                
//                NavigationLink(destination: AuthView(onAuthSuccess: { account in
//                    viewModel.addAccount(account)
//                })) {
//                    Text("➕ Добавить новый аккаунт")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .padding(.bottom)
//            }
//            .padding()
//            .navigationDestination(isPresented: $showingAuthScreen) {
//                HomeView(selectedAccount: selectedAccount ?? "")
//            }
//        }
//    }
//}

struct MainView: View {
    
    @Binding var selectedTab: CustomTabBarView.Tab
    @ObservedObject var subViewModel: SubViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var viewModel = MainViewModel()
    
    @State private var showingAuthScreen = false
    @State private var selectedAccount: String?
    
    var body: some View {
        NavigationStack {
        ZStack {
            BackgroundView()
                .allowsHitTesting(false)
            VStack(alignment: .center, spacing: 16) {
                
                Text("Передавайте показания\nза себя и близких💧")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .font(.SFPro.regular18)
                    .lineLimit(2)
                    .padding(.top, 20)
                
                
                if viewModel.savedAccounts.isEmpty {
                    //Spacer()
                    Text("Нет добавленных аккаунтов")
                        .foregroundStyle(.gray)
                        .padding(.top, 20)
                    // Spacer()
                } else {
                    List {
                        ForEach(viewModel.savedAccounts, id: \.self) { account in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Лицевой счёт")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(account)
                                        .font(.headline)
                                }
                                
                                Spacer()
                                
                                Button {
                                    selectedAccount = account
                                    Task {
                                        let success = await authViewModel.signIn(accountNumber: account, password: "1234")
                                        if success {
                                            showingAuthScreen = true
                                        }
                                    }
                                } label: {
                                    Text("Войти")
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(role: .destructive) {
                                    viewModel.removeAccount(account)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: 250)
                }
                
                Spacer()
                
                
                Button {
                    showingAuthScreen = true
                } label: {
                    Text("➕ Добавить новый аккаунт")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#A6C549"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .top)
//            .navigationDestination(isPresented: $showingAuthScreen) {
//                HomeView(selectedAccount: selectedAccount ?? "")
//            }
        }
        .navigationDestination(isPresented: $showingAuthScreen) {
            AuthView(onAuthSuccess: { account in
                viewModel.addAccount(account)
            })
        }
        }
        
      
        }
    }


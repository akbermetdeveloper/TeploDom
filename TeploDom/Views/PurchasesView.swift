//
//  PurchasesView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct PurchasesView: View {
    @EnvironmentObject private var iapViewModel: IAPViewModel
    @State private var isLoading = false
    @State private var alertMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Пополнение баланса")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                //                Text("Текущий баланс: \(iapViewModel.balance, specifier: \"%.2f\") сом")
                //                    .font(.title3)
                //                    .foregroundColor(.green)
                
                //                if isLoading {
                //                    ProgressView()
                //                        .padding()
                //                } else {
                //                    List {
                //                        ForEach(iapViewModel.products, id: \.id) { product in
                //                            HStack {
                //                                VStack(alignment: .leading) {
                //                                    Text(product.displayName)
                //                                        .font(.headline)
                //                                    Text(product.displayPrice)
                //                                        .font(.subheadline)
                //                                        .foregroundColor(.secondary)
                //                                }
                //                                Spacer()
                //                                Button {
                //                                    Task {
                //                                        isLoading = true
                //                                        do {
                //                                            try await iapViewModel.purchase(product)
                //                                        } catch {
                //                                            alertMessage = "Покупка не удалась: \(error.localizedDescription)"
                //                                        }
                //                                        isLoading = false
                //                                    }
                //                                } label: {
                //                                    Text("Купить")
                //                                        .padding(.horizontal)
                //                                        .padding(.vertical, 6)
                //                                        .background(Color.blue)
                //                                        .foregroundColor(.white)
                //                                        .cornerRadius(8)
                //                                }
                //                                .disabled(isLoading)
                //                            }
                //                            .padding(.vertical, 8)
                //                        }
                //                    }
                //                    .listStyle(.plain)
                //                }
                //
                //                Spacer()
                //
                ////                Button("Восстановить платежи") {
                ////                    Task {
                ////                        isLoading = true
                ////                        do {
                ////                            try await iapViewModel.restorePurchases()
                ////                        } catch {
                ////                            alertMessage = "Восстановление не удалось: \(error.localizedDescription)"
                ////                        }
                ////                        isLoading = false
                ////                    }
                ////                }
                ////                .padding()
                ////                .frame(maxWidth: .infinity)
                ////                .background(Color.gray.opacity(0.2))
                ////                .cornerRadius(12)
                ////                .disabled(isLoading)
                ////                .padding(.horizontal)
                //            }
                //            .padding(.horizontal)
                //            .navigationTitle("Платежи")
                //            .navigationBarTitleDisplayMode(.inline)
                //            .onAppear {
                //                Task {
                //                    isLoading = true
                //                    await ReadingsViewModel().meters
                //                    isLoading = false
                //                }
                //            }
                //            .alert(item: $alertMessage) { msg in
                //                Alert(title: Text("Ошибка"), message: Text(msg), dismissButton: .default(Text("OK")))
                //            }
                //        }
                //    }
            }
        }
    }
}

// Для Alert на основе строки
extension String: Identifiable {
    public var id: String { self }
}

import SwiftUI
import StoreKit

@available(iOS 17.0, *)
struct PurchasesView: View {
    @EnvironmentObject private var iapViewModel: IAPViewModel
    @State private var isLoading = false
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var alertMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Пополнение баланса")
                    .font(.largeTitle.bold())
                    .padding(.top)

                Text("\(viewModel.readings.endIndex, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundColor(.green)

                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    List(iapViewModel.products, id: \.id) { product in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .font(.headline)
                                Text(product.displayPrice)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Купить") {
                                Task {
                                    isLoading = true
                                    do {
                                        try await iapViewModel.purchase(product)
                                    } catch {
                                        alertMessage = "Покупка не удалась: \(error.localizedDescription)"
                                    }
                                    isLoading = false
                                }
                            }
                            .disabled(isLoading)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.plain)
                }

                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Платежи")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    isLoading = true
                    await iapViewModel.loadProducts()
                    isLoading = false
                }
            }
            .alert(item: $alertMessage) { msg in
                Alert(title: Text("Ошибка"), message: Text(msg), dismissButton: .default(Text("OK")))
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}


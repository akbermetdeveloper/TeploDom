//
//  ConsumptionsView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation


@available(iOS 17.0, *)
struct ConsumptionsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ConsumptionViewModel
    @Binding var selectedTab: CustomTabBarView.Tab
    @EnvironmentObject private var iapViewModel: IAPViewModel
    @ObservedObject var subViewModel: SubViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Мои расходы")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    if viewModel.meterConsumptions.isEmpty {
                        Text("Нет данных по расходам")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        ForEach(viewModel.meterConsumptions) { consumption in
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 4)

                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(consumption.location.capitalized)
                                                .font(.title3.bold())
                                            Text("Счетчик: \(consumption.meterId)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text(consumption.type == "hot_water" ? "Гор. вода" : consumption.type.capitalized)
                                            .font(.caption2.bold())
                                            .padding(6)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }

                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Предыдущее")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text(String(format: "%.1f м³", consumption.previousValue))
                                                .font(.headline)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Текущее")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text(String(format: "%.1f м³", consumption.currentValue))
                                                .font(.headline)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Расход")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text(String(format: "%.1f м³", consumption.consumed))
                                                .font(.headline)
                                        }
                                    }

                                    Divider()

                                    HStack {
                                        Text("Итого к оплате")
                                            .font(.subheadline)
                                        Spacer()
                                        Text(String(format: "%.2f сом", consumption.totalCost))
                                            .font(.title3.bold())
                                            .foregroundStyle(.green)
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Мои расходы")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
//                Task {
//                    if let userId = authViewModel.currentAccountNumber {
//                        await viewModel.loadAllData(for: userId)
//                    }
//                }
            }
        }
    }
}

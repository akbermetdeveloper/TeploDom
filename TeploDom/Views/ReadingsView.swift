//
//  ReadingsView.swift
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
struct ReadingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ReadingsViewModel
    @Binding var selectedTab: CustomTabBarView.Tab
    @ObservedObject var subViewModel: SubViewModel
    @EnvironmentObject private var iapViewModel: IAPViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                BackgroundView()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Показания и расходы")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    if viewModel.readingsByMeter.isEmpty {
                        Text("Нет данных о показаниях.")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        ForEach(viewModel.readingsByMeter.keys.sorted(), id: \.self) { meterId in
                            if let readings = viewModel.readingsByMeter[meterId],
                               let meter = viewModel.meters.first(where: { $0.id == meterId }),
                               let last = readings.last,
                               let previous = readings.dropLast().last {
                                
                                let consumed = last.value - previous.value
                                let amount = consumed * viewModel.pricePerUnit
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(meter.location.capitalized)
                                            .font(.title2.bold())
                                        Spacer()
                                        Text("№ \(meter.serialNumber)")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }

                                    Text("Последнее показание: \(last.value, specifier: "%.1f") м³")
                                    Text("Потреблено: \(consumed, specifier: "%.1f") м³")
                                    Text("Итого: \(amount, specifier: "%.2f") сом")
                                        .foregroundColor(.green)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Мои расходы")
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

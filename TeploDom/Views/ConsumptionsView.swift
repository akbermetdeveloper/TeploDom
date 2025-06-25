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
    @EnvironmentObject var authVM: AuthViewModel

    @ObservedObject var viewModel: ReadingsViewModel
    @ObservedObject var meterVM: MetersViewModel
    @Binding var selectedTab: CustomTabBarView.Tab
    @EnvironmentObject private var iapViewModel: IAPViewModel
    @ObservedObject var subViewModel: SubViewModel
    
    @State private var location: String = ""
    
    @State private var value: String = ""
    
    @State private var accountNumber: String = ""
    
    @State private var datee: String = ""
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()

    var body: some View {
        
        let meter = authVM.meter
        let location = meter?.location ?? "Неизвестно"

        let readingg = authVM.reading
        let value = readingg?.valueDouble ?? 0.0

        let datee = readingg?.date ?? Date()

        let user = authVM.appUser
        let accountNumber = user?.accountNumber ?? "Нет счета"
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Мои расходы")
                            .font(.SFPro.semiBold20)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top)
                        
                        LazyVStack {
                        
                            
                                VStack(alignment: .leading) {
                                    Text("Лицевой счет: \(accountNumber)")
                                        .font(.SFPro.semiBold20)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Text("Значение: \(value, specifier: "%.2f")")
                                        .font(.SFPro.semiBold20)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Text("Дата: \(datee, formatter: dateFormatter)")
                                        .font(.SFPro.semiBold20)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                }
                                
                            
                        }
                        
//                        if viewModel.readingsByMeter.isEmpty {
//                            Text("Нет данных по расходам")
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, minHeight: 200)
//                        } else {
//                            ForEach(viewModel.readingsByMeter.values.flatMap { $0 }) { consumption in
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .fill(.ultraThinMaterial)
//                                        .shadow(radius: 4)
//                                    
//                                    VStack(alignment: .leading, spacing: 12) {
//                                        HStack {
//                                            VStack(alignment: .leading, spacing: 4) {
////                                                Text(meterVM.location.capitalized)
////                                                    .font(.title3.bold())
//                                                
//                                                
//                                                Text("Счетчик: \(consumption.meterId)")
//                                                    .font(.caption)
//                                                    .foregroundColor(.secondary)
//                                            }
//                                            Spacer()
//                                            Text(consumption.type == "hot_water" ? "Гор. вода" : consumption.type.capitalized)
//                                                .font(.caption2.bold())
//                                                .padding(6)
//                                                .background(Color.blue.opacity(0.2))
//                                                .cornerRadius(8)
//                                        }
//                                        
//                                        HStack(spacing: 16) {
//                                            VStack(alignment: .leading, spacing: 4) {
//                                                Text("Предыдущее")
//                                                    .font(.caption2)
//                                                    .foregroundColor(.secondary)
//                                                Text(String(format: "%.1f м³", consumption.previousValue))
//                                                    .font(.headline)
//                                            }
//                                            VStack(alignment: .leading, spacing: 4) {
//                                                Text("Текущее")
//                                                    .font(.caption2)
//                                                    .foregroundColor(.secondary)
//                                                Text(String(format: "%.1f м³", consumption.currentValue))
//                                                    .font(.headline)
//                                            }
//                                            VStack(alignment: .leading, spacing: 4) {
//                                                Text("Расход")
//                                                    .font(.caption2)
//                                                    .foregroundColor(.secondary)
//                                                Text(String(format: "%.1f м³", consumption.consumed))
//                                                    .font(.headline)
//                                            }
//                                        }
//                                        
//                                        Divider()
//                                        
//                                        HStack {
//                                            Text("Итого к оплате")
//                                                .font(.subheadline)
//                                            Spacer()
//                                            Text(String(format: "%.2f сом", consumption.totalCost))
//                                                .font(.title3.bold())
//                                                .foregroundStyle(.green)
//                                        }
//                                    }
//                                    .padding()
//                                }
//                                .padding(.horizontal)
//                            }
//                        }
                    }
                    .padding(.bottom, 40)
                }
                .background(Color.clear)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    Task {
                        await authVM.fetchReadings()
                    }
                }
                
                
            }
        }
    }
}

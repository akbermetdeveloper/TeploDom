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
            ZStack {
                BackgroundView()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Показания и расходы")
                            .font(.SFPro.bold24)
                            .foregroundColor(.white)
                            .padding(.top)
                        
//                        ForEach(viewModel.meters) { meter in
//                            if let readings = viewModel.readingsByMeter[meter.id ?? ""] {
//                                VStack(alignment: .leading) {
//                                    Text("Счётчик: \(meter.location.capitalized) №\(meter.serialNumber)")
//                                        .font(.headline)
//
//                                    ForEach(readings) { reading in
//                                        Text("\(reading.date.formatted(date: .abbreviated, time: .shortened)) — \(reading.valueDouble, specifier: "%.1f") м³")
//                                    }
//                                }
//                                .padding()
//                            }
//                        }
                        
//                        for reading in allReadings {
//                            print("Reading: meterId=\(reading.meterId), valueString=\(reading.valueString), date=\(reading.date)")
//                        }



                        if viewModel.readingsByMeter.isEmpty {
                            Text("Нет данных о показаниях.")
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        } else {
                            ForEach(viewModel.meters) { meter in
                                if let readings = viewModel.readingsByMeter[meter.id ?? ""] {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(meter.location.capitalized)
                                                .font(.headline)
                                            Spacer()
                                            Text("№ \(meter.serialNumber)")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                        
                                       



                                        if readings.count >= 2 {
                                            let last = readings.last!
                                            let previous = readings[readings.count - 2]
                                            let consumed = last.valueDouble - previous.valueDouble
                                            
                                            

                                            let amount = consumed * viewModel.pricePerUnit

                                            Text("Последнее показание: \(last.valueDouble, specifier: "%.1f") м³")
                                            Text("Потреблено: \(consumed, specifier: "%.1f") м³")
                                            Text("Итого: \(amount, specifier: "%.2f") сом")
                                                .foregroundColor(.green)
                                                .fontWeight(.semibold)
                                        } else {
                                            Text("Потреблено: \(45, specifier: "%.1f") м³")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6).opacity(0.3))
                                    .cornerRadius(12)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            .task {
                if let userId = authViewModel.appUser?.id {
                    await viewModel.loadAllData(for: userId)
                }
            }
        }
    }
}


//@available(iOS 17.0, *)
//struct ReadingsView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @ObservedObject var viewModel: ReadingsViewModel
//    @Binding var selectedTab: CustomTabBarView.Tab
//    @ObservedObject var subViewModel: SubViewModel
//    @EnvironmentObject private var iapViewModel: IAPViewModel
//    
//    @State private var location: String = ""
//    @State private var serialNumber: String = ""
//    //@State private var accountNumber: String = ""
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                BackgroundView()
//                
//                ScrollView {
//                    
//                    VStack(alignment: .leading, spacing: 20) {
//                        Text("Показания и расходы")
//                            .font(.SFPro.semiBold20)
//                            .foregroundColor(.white)
//                            .padding(.top)
//                        
//                        
//                        
////                        if viewModel.readingsByMeter.isEmpty {
////                            Text("Нет данных о показаниях.")
////                                .foregroundColor(.gray)
////                                .padding(.top, 50)
////                        } else {
////                            ForEach(viewModel.readingsByMeter.keys.sorted(), id: \.self) { meterId in
////                                if let readings = viewModel.readingsByMeter[meterId],
////                                   let meter = viewModel.meters.first(where: { $0.id == meterId }),
////                                   let last = readings.last,
////                                   let previous = readings.dropLast().last {
////                                    
////                                    let consumed = last.value - previous.value
////                                    let amount = consumed * viewModel.pricePerUnit
////                                    
////                                    VStack(alignment: .leading, spacing: 8) {
////                                        HStack {
////                                            Text(meter.location.capitalized)
////                                                .font(.title2.bold())
////                                            Spacer()
////                                            Text("№ \(meter.serialNumber)")
////                                                .foregroundColor(.secondary)
////                                                .font(.caption)
////                                        }
////                                        
////                                        Text("Последнее показание: \(last.value, specifier: "%.1f") м³")
////                                        Text("Потреблено: \(consumed, specifier: "%.1f") м³")
////                                        Text("Итого: \(amount, specifier: "%.2f") сом")
////                                            .foregroundColor(.green)
////                                            .fontWeight(.semibold)
////                                    }
////                                    .padding()
////                                    .background(Color(.systemGray6))
////                                    .cornerRadius(12)
////                                }
////                            }
////                        }
//                    }
//                    .padding()
//                }
//                
//                .onAppear {
//                    let meter = authViewModel.meter
//                    serialNumber = meter?.serialNumber ?? ""
//                    location = meter?.location ?? ""
//                }
//            }
//        }
//    }
//}

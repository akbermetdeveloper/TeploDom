//
//  ReadingsViewModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import FirebaseFirestore

//@MainActor
//class ReadingsViewModel: ObservableObject {
//    @Published var meters: [Meter] = []
//    @Published var readingsByMeter: [String: [Reading]] = [:]
//    @Published var pricePerUnit: Double = 0.0
//
//    private let db = Firestore.firestore()
//
//    func loadAllData(for userId: String) async {
//        do {
//            // Загрузка счетчиков
//            let meterSnapshot = try await db.collection("meters").whereField("userId", isEqualTo: userId).getDocuments()
//            self.meters = meterSnapshot.documents.compactMap { try? $0.data(as: Meter.self) }
//
//            // Загрузка показаний
//            let readingSnapshot = try await db.collection("readings").getDocuments()
//            let allReadings = readingSnapshot.documents.compactMap { try? $0.data(as: Reading.self) }
//
//            var map: [String: [Reading]] = [:]
//            for meter in meters {
//                guard let meterId = meter.id else { continue }
//                let readings = allReadings
//                    .filter { $0.meterId == meterId }
//                    .sorted(by: { $0.date < $1.date })
//                map[meterId] = readings
//            }
//            self.readingsByMeter = map
//
//            // Тариф
//            let tariffSnapshot = try await db.collection("tariffs").document("current").getDocument()
//            if let data = tariffSnapshot.data(),
//               let price = data["pricePerUnit"] as? Double {
//                self.pricePerUnit = price
//            }
//        } catch {
//            print("Ошибка загрузки данных: \(error)")
//        }
//    }
//}
//

@MainActor
class ReadingsViewModel: ObservableObject {
    @Published var meters: [Meter] = []
    @Published var readingsByMeter: [String: [Reading]] = [:]
    @Published var pricePerUnit: Double = 0.0

    private let db = Firestore.firestore()

    func loadAllData(for userId: String) async {
        do {
            let meterSnapshot = try await db.collection("meters").whereField("userId", isEqualTo: userId).getDocuments()
            self.meters = meterSnapshot.documents.compactMap { try? $0.data(as: Meter.self) }

            let readingSnapshot = try await db.collection("readings").getDocuments()
            let allReadings = readingSnapshot.documents.compactMap { try? $0.data(as: Reading.self) }

            var map: [String: [Reading]] = [:]

            for meter in meters {
                guard let meterId = meter.id else { continue }
                
                let readingSnapshot = try await db.collection("readings")
                    .whereField("meterId", isEqualTo: meterId)
                    .getDocuments()
                
                let readings = readingSnapshot.documents.compactMap { try? $0.data(as: Reading.self) }
                map[meterId] = readings.sorted(by: { $0.date < $1.date })
            }

            self.readingsByMeter = map


            let tariffSnapshot = try await db.collection("tariffs").document("current").getDocument()
            if let data = tariffSnapshot.data(),
               let price = data["pricePerUnit"] as? Double {
                self.pricePerUnit = price
            }
            print("Loaded readings count: \(allReadings.count)")

        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
}

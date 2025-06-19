//
//  ReadingsViewModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import FirebaseFirestore

@MainActor
class ReadingsViewModel: ObservableObject {
    @Published var meters: [Meter] = []
    @Published var readingsByMeter: [String: [Reading]] = [:]
    @Published var pricePerUnit: Double = 0.0

    private let db = Firestore.firestore()

    func loadAllData(for userId: String) async {
        do {
            // Загрузка счетчиков
            let meterSnapshot = try await db.collection("meters").whereField("userId", isEqualTo: userId).getDocuments()
            self.meters = meterSnapshot.documents.compactMap { try? $0.data(as: Meter.self) }

            // Загрузка показаний
            let readingSnapshot = try await db.collection("readings").getDocuments()
            let allReadings = readingSnapshot.documents.compactMap { try? $0.data(as: Reading.self) }

            var map: [String: [Reading]] = [:]
            for meter in meters {
                let readings = allReadings
                    .filter { $0.meterId == meter.id }
                    .sorted(by: { $0.date < $1.date })
                map[meter.id ?? ""] = readings
            }
            self.readingsByMeter = map

            // Тариф
            let tariffSnapshot = try await db.collection("tariffs").document("current").getDocument()
            if let data = tariffSnapshot.data(),
               let price = data["pricePerUnit"] as? Double {
                self.pricePerUnit = price
            }
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
}


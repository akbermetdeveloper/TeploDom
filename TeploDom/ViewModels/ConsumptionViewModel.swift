import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct MeterConsumption: Identifiable {
    var id: String { meterId }
    let meterId: String
    let location: String
    let type: String
    let previousValue: Double
    let currentValue: Double
    var consumed: Double { max(currentValue - previousValue, 0) }
    var totalCost: Double { consumed * pricePerUnit }
    // Тариф за единицу
    let pricePerUnit: Double
}

@MainActor
final class ConsumptionViewModel: NSObject, ObservableObject {
    @Published var meterConsumptions: [MeterConsumption] = []
    
    private let db = Firestore.firestore()
    private var pricePerUnit: Double = 0.0
    
    /// Загружает расходы по всем счетчикам для заданного пользователя
    /// - Parameter userId: идентификатор пользователя (accountNumber или id)
    func loadAllData(for userId: String) async {
        do {
            // 1. Загрузка тарифа
            let tariffDoc = try await db.collection("tariffs").document("current").getDocument()
            if let data = tariffDoc.data(), let price = data["pricePerUnit"] as? Double {
                pricePerUnit = price
            }
            
            // 2. Загрузка счетчиков пользователя
            let meterSnapshot = try await db.collection("meters")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            let meters = meterSnapshot.documents.compactMap { try? $0.data(as: Meter.self) }
            
            var results: [MeterConsumption] = []
            
            // 3. Для каждого счетчика загружаем последние два показания
            for meter in meters {
                guard let meterId = meter.id else { continue }
                let readingSnap = try await db.collection("readings")
                    .whereField("meterId", isEqualTo: meterId)
                    .order(by: "date", descending: true)
                    .limit(to: 2)
                    .getDocuments()

                let readings = readingSnap.documents.compactMap { try? $0.data(as: Reading.self) }
                    .sorted(by: { $0.date < $1.date })

                if readings.count >= 2 {
                    let first = readings[0]
                    let last = readings[1]
                    let consumption = MeterConsumption(
                        meterId: meterId,
                        location: meter.location,
                        type: meter.type,
                        previousValue: first.value,
                        currentValue: last.value,
                        pricePerUnit: pricePerUnit
                    )
                    results.append(consumption)
                }
            }
            
            // Обновляем данные
            self.meterConsumptions = results
        } catch {
            print("Error loading consumption data: \(error)")
            self.meterConsumptions = []
        }
    }
}

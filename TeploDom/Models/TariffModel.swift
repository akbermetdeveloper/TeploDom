//
//  TariffModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Tariff: Identifiable, Codable {
    @DocumentID var id: String?
    var pricePerUnit: Double
}

//
//  MeterModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Meter: Identifiable, Codable {
    @DocumentID var id: String?
    var location: String
    var serialNumber: String
    var type: String  // "hot_water"
    var userId: String
}

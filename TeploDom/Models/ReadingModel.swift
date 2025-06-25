//
//  ReadingModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Reading: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var meterId: String
    var valueString: String  // внутреннее имя
    
    enum CodingKeys: String, CodingKey {
        case id
        case meterId
        case date
        case valueString = "value"  // map JSON "value" -> valueString
    }
    
    var valueDouble: Double {
        Double(valueString) ?? 0.0
    }
    
    
}

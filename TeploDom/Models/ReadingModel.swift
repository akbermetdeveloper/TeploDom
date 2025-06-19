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
    var value: Double
}

//
//  UserModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//
import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var accountNumber: String
    var address: String
    var name: String
    var passwordHash: String
    var phone: String
}

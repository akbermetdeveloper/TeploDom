//
//  Balloon.swift
//  TeploDom
//
//  Created by Bema on 18/6/25.
//

import Foundation
import SwiftUI


struct Balloon: Identifiable {
    let id = UUID()
    let imageName: String
    let radius: CGFloat
    //let size: CGSize
    let startAngle: Double
    let duration: Double
}

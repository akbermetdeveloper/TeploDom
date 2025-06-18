//
//  SplashScreenView.swift
//  TeploDom
//
//  Created by Bema on 18/6/25.
//

import Foundation
import SwiftUI


struct SplashScreenView: View {
    @ObservedObject var subViewModel: SubViewModel
    @EnvironmentObject private var iapViewModel: IAPViewModel
    
    @State private var isActive = false
    @State private var didAnimate = false
    @State private var isVisible = false
    
    let balloons: [Balloon] = [
        Balloon(imageName: "1Balloon", radius: 180, startAngle: 0, duration: 12),
        Balloon(imageName: "2Balloon", radius: 200, startAngle: 0.8, duration: 10),
        Balloon(imageName: "3Balloon", radius: 160, startAngle: 1.6, duration: 14),
        Balloon(imageName: "4Balloon", radius: 190, startAngle: 2.4, duration: 11),
        Balloon(imageName: "5Balloon", radius: 210, startAngle: 3.2, duration: 13),
        Balloon(imageName: "6Balloon", radius: 170, startAngle: 4.0, duration: 15),
        Balloon(imageName: "7Balloon", radius: 200, startAngle: 4.8, duration: 9),
        Balloon(imageName: "8Balloon", radius: 185, startAngle: 5.6, duration: 12)
    ]
    
    let balloonSizes: [CGFloat] = [146, 170, 101, 30]
    
    
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                BackgroundView()
                
                ForEach(balloons.prefix(7)) { balloon in
                    ForEach(0..<balloonSizes.count, id: \.self) { index in
                        RotatingBalloon(
                            balloon: balloon,
                            size: balloonSizes[index],
                            delay: Double(index) * 0.5,
                            screenSize: geo.size
                        )
                    }
                }
                
                
                VStack {
                    
                    Image("Frame3")
                        .resizable()
                        .scaledToFit()
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeIn(duration: 5.0), value: isVisible)
                        .onAppear {
                            isVisible = true
                        }
                        .frame(width: 200, height: 200)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
                
            }
        }
    }
}

struct RotatingBalloon: View {
    let balloon: Balloon
    let size: CGFloat
    let delay: Double
    let screenSize: CGSize

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let progress = time.truncatingRemainder(dividingBy: balloon.duration) / balloon.duration
            let angle = 2 * .pi * progress + balloon.startAngle
            
            let centerX = screenSize.width / 2
            let centerY = screenSize.height / 2
            
            let expandedRadius = balloon.radius * 1.3
            
            let x = screenSize.width / 2 + cos(angle) * expandedRadius
            let y = screenSize.height / 2 + sin(angle) * expandedRadius

            let opacity = 0.5 + 0.5 * cos(2 * .pi * progress)
            
            Image(balloon.imageName)
                .resizable()
                .scaledToFit()
                .scaleEffect(0.7)
                .frame(width: size, height: size)
                .position(x: x, y: y)
               
        }
    }
}




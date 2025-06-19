//
//  CustomSlideView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import MapKit

enum SheetState {
  case navigationBar
  case partial
  case full

  var yOffset: CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    switch self {
    case .navigationBar:
      return screenHeight * 0.84
    case .partial:
      return screenHeight * 0.47
    case .full:
      return screenHeight * 0.175
    }
  }

  var bottomPadding: CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    switch self {
    case .navigationBar:
      return screenHeight * 0.0
    case .partial:
      return screenHeight * 0.6
    case .full:
      return screenHeight * 0.31
    }
  }
  
}

struct CustomSlideView<Content: View>: View {
    //@Binding var state: SheetState
    var dragEnabled: Bool
    @GestureState private var dragOffset: CGFloat = 0
    let content: () -> Content

    
    private let dragThreshold: CGFloat = 30.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if dragEnabled {
                    
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(hex: "#A6C549"))
                        .frame(width: 36, height: 6)
                        .padding(.top, 8)
                } else {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(hex: "#A6C549"))
                        .frame(width: 36, height: 6)
                        .padding(.top, 8)
                }
                
                
                content()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color(hex: "#1E2E3F")
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .opacity(1.2)
                }
                    .blur(radius: 0.5)
            )
            
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .shadow(
                color: Color.white.opacity(0.1),
                radius: 64,
                x: 0,
                y: 0
            )
//            .position(x: geometry.size.width / 2,
//                      y: state.yOffset + dragOffset + geometry.size.height / 2)
//            .gesture(
//                dragEnabled ? createDragGesture() : nil
//            )
        }
        .ignoresSafeArea()
    }

    

//    private func createDragGesture() -> some Gesture {
//        DragGesture()
//            .updating($dragOffset) { value, state, _ in
//                state = value.translation.height
//            }
//            .onEnded { value in
//                let velocity = value.predictedEndLocation.y - value.location.y
//                if abs(velocity) > 100 {
//                    if velocity > 0 {
//                        moveDown()
//                    } else {
//                        moveUp()
//                    }
//                } else {
//                    let height = value.translation.height
//                    if height > dragThreshold {
//                        moveDown()
//                    } else if height < -dragThreshold {
//                        moveUp()
//                    }
//                }
//            }
//    }

//    private func moveUp() {
//        switch state {
//        case .navigationBar: state = .partial
//        case .partial: state = .full
//        case .full: state = .full
//        }
//    }
//
//    private func moveDown() {
//        switch state {
//        case .full: state = .partial
//        case .partial: state = .navigationBar
//        case .navigationBar: state = .navigationBar
//        }
//    }
}


extension SheetState {
  func next() -> SheetState {
    switch self {
    case .full: return .partial
    case .partial: return .navigationBar
    case .navigationBar: return .navigationBar
    }
  }

  func previous() -> SheetState {
    switch self {
    case .navigationBar: return .partial
    case .partial: return .full
    case .full: return .full
    }
  }
}


extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

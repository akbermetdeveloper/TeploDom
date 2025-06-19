//
//  OnboardingViews.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI


struct OneOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack {
                Image("1Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
            } .frame(maxHeight: .infinity, alignment: .top)
        }, backgroundImageName: "map bg")
    }
}

struct TwoOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack {
                Image("2Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
            } .frame(maxHeight: .infinity, alignment: .top)
        }, backgroundImageName: "map bg")
    }
}




struct ThreeOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack {
                Image("3Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 70)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
            } .frame(maxHeight: .infinity, alignment: .top)
                .padding(.leading, -70)
        }, backgroundImageName: "map bg")
    }
    
}

#Preview("Onboarding View 3 Preview") {
    ThreeOnboardingView()
}


struct FourOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack() {
                Image("4Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 70)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                    
            } .frame(maxHeight: .infinity, alignment: .top)
                .padding(.trailing, -90)
        }, backgroundImageName: "map bg")
    }
}

#Preview("Onboarding View 4 Preview") {
    FourOnboardingView()
}


struct FiveOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack {
                Image("5Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
            } .frame(maxHeight: .infinity, alignment: .top)
        }, backgroundImageName: "map bg")
    }
}

#Preview("Onboarding View 5 Preview") {
    FiveOnboardingView()
}


struct PaywallOnboardingView: View {
    var body: some View {
        BackgroundWrapperView(content: {
            VStack {
                Image("6Onb")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
            } .frame(maxHeight: .infinity, alignment: .top)
        }, backgroundImageName: "map bg")
    }
}

#Preview("Onboarding View 6 (Special) Preview") {
    PaywallOnboardingView()
}

//struct SevenOnboardingView: View {
//    var body: some View {
//        BackgroundWrapperView(content: {
//            VStack {
//                Image("6Onb")
//                    .resizable()
//                    .scaledToFit()
//                    .padding(.horizontal, 30)
//                    .frame(height: UIScreen.main.bounds.height * 0.7)
//            } .frame(maxHeight: .infinity, alignment: .top)
//        }, backgroundImageName: "map bg")
//    }
//}
//
//#Preview("Onboarding View 7 (Special) Preview") {
//    SevenOnboardingView()
//}

struct BackgroundWrapperView<Content: View>: View {
    let content: () -> Content
    let backgroundImageName: String

    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            content()
        }
    }
}

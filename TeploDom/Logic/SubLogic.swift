//
//  SubLogic.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import StoreKit

struct PageItem {
    let title: String
    let description: String
    let descriptionAction: String?
    let backgroundView: AnyView
}


struct SubLogic {
    
    let pageItems: [PageItem]

    
    private let specialItem: PageItem

    
    private(set) var currentPage = 0
    private(set) var currentItem: PageItem

    
    private(set) var isLastPageItem = false

    
    init(isSpecial: Bool = false) {
        
        self.pageItems = SubLogic.getAllItems()

        
        self.specialItem = self.pageItems.last!

        
        if isSpecial {
            self.currentPage = pageItems.count - 1
            self.currentItem = specialItem
            self.isLastPageItem = true
        } else {
            self.currentPage = 0
            self.currentItem = pageItems[0]
            self.isLastPageItem = false
        }
    }
    
    
    
    
    
    private static func getAllItems() -> [PageItem] {
        let first = PageItem(
            title: "Keep Your Loved\nOnes Within Reach",
            description: "No worrying about your family’s location—stay\nconnected anytime. With App Name, you’ll\nalways have peace of mind and safe.",
            descriptionAction: nil,
            backgroundView: AnyView(OneOnboardingView())
        )
        let second = PageItem(
            title: "Stay Notified About Your\nFamily & Friends",
            description: "Get instant alerts when your loved ones arrive\nor leave a set location, making it easy to stay in\ntouch and keep them safe.",
            descriptionAction: nil,
            backgroundView: AnyView(TwoOnboardingView())
        )
        let third = PageItem(
            title: "Organize Your\nCircles Your Way",
            description: "Create a “My People” list tailored for family,\nfriends, or teams. Add as many members as\nneeded to keep everyone connected.",
            descriptionAction: nil,
            backgroundView: AnyView(ThreeOnboardingView())
        )
        let fourth = PageItem(
            title: "Keep Track of Your Kids\nwith Kids Mode",
            description: "With App Name, you can monitor your\nchildren's in real-time, ensuring they’re always\nin a safe and protected space.",
            descriptionAction: nil,
            backgroundView: AnyView(FourOnboardingView())
        )
        let fifth = PageItem(
            title: "Send an SOS and\nGet Help Instantly",
            description: "Alert those around you in real time, keeping\nyou connected and safe no matter where you\nare or what situation you’re in.",
            descriptionAction: nil,
            backgroundView: AnyView(FiveOnboardingView())
        )
        
        let sixth = PageItem(
            title: "Unlock All Features for\nthe Best Experience",
            description: " Enjoy full access to premium features and\nenhance your experience for just $8.99 per\nweek,",
            descriptionAction: "or try the free limited version",
            backgroundView: AnyView(PaywallOnboardingView())
        )
        
//        let seventh = PageItem(
//            title: "Unlock All Features for\nthe Best Experience",
//            description: "Enjoy unlimited access to all premium features\nfree for 3 days. Subscribe just for $8.99 per\nweek, or try the free limited version.", descriptionAction: "",
//            backgroundView: AnyView(SevenOnboardingView())
//
//        )

        return [first, second, third, fourth, fifth, sixth]
    }

    
    mutating func switchToNextPageItem() {
        guard currentPage < pageItems.count - 1 else { return }
        currentPage += 1
        currentItem = pageItems[currentPage]
        
        if currentPage == pageItems.count - 1 {
            isLastPageItem = true
        }
        
        if currentPage == 3 {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    
    mutating func switchToLastPage(isSpecial: Bool = false) {
        currentPage = pageItems.count - 1
        if isSpecial {
            
            currentItem = specialItem
        } else {
            currentItem = pageItems.last!
        }
        isLastPageItem = true
    }
}

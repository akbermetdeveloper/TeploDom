//
//  SubViewModel.swift
//  TeploDom
//
//  Created by Bema on 18/6/25.
//

import Foundation
import SwiftUI
import StoreKit
import UserNotifications
import CoreLocation

class SubViewModel: ObservableObject {
    
    @Published var isSpecial: Bool = false
    
    
    @Published private(set) var subLogic: SubLogic
    //    @Published var isTrialEnabled: Bool = true {
    //        didSet {
    //
    //            if !isTrialEnabled {
    //                selectedProduct = selectedProduct.opposite
    //            }
    //        }
    //    }
    //
    ////    @Published var selectedProduct: ProductType = .featureWeeklyTrial
    ////    @Published var selectedText: ProductType = .featureWeeklyTrial
    //
    //
    //    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    //
    //
    var isLastPage: Bool {
        subLogic.isLastPageItem
    }
    
    
    var currentItem: PageItem {
        subLogic.currentItem
    }
    //    var currentPage: Int {
    //        subLogic.currentPage
    //    }
    //
    init() {
        
        let placeholderSubLogic = SubLogic()
        self.subLogic = placeholderSubLogic
    }
    
    func switchToNextPage() {
        subLogic.switchToNextPageItem()
        objectWillChange.send()
    }
}
//
//    
//    func switchToLastPage() {
//        subLogic.switchToLastPage(isSpecial: true)
//        objectWillChange.send()
//    }
//
//    
//    func selectPeriod(_ period: String) {
//        switch period {
//        case "Month":
//            selectedProduct = isTrialEnabled ? .featureMonthlyTrial : .featureMonthly
//        case "Year":
//            selectedProduct = isTrialEnabled ? .featureYearlyTrial : .featureYearly
//        case "Week":
//            selectedProduct = isTrialEnabled ? .featureWeeklyTrial : .featureWeekly
//        default:
//            selectedProduct = .featureWeeklyTrial
//        }
//    }
//
//    
//    func updateTrialState(_ newVal: Bool, for period: String) {
//        isTrialEnabled = newVal
//        selectPeriod(period)
//    }
//
//    
//    func showInAppPaywall() {
//        isSpecial = true
//        subLogic = SubLogic(isSpecial: true)
//    }


extension SubViewModel {
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        let locationStatus = CLLocationManager.authorizationStatus()
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let notificationAuthorized = settings.authorizationStatus == .authorized
            let locationAuthorized = locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse
            
            DispatchQueue.main.async {
                completion(notificationAuthorized && locationAuthorized)
            }
        }
    }
}

//
//  IAPViewModel.swift
//  TeploDom
//
//  Created by Bema on 18/6/25.
//

import Foundation
import SwiftUI

class IAPViewModel: ObservableObject {
   // private var offerings: Offerings?
   // private var config = Config.shared
  /*  @Published private(set) var error = ""
    @Published private(set) var isPurchasing = false
    @Published private(set) var isLoadingSubs = true

    @Published var showingSubview = false
    @Published var showAlert = false
    @AppStorage("subscriptionEndDate") private(set) var subscriptionEndDateString = ""
    //@AppStorage("subscriptionEndDate") private(set) var subscriptionEndDate = Date.now
  
    var subscriptionEndDate: Date {
        get {
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: subscriptionEndDateString) ?? .now
        }
        set {
            let formatter = ISO8601DateFormatter()
            subscriptionEndDateString = formatter.string(from: newValue)
        }
    }

    var isSubscribed: Bool {
        subscriptionEndDate > Date()
    }

    init() {
        Task {
            await initialSetup()
        }
    }

    private func initialSetup() async {
        do {
            offerings = try await Purchases.shared.offerings()
            if let current = offerings?.current {
                config.priceText = current.getMetadataValue(for: "price_text", default: "Start a 3-day free trial for full app\naccess, then continue for $$$$ per week,")
                config.purchaseButtonText = current.getMetadataValue(for: "purchase_button_text", default: "Get Started")
                config.closeButtonText = current.getMetadataValue(for: "close_button_text", default: "or choose the limited version.")
                config.closeButtonEnabled = current.getMetadataValue(for: "close_button_enabled", default: true)
                config.packageID = current.getMetadataValue(for: "default", default: "Monthly")
            }
            await self.checkStatus()
        } catch {
            print(error.localizedDescription)
        }
        await MainActor.run {
            isLoadingSubs = false
        }
    }

    func purchaseProduct(productType: ProductType) {
        isPurchasing = true
        Task {
            let package: Package? = offerings?.current?.availablePackages.first(where: {$0.identifier == productType.packageID})
            if let package {
                do {
                    let result = try await Purchases.shared.purchase(package: package)
                    await MainActor.run {
                        updateSubscriptionStatus(from: result.customerInfo)
                    }
                    if result.userCancelled {
                        await MainActor.run {
                            showAlert = true
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Zero products available")
            }
            await MainActor.run {
                isPurchasing = false
            }
        }
    }

    func restore() async {
        do {
            let result = try await Purchases.shared.restorePurchases()
            await MainActor.run {
                updateSubscriptionStatus(from: result)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func checkStatus() async {
        do {
            let result = try await Purchases.shared.customerInfo()
            await MainActor.run {
                updateSubscriptionStatus(from: result)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    @MainActor
    private func updateSubscriptionStatus(from result: CustomerInfo) {
        if let expiresAt = result.entitlements.active.first?.value.expirationDate {
            subscriptionEndDate = expiresAt
        } else {
            subscriptionEndDate = .now
        }
    }
    


    func priceOfProduct(productType: ProductType) -> String {
        var price = offerings?.current?.availablePackages.first(where: {$0.identifier == productType.packageID})?.localizedPriceString
        if price == nil || price?.isEmpty ?? true {
            switch productType {
            case .featureWeekly:
                price = "$8.99"
            case .featureMonthly:
                price = "$14.99"
            case .featureYearly:
                price = "$83.99"
            case .featureWeeklyTrial:
                price = "$8.99"
            case .featureMonthlyTrial:
                price = "$15.99"
            case .featureYearlyTrial:
                price = "$99.99"
            }
        }
        return price ?? "$8.99"
    }

    func weekPriceOfProduct(productType: ProductType) -> String {
        var priceString = String()
        let product = offerings?.current?.availablePackages.first(where: {$0.identifier == productType.packageID})
        if let product {
            var price: Double = Double(truncating: product.storeProduct.price as NSNumber)
            let currency = product.storeProduct.currencyCode ?? "$"
            switch productType {
            case .featureWeekly, .featureWeeklyTrial:
                break
            case .featureMonthly, .featureMonthlyTrial:
                price = price / 4
            case .featureYearly, .featureYearlyTrial:
                price = price / 52
            }
            price = price.rounded(toPlaces: 2)
            priceString = "\(price) \(currency)/week"
        } else {
            switch productType {
            case .featureWeekly:
                priceString = "$8.99/week"
            case .featureMonthly:
                priceString = "$3.74/week"
            case .featureYearly:
                priceString = "$1.61/week"
            case .featureWeeklyTrial:
                priceString = "$7.97/week"
            case .featureMonthlyTrial:
                priceString = "$3.99/week"
            case .featureYearlyTrial:
                priceString = "$1.92/week"
            }
        }
        return priceString
    }
   */

}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

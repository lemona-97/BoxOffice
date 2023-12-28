//
//  BoxOfficeKoreaApp.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 11/29/23.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct BoxOfficeKoreaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
    }
}

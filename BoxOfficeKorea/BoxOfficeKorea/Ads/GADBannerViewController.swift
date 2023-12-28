//
//  GADBannerViewController.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/27/23.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        
        view.adUnitID = GAD_KEY // 샘플
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

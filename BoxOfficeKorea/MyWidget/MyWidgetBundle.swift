//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by wooseob on 12/22/23.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}

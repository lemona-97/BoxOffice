//
//  View.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

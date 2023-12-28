//
//  LoaderView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import SwiftUI

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .tint(tintColor)
    }
}

#Preview {
    LoaderView()
}

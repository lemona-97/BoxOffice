//
//  Categories.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import Foundation

class Categories : Identifiable {
    var id = UUID()
    var categories : String
    var isSelected : Bool
    
    init(categories: String, isSelected: Bool) {
        self.categories = categories
        self.isSelected = isSelected
    }
    func changeSelection() {
        isSelected.toggle()
    }
}

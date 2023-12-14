//
//  ContentView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 11/29/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    var categories : [Categories] = [Categories(categories: "일간", isSelected: true),
                                     Categories(categories: "주간", isSelected: false),
                                     Categories(categories: "주말", isSelected: false)]
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack (spacing: 20){
                Text("한국 Box Office")
                    .foregroundStyle(.black)
                    .padding(5)
                HStack{
                    Spacer()
                    ForEach(categories) { category in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.cyan, lineWidth: 1)
                                .frame(width: 100, height: 60)
                                .foregroundStyle(.clear)
                            if category.isSelected {
                                Button(category.categories, action: {
                                    if category.categories == "일간" {
                                        viewModel.getDailyBoxOffice()
                                    } else if category.categories == "주간" {
                                        viewModel.getWeeklyBoxOffice()
                                    } else { // 주말
                                        viewModel.getWeekendBoxOffice()
                                    }
                                })
                                .foregroundStyle(.blue)
                                .frame(width: 100, height: 60)
                            } else {
                                Button(category.categories, action: {
                                    if category.categories == "일간" {
                                        categories[0].isSelected = true
                                        categories[1].isSelected = false
                                        categories[2].isSelected = false
                                        viewModel.getDailyBoxOffice()
                                    } else if category.categories == "주간" {
                                        categories[0].isSelected = false
                                        categories[1].isSelected = true
                                        categories[2].isSelected = false
                                        viewModel.getWeeklyBoxOffice()
                                    } else {
                                        categories[0].isSelected = false
                                        categories[1].isSelected = false
                                        categories[2].isSelected = true
                                        viewModel.getWeekendBoxOffice()
                                    }
                                })
                                .foregroundStyle(.pink)
                                .frame(width: 100, height: 60)
                            }
                        }
                        Spacer()
                    }
                }
                List {
                    if !viewModel.dailyMovies.isEmpty {
                        MovieView(movies: viewModel.dailyMovies)
                    } else if !viewModel.weeklyMovies.isEmpty {
                        MovieView(movies: viewModel.weeklyMovies)
                    } else {
                        MovieView(movies: viewModel.weekendMovies)
                    }
                    
                }.listStyle(.plain)
            }
        }
    }
}
#Preview {
    ContentView()
}

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


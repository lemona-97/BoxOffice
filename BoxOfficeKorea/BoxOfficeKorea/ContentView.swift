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
            VStack{
                Text("영화 Box Office")
                    .padding()
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
                                    }
                                })
                                .foregroundStyle(.blue)
                                .frame(width: 100, height: 60)
                            } else {
                                Button(category.categories, action: {
                                    if category.categories == "일간" {
                                        print("일간!")
                                        categories[0].isSelected = true
                                        categories[1].isSelected = false
                                        categories[2].isSelected = false
                                        viewModel.getDailyBoxOffice()
                                    } else if category.categories == "주간" {
                                        categories[0].isSelected = false
                                        categories[1].isSelected = true
                                        categories[2].isSelected = false
                                        print("주간!")
                                        viewModel.getWeeklyBoxOffice()
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
                    Section {
                        if !viewModel.dailyMovies.isEmpty {
                            ForEach(viewModel.dailyMovies, id: \.movieCd) { dailyMovie in
                                VStack(alignment: .leading, spacing: 10, content: {
                                    HStack{
                                        Text(dailyMovie.movieNm)
                                        Text(dailyMovie.showCnt)
                                    }
                                })
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            }
                        } else if !viewModel.weeklyMoviews.isEmpty {
                            ForEach(viewModel.weeklyMoviews, id: \.movieCd) { weeklyMovie in
                                VStack(alignment: .leading, spacing: 10, content: {
                                    HStack{
                                        Text(weeklyMovie.movieNm)
                                        Text(weeklyMovie.showCnt)
                                    }
                                })
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 10, content: {
                                Text("불러오는중")
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                    }
                }
                Spacer()
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

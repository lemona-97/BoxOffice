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
            VStack (spacing: 10){
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
                        ForEach(viewModel.dailyMovies, id: \.movieCd) { dailyMovie in
                            ZStack {
                                Color.white
                                VStack(alignment: .leading, spacing: 10, content: {
                                    HStack{
                                        VStack(alignment: .leading, spacing: 10, content: {
                                            HStack(alignment: .center, content: {
                                                Text("영화 제목 : \(dailyMovie.movieNm)")
                                                    .foregroundStyle(.black)
                                                if Int(dailyMovie.rankInten)! >= 0 {
                                                    Image(systemName: "arrowtriangle.up.fill")
                                                        .foregroundStyle(.red)
                                                        .frame(width: 10, height: 10)
                                                    Text("\(dailyMovie.rankInten)")
                                                        .foregroundStyle(.black)
                                                } else {
                                                    Image(systemName: "arrowtriangle.down.fill")
                                                        .foregroundStyle(.blue)
                                                    Text("\(dailyMovie.rankInten)")
                                                        .foregroundStyle(.black)
                                                }
                                                
                                            })
                                            HStack {
                                                Text("관람객 수 : \(dailyMovie.audiCnt)")
                                                    .font(.system(size: 15))
                                                    .foregroundStyle(.black)
                                                if Int(dailyMovie.audiInten)! >= 0 {
                                                    Text("(전일 대비 +\(dailyMovie.audiInten))")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.black)
                                                } else {
                                                    Text("(전일 대비 \(dailyMovie.audiInten))")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.black)
                                                }
                                                
                                            }
                                            
                                        })
                                        
                                        Spacer()
                                        if dailyMovie.rankOldAndNew == "NEW" {
                                            Text("NEW")
                                                .foregroundStyle(.green)
                                        }
                                    }
                                })
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                        }
                        .ignoresSafeArea()
                    } else if !viewModel.weeklyMovies.isEmpty {
                        ForEach(viewModel.weeklyMovies, id: \.movieCd) { weeklyMovie in
                            VStack(alignment: .leading, spacing: 10, content: {
                                HStack{
                                    VStack(alignment: .leading, spacing: 10, content: {
                                        HStack(alignment: .center, content: {
                                            Text("영화 제목 : \(weeklyMovie.movieNm)")
                                            if Int(weeklyMovie.rankInten)! >= 0 {
                                                Image(systemName: "arrowtriangle.up.fill")
                                                    .foregroundStyle(.red)
                                                    .frame(width: 10, height: 10)
                                                Text("\(weeklyMovie.rankInten)")
                                            } else {
                                                Image(systemName: "arrowtriangle.down.fill")
                                                    .foregroundStyle(.blue)
                                                Text("\(weeklyMovie.rankInten)")
                                            }
                                            
                                        })
                                        HStack {
                                            Text("관람객 수 : \(weeklyMovie.audiCnt)")
                                                .font(.system(size: 15))
                                            if Int(weeklyMovie.audiInten)! >= 0 {
                                                Text("(전주 대비 +\(weeklyMovie.audiInten))")
                                                    .font(.system(size: 12))
                                            } else {
                                                Text("(전주 대비 \(weeklyMovie.audiInten))")
                                                    .font(.system(size: 12))
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                    Spacer()
                                    if weeklyMovie.rankOldAndNew == "NEW" {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.cyan, lineWidth: 1)
                                                .frame(width: 50, height: 30)
                                                .foregroundStyle(.clear)
                                            Text("NEW")
                                                .foregroundStyle(.green)
                                        }
                                    }
                                }
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .ignoresSafeArea()
                    } else {
                        VStack(alignment: .leading, spacing: 10, content: {
                            Text("불러오는중")
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        ContentView()
    }
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

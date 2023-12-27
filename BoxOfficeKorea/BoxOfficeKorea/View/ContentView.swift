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
        NavigationView(content: {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack (spacing: 20){
                    Text("국내 박스오피스")
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
                                    }).fontWeight(.bold)
                                        .foregroundStyle(.black)
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
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                    .frame(width: 100, height: 60)
                                }
                            }
                            Spacer()
                        }
                    }
                    List {
                        if !viewModel.dailyMovies.isEmpty {
                            MovieView(movies: viewModel.dailyMovies,
                                      movieImage: viewModel.movieImages,
                                      movieDetails: viewModel.movieDetails)
                        } else if !viewModel.weeklyMovies.isEmpty {
                            MovieView(movies: viewModel.weeklyMovies,
                                      movieImage: viewModel.movieImages,
                                      movieDetails: viewModel.movieDetails)
                        } else {
                            MovieView(movies: viewModel.weekendMovies,
                                      movieImage: viewModel.movieImages,
                                      movieDetails: viewModel.movieDetails)
                        }
                    }.listStyle(.plain)
                }
            }
        })
    }
}
#Preview {
    ContentView()
}




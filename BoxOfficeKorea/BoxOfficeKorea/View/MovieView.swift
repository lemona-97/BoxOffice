//
//  MovieView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import SwiftUI

struct MovieView: View {
    var movies : [MovieModel]
    var movieImageURL : [String : String]
    var movieDetails : [String : MovieDetailModel]
    var body: some View {
        ForEach(movies, id: \.movieCd) { movie in
             ZStack {
                Color.white
                 HStack {
                     VStack(spacing: 10, content: {
                        HStack {
                            
                            Text(movie.rank)
                                .foregroundStyle(.black)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                            if Int(movie.rankInten)! >= 0 {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .foregroundStyle(.red)
                                    .frame(width: 10, height: 10)
                                Text("\(movie.rankInten)")
                                    .foregroundStyle(.black)
                            } else {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundStyle(.blue)
                                Text("\(movie.rankInten)")
                                    .foregroundStyle(.black)
                            }
                            if movie.rankOldAndNew == "NEW" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.cyan, lineWidth: 2)
                                        .frame(width: 80, height: 30)
                                        .foregroundStyle(.clear)
                                    Text("NEW")
                                        .font(.subheadline)
                                        .foregroundStyle(.green)
                                }.padding(10)
                            }
                            
                        }
                        HStack{
                            VStack(spacing: 20, content: {
                                HStack(alignment: .center, content: {
                                    Text("\(movie.movieNm)")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.black)
                                })
                                Text("관람객 수 : \(movie.audiCnt.insertComma)")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black)
                                if Int(movie.audiInten)! >= 0 {
                                    Text("(+\(movie.audiInten))")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.black)
                                } else {
                                    Text("(\(movie.audiInten))")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.black)
                                }
                                
                            }).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                            
                        }
                    })
                     .frame(maxWidth: .infinity)
                     if self.movieImageURL.count == self.movies.count {
                         if let urlString = self.movieImageURL[movie.movieNm] {
                             if let url = URL(string: urlString) {
                                 AsyncImage(url: url) { phase in
                                     if let image = phase.image{
                                         image.resizable()
                                             .frame(width: 160, height: 200)
                                             .clipped()
                                             .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                     }
                                 }
                             }
                         }
                     }
                 }
                 if let movieDetail = movieDetails[movie.movieCd] {
                     NavigationLink(destination:MovieDetailView(movieInfo: movie, movieImageURL: movieImageURL, movieDetail: movieDetail)) {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .clipped()
                     }
                 }
            }
        }
        .ignoresSafeArea()
    }
}
#Preview {
    ContentView()
}

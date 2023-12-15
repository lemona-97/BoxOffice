//
//  MoviewView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import SwiftUI

struct MovieView: View {
    var movies : [MovieModel]
    var movieImageURL : [String : String]
    var body: some View {
        
        ForEach(movies, id: \.movieCd) { movie in
            ZStack {
                Color.white
                VStack(alignment: .leading, spacing: 10, content: {
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
                                    .frame(width: 30, height: 20)
                                    .foregroundStyle(.clear)
                                Text("NEW")
                                    .foregroundStyle(.green)
                            }.padding(10)
                        }
                    }
                    HStack{
                        VStack(alignment: .leading, spacing: 20, content: {
                            HStack(alignment: .center, content: {
                                Text("영화 제목 : \(movie.movieNm)")
                                    .foregroundStyle(.black)
                            })
                            Text("관람객 수 : \(movie.audiCnt)")
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
                            
                        }).padding()
                        if self.movieImageURL.count == self.movies.count {
                            if let urlString = self.movieImageURL[movie.movieNm] {
                                if let url = URL(string: urlString) {
                                    if let data = try? Data(contentsOf: url) {
                                        Image(uiImage: UIImage(data: data)!)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                    }
                                }
                            }
                        }
                        
                        
                    }
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MovieView(movies: [MovieModel(rnum: "5", rank: "5", rankInten: "19", rankOldAndNew: "OLD", movieCd: "20235980", movieNm: "말하고 싶은 비밀", openDt: "2023-12-13", salesAmt: "81703666", salesShare: "2.9", salesInten: "77851666", salesChange: "2021.1", salesAcc: "102324666", audiCnt: "9154", audiInten: "8726", audiChange: "2038.8", audiAcc: "11409", scrnCnt: "401", showCnt: "696")], movieImageURL: ["뽀로로": "https://search3.kakaocdn.net/argon/130x130_85_c/Jxf8lVM0M8M"])
}

//
//  MoviewView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import SwiftUI

struct MovieView: View {
    var movies : [MovieModel]
    var body: some View {
        ForEach(movies, id: \.movieCd) { movie in
            ZStack {
                Color.white
                
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
                    VStack(alignment: .leading, spacing: 10, content: {
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
                            
                            Spacer()
                            if movie.rankOldAndNew == "NEW" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.cyan, lineWidth: 2)
                                        .frame(width: 50, height: 30)
                                        .foregroundStyle(.clear)
                                    Text("NEW")
                                        .foregroundStyle(.green)
                                }.padding(10)
                            }
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MovieView(movies: [MovieModel(rnum: "5", rank: "5", rankInten: "19", rankOldAndNew: "OLD", movieCd: "20235980", movieNm: "말하고 싶은 비밀", openDt: "2023-12-13", salesAmt: "81703666", salesShare: "2.9", salesInten: "77851666", salesChange: "2021.1", salesAcc: "102324666", audiCnt: "9154", audiInten: "8726", audiChange: "2038.8", audiAcc: "11409", scrnCnt: "401", showCnt: "696")])
}

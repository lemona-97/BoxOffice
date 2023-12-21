//
//  MovieDetailView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/21/23.
//

import SwiftUI

struct MovieDetailView: View {
    @State var movieInfo : MovieModel
    @State var movieImageURL : [String : String]
    @State var movieDetail : MovieDetailModel
    var body: some View {
        VStack(content: {
            Text(movieInfo.movieNm)
            Spacer()
            if let urlString = self.movieImageURL[movieInfo.movieNm] {
                if let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image{
                            image.resizable()
                                .frame(width: 300, height: 450)
                                .clipped()
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        }
                    }
                }
            }
            HStack(alignment: .center, content: {
                Text("개봉일자 ")
                Text("\(movieInfo.openDt)")
                Spacer()
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            HStack(alignment: .center, content: {
                Text("누적 매출액")
                Text("\(movieInfo.salesAcc.insertComma)원")
                Spacer()
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            HStack(alignment: .center, content: {
                Text("누적 관객수 :")
                Text("\(movieInfo.audiAcc)")
                Spacer()
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            HStack(alignment: .center, content: {
                Text("주연 :")
                if !movieDetail.movieInfoResult.movieInfo.actors.isEmpty {
                    Text("\(movieDetail.movieInfoResult.movieInfo.actors[0].peopleNm)")
                } else {
                    Text("불러오는중...")
                }
                
                Spacer()
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            Spacer()
        })
    }
}



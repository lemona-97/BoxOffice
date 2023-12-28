//
//  MovieDetailView.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/21/23.
//

import SwiftUI

struct MovieDetailView: View {
    @State var movieInfo : MovieModel
    @State var movieImage : [String : UIImage]
    @State var movieDetail : MovieDetailModel
    @GestureState private var zoom = 1.0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .center,content: {
            ZStack {
                Text(movieInfo.movieNm)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Rectangle()
                    .stroke(.indigo, lineWidth: 2)
                    .frame(width:UIScreen.main.bounds.width + 10, height: 40)
                    .foregroundStyle(.clear)
            }
            if let image = self.movieImage[movieInfo.movieNm] {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 1.08)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .scaleEffect(zoom)
                    .gesture(MagnifyGesture().updating($zoom, body: { value, GestureState, transaction in
                        GestureState = value.magnification
                    }))
                
            }
            
            
            
            HStack(alignment: .center, content: {
                Text("개봉일 : ")
                Text("\(movieInfo.openDt)")
                
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            
            HStack(alignment: .center, content: {
                Text("감독 :")
                if !movieDetail.movieInfoResult.movieInfo.directors.isEmpty {
                    Text("\(movieDetail.movieInfoResult.movieInfo.directors[0].peopleNm)")
                } else {
                    Text("감독 정보 미제공")
                }
                
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            HStack(alignment: .center, content: {
                Text("주연 :")
                if !movieDetail.movieInfoResult.movieInfo.actors.isEmpty {
                    Text("\(movieDetail.movieInfoResult.movieInfo.actors[0].peopleNm)")
                } else {
                    Text("출연진 정보 미제공")
                }
                
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            HStack(alignment: .center, content: {
                Text("누적 매출액")
                Text("\(movieInfo.salesAcc.insertComma)원")
              
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            HStack(alignment: .center, content: {
                Text("누적 관객수 :")
                Text("\(movieInfo.audiAcc.insertComma)")
             
            }).padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            Spacer()
        }).navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }).foregroundStyle(.black)
    }
    var backButton : some View {  // <-- 👀 커스텀 버튼
            Button{
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left") // 화살표 Image
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
}


#Preview {
    ContentView()
}

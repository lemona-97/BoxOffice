//
//  MovieModel.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/6/23.
//

import Foundation
struct DailyMovie: Codable {
    let boxOfficeResult: DayBoxOfficeResult
}

struct DayBoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [MovieModel]
}


struct WeeklyMovie: Codable {
    let boxOfficeResult: WeekBoxOfficeResult
}

struct WeekBoxOfficeResult: Codable {
    let boxofficeType, showRange, yearWeekTime: String
    let weeklyBoxOfficeList: [MovieModel]
}



struct MovieModel: Codable {
    ///순번을 출력합니다.
    let rnum : String
    ///해당일자의 박스오피스 순위를 출력합니다.
    let rank : String
    ///전일대비 순위의 증감분을 출력합니다.
    let rankInten : String
    ///랭킹에 신규진입여부를 출력합니다. “OLD” : 기존 , “NEW” : 신규
    let rankOldAndNew : String
    ///영화의 대표코드를 출력합니다.
    let movieCd : String
    ///영화명(국문)을 출력합니다.
    let movieNm : String
    ///영화의 개봉일을 출력합니다.
    let openDt    : String
    ///해당일의 매출액을 출력합니다.
    let salesAmt    : String
    ///해당일자 상영작의 매출총액 대비 해당 영화의 매출비율을 출력합니다.
    let salesShare    : String
    ///전일 대비 매출액 증감분을 출력합니다.
    let salesInten    : String
    ///전일 대비 매출액 증감 비율을 출력합니다.
    let salesChange    : String
    /// 누적매출액을 출력합니다.
    let salesAcc    : String
    ///해당일의 관객수를 출력합니다.
    let audiCnt    : String
    ///전일 대비 관객수 증감분을 출력합니다.
    let audiInten    : String
    ///전일 대비 관객수 증감 비율을 출력합니다.
    let audiChange    : String
    ///누적관객수를 출력합니다.
    let audiAcc    : String
    ///해당일자에 상영한 스크린수를 출력합니다.
    let scrnCnt    : String
    ///해당일자에 상영된 횟수를 출력합니다.
    let showCnt    : String
}

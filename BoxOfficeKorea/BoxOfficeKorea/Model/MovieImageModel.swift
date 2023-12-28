//
//  MovieImageModel.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/14/23.
//

import Foundation

/// 응답
struct MovieImageModel : Decodable {
    var meta : Meta
    var documents : [Documents]
}

/// 응답 관련 정보
struct Meta : Decodable {
    var total_count : Int
    var pageable_count : Int
    var is_end : Bool
}

/// 응답 결과
struct Documents : Decodable {
    /// 컬렉션
    var collection              : String
    /// 미리보기 이미지 URL
    var thumbnail_url           : String
    /// 이미지 URL
    var image_url               : String
    /// 이미지의 가로 길이
    var width                   : Int
    /// 이미지의 세로 길이
    var height                  : Int
    /// 출처
    var display_sitename  : String
    /// 문서 URL
    var doc_url                 : String
    ///  문서 작성시간, ISO 8601 [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
//    var datetime                : Date

}

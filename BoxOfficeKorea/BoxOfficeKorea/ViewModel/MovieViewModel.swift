//
//  ContentViewModel.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/6/23.
//

import Foundation
import Combine
import Alamofire

class MovieViewModel: ObservableObject {
    
    @Published var dailyMovies: [MovieModel] = []
    @Published var weeklyMovies: [MovieModel] = []
    @Published var weekendMovies: [MovieModel] = []
    var movies : [MovieModel] = []
    @Published var moviewImagesURLs: [String : String] = [:] {
        didSet {
            print(moviewImagesURLs)
        }
    }
    var today = Date()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getDailyBoxOffice()
    }
    
    private func clearInfo() {
        self.weeklyMovies.removeAll()
        self.moviewImagesURLs.removeAll()
    }
    func getDailyBoxOffice() {
        clearInfo()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = .current
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let targetDate = dateFormatter.string(from: yesterday)
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(MOVIE_API_KEY)&targetDt=\(targetDate)") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: DailyMovie.self, decoder: JSONDecoder())
            .sink { completion in
                
                print("Completion: \(completion)")
            } receiveValue: { [weak self] returnedMovie in
                print(returnedMovie)
                self?.dailyMovies = returnedMovie.boxOfficeResult.dailyBoxOfficeList
            }
            .store(in: &cancellables)
        
    }
    
    func getWeeklyBoxOffice() {
        clearInfo()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = .current
        let yesterday = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let targetDate = dateFormatter.string(from: yesterday)
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=\(MOVIE_API_KEY)&weekGb=0&targetDt=\(targetDate)") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                print(data)
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeeklyMovie.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] returnedMovie in
                print(returnedMovie)
                self?.weeklyMovies = returnedMovie.boxOfficeResult.weeklyBoxOfficeList
            }
            .store(in: &cancellables)
    }
    
    func getWeekendBoxOffice() {
        clearInfo()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = .current
        let yesterday = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let targetDate = dateFormatter.string(from: yesterday)
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=\(MOVIE_API_KEY)&targetDt=\(targetDate)") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeeklyMovie.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] returnedMovie in
                print(returnedMovie)
             
                self?.weekendMovies = returnedMovie.boxOfficeResult.weeklyBoxOfficeList
                guard let self = self else { return }
                DispatchQueue.main.async {
                    Task {
                        for movie in self.weekendMovies {
                            do {
                                try await self.getMoviePosters(movieName: movie.movieNm)
                                
                            } catch {
                                print("포스터 가져오기 에러 \(error)")
                            }
                        }
                    }
                    
                }
                
                
   
                }.store(in: &cancellables)

    }
    
    func getMoviePosters(movieName: String) async throws {
        
        guard let url = URL(string:"https://dapi.kakao.com/v2/search/image") else { return }
        
        let headers : HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
                "Authorization": "\(KAKAO)", // 이 부분에 당신의 REST API 키 넣어주기
                
                /* ! 예시 !
                "Authorization": "KakaoAK 1abec3hyn81d3nut7as" // KakaoAK 하고 띄어쓰기 유심히 보기
                */
            ]
        
        let parameters : [String: Any] = [
            "query" : movieName,
            "size" : 1
        ]
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let res):
                let resultData = String(data: response.data!, encoding: .utf8)
                
                do {
                    // 반환값을 Data 타입으로 변환
                    print("1")
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    print("2")
                    let json = try JSONDecoder().decode(MovieImageModel.self, from: jsonData)
                    print("3")
                    print("4")
                    print(json.documents)
                    self.moviewImagesURLs.updateValue(json.documents.first!.thumbnail_url, forKey: movieName) 
                    print("5")
                } catch (let error) {
                    print("catch error : \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Authorization", forHTTPHeaderField: KAKAO)
//        let queryItem1 = URLQueryItem(name: "query", value: movieName)
//        let queryItem2 = URLQueryItem(name: "size", value: "1")
//        request.url?.append(queryItems: [queryItem2, queryItem1])
//        print("request")
//        dump(request)
//        let (data, response) =  try await URLSession.shared.data(for: request)
//        print("data : \(data)")
//        print("response ; \(response)")
//        guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
//            throw NEWWORKERROR.networkFail
//        }
//        let posterData = try JSONDecoder().decode(MovieImageModel.self, from: data)
//        print(posterData)
//        return posterData.documents.image_url

    }
}

enum NEWWORKERROR : Error {
    case networkFail
    case invaildData
}

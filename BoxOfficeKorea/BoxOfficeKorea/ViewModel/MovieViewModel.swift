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
    @Published var movieDetails : [String : MovieDetailModel] = [:]
    @Published var movieImages: [String : UIImage] = [:]
    
    var today = Date()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getDailyBoxOffice()
    }
    
    private func clearInfo() {
        self.dailyMovies.removeAll()
        self.weeklyMovies.removeAll()
        self.weekendMovies.removeAll()
        self.movieDetails.removeAll()
        self.movieImages.removeAll()
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
                
                guard let self = self else { return }
                
                Task {
                    for movie in self.dailyMovies {
                        do {
                            try await self.getMoviePosters(rank: movie.rank, movieName: movie.movieNm)
                        } catch {
                            print("포스터 가져오기 에러 \(error)")
                        }
                    }
                }
                for movie in self.dailyMovies {
                    self.getMovieDetail(movieCd: movie.movieCd)
                }
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
                guard let self = self else { return }
                
                Task {
                    for movie in self.weeklyMovies {
                        do {
                            try await self.getMoviePosters(rank: movie.rank, movieName: movie.movieNm)
                        } catch {
                            print("포스터 가져오기 에러 \(error)")
                        }
                    }
                }
                for movie in self.weeklyMovies {
                    self.getMovieDetail(movieCd: movie.movieCd)
                }
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
                
                Task {
                    for movie in self.weekendMovies {
                        do {
                            try await self.getMoviePosters(rank: movie.rank, movieName: movie.movieNm)
                            
                        } catch {
                            print("포스터 가져오기 에러 \(error)")
                        }
  
                    }
                }
                for movie in self.weekendMovies {
                    self.getMovieDetail(movieCd: movie.movieCd)
                }
            }.store(in: &cancellables)
        
    }
    
    func getMoviePosters(rank : String, movieName: String) async throws {
        
        if let image = ImageCacheManager.shared.object(forKey: movieName as NSString) as? UIImage { // 캐시에 있는 이미지 인지 확인
            self.movieImages.updateValue(image, forKey: movieName) //있으면 캐시에서 불러옴
            print("캐싱된 이미지를 불러옵니다")
            return
        }
                                                                            // 없으면 api호출
        guard let url = URL(string:"https://dapi.kakao.com/v2/search/image") else { return }
        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "\(KAKAO_KEY)",
        ]
        let parameters : [String: Any] = [
            "query" : "\(movieName)",
            "size" : 1,
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
                    
                    
                    guard let url = URL(string: json.documents.first!.image_url) else { return }
                    Task {
                        let data = try Data(contentsOf: url)
                        if let image = UIImage(data: data){
                            self.movieImages.updateValue(image, forKey: movieName)
                            ImageCacheManager.shared.setObject(image, forKey: movieName as NSString)
                        }
                    }
                } catch (let error) {
                    print("catch error : \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getMovieDetail(movieCd : String) {
        print("get Movie Detail")
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=\(MOVIE_API_KEY)&movieCd=\(movieCd)") else { return }
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
            .decode(type: MovieDetailModel.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] returnedMovie in
                print("상세정보")
                print(returnedMovie)
                self?.movieDetails.updateValue(returnedMovie, forKey: movieCd)
            }
            .store(in: &cancellables)
    }
}

enum NEWWORKERROR : Error {
    case networkFail
    case invaildData
}

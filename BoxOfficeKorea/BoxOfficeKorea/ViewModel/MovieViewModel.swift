//
//  ContentViewModel.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/6/23.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    
    @Published var dailyMovies: [MovieModel] = []
    @Published var weeklyMovies: [MovieModel] = []
    @Published var weekendMovies: [MovieModel] = []
    var today = Date()
    var cancellables = Set<AnyCancellable>()

    init() {
        getDailyBoxOffice()
    }
    
    func getDailyBoxOffice() {
        self.weeklyMovies.removeAll()
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
        self.dailyMovies.removeAll()
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
        self.dailyMovies.removeAll()
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
                self?.weeklyMovies = returnedMovie.boxOfficeResult.weeklyBoxOfficeList
                
            }
            .store(in: &cancellables)
    }
}

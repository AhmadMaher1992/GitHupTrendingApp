//
//  TrendingListViewModel.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import Foundation
import Combine


class TrendingListViewModel {
    
    @Published var repositories: [GithupRepo] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isPaginating: Bool = false
    
    var currentPage = 1
    var cancellables = Set<AnyCancellable>()
    var canLoadMorePages = true
    var isInitialLoad: Bool = true // Flag to track if it's the first load or segment switch
    
    // Fetch repositories and show HUD based on the load type (initial load or pagination)
    func fetchRepositories(timeframe: Timeframe, completion: @escaping () -> Void) {
        guard !isLoading && canLoadMorePages else { return }
        
        if isInitialLoad {
            isLoading = true // Show the HUD during the first load or when switching segments
        } else {
            isPaginating = true // Show bottom spinner during pagination
        }
        
        let urlString: String
        switch timeframe {
        case .day:
            urlString = "https://api.github.com/search/repositories?q=created:>\(getDate(days: -1))&sort=stars&order=desc&page=\(currentPage)"
        case .week:
            urlString = "https://api.github.com/search/repositories?q=created:>\(getDate(days: -7))&sort=stars&order=desc&page=\(currentPage)"
        case .month:
            urlString = "https://api.github.com/search/repositories?q=created:>\(getDate(days: -30))&sort=stars&order=desc&page=\(currentPage)"
        }
        print("DEBUG:☑️ URL String ☑️ \(urlString) ☑️")
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitRepositoriesResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completionStatus in
                self.isLoading = false
                self.isPaginating = false
                self.isInitialLoad = false // Mark the initial/segment load as completed
                
                switch completionStatus {
                case .finished:
                    completion()
                case .failure(let error):
                    print("DEBUG:☑️ ERROR ☑️ \(error) ☑️")
                    self.errorMessage = error.localizedDescription
                    completion()
                }
            }, receiveValue: { response in
                self.repositories.append(contentsOf: response.items ?? [])
                self.canLoadMorePages = response.items?.count ?? 0 > 0
                if self.canLoadMorePages {
                    self.currentPage += 1
                }
                // Debugging: Log the JSON response
                do {
                    let jsonData = try JSONEncoder().encode(response)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("DEBUG:☑️ Response JSON ☑️ \(jsonString)")
                    }
                } catch {
                    print("Failed to encode response to JSON: \(error)")
                }
            })
            .store(in: &cancellables)
    }
    
    private func getDate(days: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: days, to: Date())!
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
}




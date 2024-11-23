//
//  WeaterViewModel.swift
//  WeatherTest
//
//  Created by PraveenMAC on 23/11/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var forecast: [DailyForecast] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiKey = "6bbd321a1dee594ce0f5147e8a6c4fe8"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(for city: String) {
        guard !city.isEmpty else {
            errorMessage = "City name cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: weatherURL) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] weatherData in
                self?.currentWeather = weatherData
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }

    func fetchForecast(for city: String) {
            guard !city.isEmpty else {
                errorMessage = "City name cannot be empty."
                return
            }

            isLoading = true
            errorMessage = nil

            let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?q=\(formattedCity)&appid=\(apiKey)&units=metric"

            guard let url = URL(string: forecastURL) else {
                errorMessage = "Invalid URL."
                isLoading = false
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ForecastResponse.self, decoder: JSONDecoder())
                .map { response in
                    self.groupForecastByDay(response.list)
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] dailyForecasts in
                    self?.forecast = dailyForecasts
                }
                .store(in: &cancellables)
        }

    private func groupForecastByDay(_ forecastItems: [ForecastItem]) -> [DailyForecast] {
        let calendar = Calendar.current
        let today = Date()

        // Create a consistent DateFormatter for parsing and formatting
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure locale consistency

        // Group forecast items by day
        let grouped = Dictionary(grouping: forecastItems, by: { item -> String in
            let date = Date(timeIntervalSince1970: item.dt)
            return formatter.string(from: date) // Format date as yyyy-MM-dd
        })

        // Map the grouped items to DailyForecast while excluding today's date
        return grouped.compactMap { (dateString, items) in
            // Parse the grouped date string back to a Date object
            guard let date = formatter.date(from: dateString) else { return nil }
            
            // Exclude today's date
            guard !calendar.isDate(date, inSameDayAs: today) else { return nil }

            // Calculate min and max temperatures
            let minTemp = items.map { $0.main.temp_min }.min() ?? 0
            let maxTemp = items.map { $0.main.temp_max }.max() ?? 0

            return DailyForecast(date: dateString, minTemp: minTemp, maxTemp: maxTemp)
        }
        .sorted { $0.date < $1.date } // Sort by date
        .prefix(5) // Take only the next 5 days
        .map { $0 } // Convert the prefix back to an array
    }
}

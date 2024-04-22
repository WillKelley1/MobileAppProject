
//  WeatherView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/9/24.


import SwiftUI
import Foundation

// MARK: - Model
struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let main: String
        let description: String
    }
}

// MARK: - Service
class WeatherService {
    func fetchWeather(city: String, apiKey: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
            // Change units=metric to units=imperial for Fahrenheit
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=imperial"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(weatherData))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

// MARK: - ViewModel
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var weatherService = WeatherService()
    private let apiKey = "14da677c3c40bd4ed50aba3dd48a1a91"
    
    func fetchWeather(forCity city: String) {
        isLoading = true
        weatherService.fetchWeather(city: city, apiKey: apiKey) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let weatherData):
                self?.weatherData = weatherData
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - View
struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Today's Weather").bold().font(.title)
            
            if viewModel.isLoading {
                ProgressView()
            } else if let weatherData = viewModel.weatherData {
                Text("\(weatherData.name)'s Temperature: \(weatherData.main.temp, specifier: "%.1f")°F").bold().font(.title3)
                Text("Condition: \(weatherData.weather.first?.main ?? "N/A") - \(weatherData.weather.first?.description ?? "N/A")").bold().font(.title3)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchWeather(forCity: "Dahlonega") // Example city
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

//import SwiftUI
//import Foundation
//
//// MARK: - Weather Data Model
////struct WeatherData: Decodable {
////    let daily: [Daily]
////    
////    struct Daily: Decodable {
////        let dt: Int
////        let temp: Temp
////        let weather: [Weather]
////        
////        struct Temp: Decodable {
////            let day: Double
////        }
////        
////        struct Weather: Decodable {
////            let id: Int
////            let main: String
////            let description: String
////            let icon: String // Used for fetching weather icons
////        }
////    }
////}
//struct ForecastData: Decodable {
//    let list: [Forecast]
//    
//    struct Forecast: Decodable {
//        let dt: Int
//        let main: Main
//        let weather: [Weather]
//        let dt_txt: String
//        
//        struct Main: Decodable {
//            let temp: Double
//        }
//        
//        struct Weather: Decodable {
//            let description: String
//            let icon: String
//        }
//    }
//}
//
//// MARK: - Weather Service
//class WeatherService {
//    func fetchWeatherForecast(latitude: Double, longitude: Double, apiKey: String, completion: @escaping (Result<ForecastData, Error>) -> Void) {
//            let urlString = "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
//            guard let url = URL(string: urlString) else { return }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                    return
//                }
//                
//                guard let data = data else { return }
//                
//                do {
//                    let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(forecastData))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }.resume()
//        }
//    }
//
//// MARK: - Weather ViewModel
//class WeatherViewModel: ObservableObject {
//    @Published var weatherData: ForecastData?
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private var weatherService = WeatherService()
//    
//    func fetchWeeklyWeather(latitude: Double, longitude: Double) {
//        isLoading = true
//        let apiKey = "82e7fdadfd0eee2dccd54d8970ef3d87" // Use your API key
//        weatherService.fetchWeeklyWeather(latitude: latitude, longitude: longitude, apiKey: apiKey) { [weak self] result in
//            DispatchQueue.main.async { // Ensure we're on the main thread when updating the view
//                self?.isLoading = false
//                switch result {
//                case .success(let weatherData):
//                    self?.weatherData = weatherData
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Weather View
//struct WeatherView: View {
//    @StateObject var viewModel = WeatherViewModel()
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                Text("Weekly Weather").bold().font(.title).padding()
//                
//                if viewModel.isLoading {
//                    ProgressView().frame(maxWidth: .infinity, alignment: .center)
//                } else if let weatherData = viewModel.weatherData {
//                    ForEach(weatherData.daily.indices, id: \.self) { index in
//                        let daily = weatherData.daily[index]
//                        HStack {
//                            Text(Date(timeIntervalSince1970: TimeInterval(daily.dt)), style: .date)
//                                .bold()
//                            Spacer()
//                            Image(systemName: weatherIcon(systemIconName: daily.weather.first?.icon ?? ""))
//                                .foregroundColor(.blue)
//                            Spacer()
//                            Text("\(daily.temp.day, specifier: "%.0f")°F")
//                                .bold()
//                        }.padding()
//                    }
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text("Error: \(errorMessage)")
//                }
//            }
//        }
//        .onAppear {
//            viewModel.fetchWeeklyWeather(latitude: 37.7749, longitude: -122.4194) // Example: San Francisco coordinates
//        }
//    }
//    
//    func weatherIcon(systemIconName: String) -> String {
//        switch systemIconName {
//        case "01d": return "sun.max.fill"
//        case "01n": return "moon.fill"
//        // Add more cases based on OpenWeatherMap icon codes and corresponding SF Symbols
//        default: return "cloud"
//        }
//    }
//}
//
//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView()
//    }
//}

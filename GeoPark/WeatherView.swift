
//  WeatherView.swift
//  GeoPark


import SwiftUI
import WeatherKit
import CoreLocation

// ViewModel to manage weather data fetching
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService = WeatherService()
    private let location: CLLocation

    init(latitude: Double, longitude: Double) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        fetchWeather()
    }

    func fetchWeather() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                DispatchQueue.main.async {
                    self.currentWeather = weather.currentWeather
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

// Custom formatter for temperature
private let temperatureFormatter: MeasurementFormatter = {
    let formatter = MeasurementFormatter()
    formatter.unitStyle = .medium
    formatter.unitOptions = .temperatureWithoutUnit
    formatter.numberFormatter.maximumFractionDigits = 1
    return formatter
}()





// SwiftUI View for displaying weather
struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let weather = viewModel.currentWeather {
                Text("Campus Weather Forecast").font(.title)
                Spacer()
                VStack(spacing: 10) {
                    Text("Dahlonega Currently").font(.title)
                    Text("Current Temperature: \(temperatureFormatter.string(from: weather.temperature))").bold()
                    Text("Conditions: \(weather.condition.description)").italic()
                }
                .font(.title2)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}

//Preview for WeatherView
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(latitude: 34.0522, longitude: -118.2437)) // Using Los Angeles coordinates for example
    }
}


//
//// Importing necessary modules for UI, weather data handling, and location services.
//import SwiftUI
//import WeatherKit
//import CoreLocation
//
//// ViewModel to manage fetching and updating weather data from WeatherKit.
//class WeatherViewModel: ObservableObject {
//    @Published var currentWeather: CurrentWeather? // The current weather, updated asynchronously.
//    @Published var isLoading = false // Tracks loading state of the weather data.
//    @Published var errorMessage: String? // Stores error message in case of failed fetch.
//
//    private let weatherService = WeatherService() // Weather service instance to fetch weather data.
//    private let location: CLLocation // Location for which to fetch the weather.
//
//    // Initializes with specific latitude and longitude.
//    init(latitude: Double, longitude: Double) {
//        self.location = CLLocation(latitude: latitude, longitude: longitude)
//        fetchWeather() // Start fetching weather immediately upon initialization.
//    }
//
//    // Fetches weather data asynchronously using WeatherKit.
//    func fetchWeather() {
//        isLoading = true // Mark as loading.
//        errorMessage = nil // Reset any existing errors.
//
//        Task {
//            do {
//                let weather = try await weatherService.weather(for: location)
//                DispatchQueue.main.async {
//                    self.currentWeather = weather.currentWeather // Update weather data on main thread.
//                    self.isLoading = false // Mark loading as complete.
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = error.localizedDescription // Handle and store any errors.
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//}
//
//// MeasurementFormatter to format temperature values.
//private let temperatureFormatter: MeasurementFormatter = {
//    let formatter = MeasurementFormatter()
//    formatter.unitStyle = .medium
//    formatter.unitOptions = .temperatureWithoutUnit
//    formatter.numberFormatter.maximumFractionDigits = 1
//    return formatter
//}()
//
//// SwiftUI view for displaying weather information.
//struct WeatherView: View {
//    @StateObject var viewModel: WeatherViewModel // StateObject for observing changes in the ViewModel.
//
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView() // Show a progress indicator while loading.
//            } else if let weather = viewModel.currentWeather {
//                Text("Campus Weather Forecast").font(.title)
//                Spacer()
//                VStack(spacing: 10) {
//                    Text("Dahlonega Currently").font(.title)
//                    Text("Current Temperature: \(temperatureFormatter.string(from: weather.temperature))").bold()
//                    Text("Conditions: \(weather.condition.description)").italic()
//                }
//                .font(.title2)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
//                Spacer()
//            } else if let errorMessage = viewModel.errorMessage {
//                Text("Error: \(errorMessage)").foregroundColor(.red) // Display any errors encountered.
//            }
//        }
//        .padding()
//        .onAppear {
//            viewModel.fetchWeather() // Ensure weather is fetched when view appears.
//        }
//    }
//}
//
//// SwiftUI Preview for developers.
//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView(viewModel: WeatherViewModel(latitude: 34.0522, longitude: -118.2437)) // Preview using sample coordinates.
//    }
//}

//
//  geotest.swift
//  GeoPark
//
//  Created by Will Kelley on 4/4/24.
//

//import SwiftUI

import SwiftUI
import CoreLocation

struct geotest: View {
    @State var viewModel = NewLocationManagerViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            if viewModel.isInSeikoStore {
                Text("Check Amazing Watches - The Latests Trends")
                    .font(.largeTitle)
            }
            
            Image(systemName: viewModel.isInSeikoStore ? "watch.analog" : "globe")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding()
            
            Text("Location manager: \(viewModel.location?.description ?? "No Location Provided!")")
            
        }
        .sheet(isPresented: $viewModel.shouldShowGoodByeSheet, content: {
            Text("See you soon!")
                .font(.largeTitle)
            Image(systemName: "watch.analog")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding()
        })
        .padding()
        .task {
            try? await viewModel.requestUserAuthorization()
            await viewModel.monitorSeikoStoreRegion()
            try? await viewModel.startCurrentLocationUpdates()
        }
    }
}

//#Preview {
//    geotest()
//}

@Observable
class NewLocationManagerViewModel: NSObject, CLLocationManagerDelegate {
    var location: CLLocation? = nil
    var isInSeikoStore = false
    var shouldShowGoodByeSheet = false
    private let regionIdentifier = "SeikoRegion"
    
    private let locationManager = CLLocationManager()
    private var monitor: CLMonitor? // we need a new object here
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startCurrentLocationUpdates() async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let location = locationUpdate.location else { return }
            
            self.location = location
        }
    }
    
    func monitorSeikoStoreRegion() async {
        if monitor == nil {
            monitor = await CLMonitor("MonitorID")
        }
        //34.528626,-83.991702
        await monitor?.add(CLMonitor.CircularGeographicCondition(center: CLLocationCoordinate2D(latitude: 34.52865, longitude: 83.99156), radius: 20), identifier: regionIdentifier, assuming: .unsatisfied)
        //34.52865° N, 83.99156° W
        Task {            guard let monitor else { return }
            for try await event in await monitor.events {
                    switch event.state {
                    case .satisfied: // you will receive the callback here when user ENTER any of the registered regions.
                        enterSeikoStoreRegion()
                    case .unknown, .unsatisfied: // you will receive the callback here when user EXIT any of the registered regions.
                        exitSeikoStoreRegion()
                    default:
                        print("No Location Registered")
                    }
            }
        }
    }
    
    func enterSeikoStoreRegion() {
        isInSeikoStore = true
        print("didEnterRegion run")
    }
    
    func exitSeikoStoreRegion() {
        shouldShowGoodByeSheet = true
        isInSeikoStore = false
        print("didExitRegion run")
    }
}

//#Preview {
//    geotest()
//}

//import SwiftUI
//import CoreLocation
//import Combine
//
//// Ensure this is '@ObservedObject' if the instance is created within the view.
//// Use '@StateObject' if the view model is instantiated by the view for the first time to retain its state.
//struct geotest: View {
//    @StateObject var viewModel = LocationManagerViewModel()
//
//    var body: some View {
//        VStack(spacing: 8) {
//            if viewModel.isInSeikoStore {
//                Text("Check Amazing Watches - See The Latest Trends")
//                    .font(.largeTitle)
//            }
//
//            Image(systemName: viewModel.isInSeikoStore ? "watch.analog" : "globe")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 150)
//                .padding()
//
//            Text("Location manager: \(viewModel.location?.description ?? "No Location Provided!")")
//
//        }
//        .sheet(isPresented: $viewModel.shouldShowGoodByeSheet) {
//            Text("See you soon!")
//                .font(.largeTitle)
//            Image(systemName: "watch.analog")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 150)
//                .padding()
//        }
//        .padding()
//        .onAppear {
//            viewModel.requestUserAuthorization()
//            viewModel.startMonitoringSeikoStoreRegion()
//        }
//    }
//}
//
//// Changed '@Observable' to '@ObservableObject' which is the correct attribute
//class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var location: CLLocation? = nil
//    @Published var isInSeikoStore = false
//    @Published var shouldShowGoodByeSheet = false
//    private let regionIdentifier = "SeikoRegion"
//
//    private let locationManager = CLLocationManager()
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func requestUserAuthorization() {
//        // It's not necessary to call this function asynchronously
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func startMonitoringSeikoStoreRegion() {
//        // Check authorization status before starting monitoring
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//           CLLocationManager.authorizationStatus() == .authorizedAlways {
//
//            // Define the region you want to monitor
//            let seikoStoreCenter = CLLocationCoordinate2D(latitude: 34.528626, longitude: -83.991702)
//            let seikoStoreRegion = CLCircularRegion(center: seikoStoreCenter, radius: 20, identifier: regionIdentifier)
//            seikoStoreRegion.notifyOnEntry = true
//            seikoStoreRegion.notifyOnExit = true
//
//            // Start monitoring the region
//            locationManager.startMonitoring(for: seikoStoreRegion)
//        }
//    }
//
//    // MARK: CLLocationManagerDelegate
//
//    // Called when the user's location is updated
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.location = locations.last
//    }
//
//    // Called when a user enters a monitored region
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if region.identifier == regionIdentifier {
//            DispatchQueue.main.async {
//                self.isInSeikoStore = true
//                self.shouldShowGoodByeSheet = false
//            }
//        }
//    }
//
//    // Called when a user exits a monitored region
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region.identifier == regionIdentifier {
//            DispatchQueue.main.async {
//                self.isInSeikoStore = false
//                self.shouldShowGoodByeSheet = true
//            }
//        }
//    }
//
//    // Handle authorization changes
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            // Start location updates
//            locationManager.startUpdatingLocation()
//            // Start monitoring the region if authorization is granted
//            startMonitoringSeikoStoreRegion()
//        }
//    }
//
//    // Handle possible errors
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        print("Monitoring failed for region with identifier: \(region?.identifier ?? "")")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location Manager failed with the following error: \(error)")
//    }
//}
//
//// The 'GeotestView' struct should be used to generate previews.
//struct geotest_Previews: PreviewProvider {
//    static var previews: some View {
//        geotest()
//    }
//}
//

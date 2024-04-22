//
//  HomeTestView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/11/24.
// Go Simple Single User

//import SwiftUI

//struct HomeTestView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    HomeTestView()
//}
//import SwiftUI
//import MapKit
//import CoreLocation
//import UserNotifications
//import CloudKit
//
//// ViewModel to manage location and notifications
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    let publicDB = CKContainer.default().publicCloudDatabase // Use public database
//    @Published var isInSeikoStore = false
//    let totalParkingSpaces = 50 // Total number of parking spaces
//    @Published var availableSpaces: Int = 0 // Tracks available parking spaces
//
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        requestPermissions()
//    }
//    
//    func requestPermissions() {
//        locationManager?.requestAlwaysAuthorization()
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
//            guard granted, let self = self else { return }
//            DispatchQueue.main.async {
//                self.setupGeofence()
//            }
//        }
//    }
////34.52958° N, 83.98424° W Cottrell
//    
////34.528724 -83.988236 Road by Diner
//    func setupGeofence() {
//        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: 34.528724, longitude: -83.988236)
//        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 20, identifier: "Cottrell")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//        locationManager?.startMonitoring(for: geofenceRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        updateGeofenceEventInCloud(entered: true)
//        fetchCurrentCountAndCalculateSpaces()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        updateGeofenceEventInCloud(entered: false)
//        fetchCurrentCountAndCalculateSpaces()
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        notificationCenter.add(request)
//    }
//
//    func updateGeofenceEventInCloud(entered: Bool) {
//        // Example of creating a record; you may want to modify this for server communication
//            let url = URL(string: entered ? "http://127.0.0.1:5000/api/enter" : "http://127.0.0.1:5000/api/exit")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let body: [String: Any] = ["userId": "uniqueUserID", "geofenceId": "cottrellParking", "entered": entered]
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Network error: \(error)")
//                    return
//                }
//                // Handle the server response here
//                print("Geofence event updated on server.")
//            }.resume()
//        }
////        let record = CKRecord(recordType: "GeofenceEvent")
////        record["userId"] = "uniqueUserID" as CKRecordValue
////        record["geofenceId"] = "cottrellParking" as CKRecordValue
////        record["entered"] = entered as CKRecordValue
////        record["timestamp"] = Date() as CKRecordValue
////        
////        publicDB.save(record) { record, error in
////            if let error = error {
////                print("Error saving record: \(error)")
////                return
////            }
////            print("Geofence event saved successfully.")
////        }
////    }
//
//    func fetchCurrentCountAndCalculateSpaces() {
//        let url = URL(string: "http://127.0.0.1:5000/api/count")!
//            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//                guard let self = self, let data = data else {
//                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//                
//                do {
//                    let countResult = try JSONDecoder().decode([String: Int].self, from: data)
//                    if let count = countResult["count"] {
//                        DispatchQueue.main.async {
//                            // Ensure self.totalParkingSpaces is not optional, or handle if it is
//                            self.availableSpaces = max(self.totalParkingSpaces - count, 0)
//                        }
//                    } else {
//                        print("Count key is missing in the decoded JSON")
//                    }
//                } catch {
//                    print("Decoding error: \(error)")
//                }
//            }.resume()
//        }
////        let predicate = NSPredicate(format: "geofenceId == %@ AND entered == true", "cottrellParking")
////        let query = CKQuery(recordType: "GeofenceEvent", predicate: predicate)
////        
////        publicDB.perform(query, inZoneWith: nil) { [weak self] records, error in
////            if let error = error {
////                print("Error fetching records: \(error)")
////                return
////            }
////            guard let records = records, let strongSelf = self else { return }
////            let currentCount = records.count
////            DispatchQueue.main.async {
////                strongSelf.availableSpaces = max(strongSelf.totalParkingSpaces - currentCount, 0)
////            }
////        }
////    }
//    
//}
//
//// SwiftUI View
//struct HomeTestView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.52860, longitude: -83.98626),
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
//    @ObservedObject var viewModel = LocationViewModel()
//    
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $region).ignoresSafeArea()
//            VStack {
//                Text("Available Spaces: \(viewModel.availableSpaces)")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.black.opacity(0.5))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//
//                Spacer() // Pushes everything to the top
//            }
//        }
//    }
//}



// Version 3
import SwiftUI
import MapKit
import CoreLocation
import UserNotifications

// Version 3 : This displays
// ViewModel to manage location and notifications
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var isInGeofence = false
//
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        requestPermissions()
//    }
//    
//    func requestPermissions() {
//        locationManager?.requestAlwaysAuthorization()
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
//            guard granted, let self = self else { return }
//            DispatchQueue.main.async {
//                self.setupGeofence()
//            }
//        }
//    }
//    
//    func setupGeofence() {
//        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: 34.528724, longitude: -83.988236)
//        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 20, identifier: "Cottrell")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//        locationManager?.startMonitoring(for: geofenceRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        sendNotification(title: "Geofence Entry", body: "You have entered the geofence.")
//        isInGeofence = true
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        sendNotification(title: "Geofence Exit", body: "You have exited the geofence.")
//        isInGeofence = false
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        notificationCenter.add(request)
//    }
//}
//
//// SwiftUI View
//struct HomeTestView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.52860, longitude: -83.98626),
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
//    @ObservedObject var viewModel = LocationViewModel()
//    
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $region).ignoresSafeArea()
//            VStack {
//                Text(viewModel.isInGeofence ? "Inside Geofence" : "Outside Geofence")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.black.opacity(0.5))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//
//                Spacer() // Pushes everything to the top
//            }
//        }
//    }
//}

// Version 4
//import SwiftUI
//import MapKit
//import CoreLocation
//import UserNotifications
//
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var isInGeofence = false // suppose to be false
//    @Published var availableParkingSpaces = 50 // Initialize with total parking spaces
//
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        requestPermissions()
//    }
//
//    func requestPermissions() {
//        locationManager?.requestAlwaysAuthorization()
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
//            guard granted, let self = self else { return }
//            DispatchQueue.main.async {
//                self.setupGeofence()
//            }
//        }
//    }
//
//    func setupGeofence() {
//        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: 34.528724, longitude: -83.988236)
//        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 150, identifier: "Cottrell")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//        locationManager?.startMonitoring(for: geofenceRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        sendNotification(title: "Geofence Entry", body: "You have entered the geofence.")
//        isInGeofence = true
//        availableParkingSpaces -= 1 // Decrement the available parking spaces
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        sendNotification(title: "Geofence Exit", body: "You have exited the geofence.")
//        isInGeofence = false //is suppose to be false
//        availableParkingSpaces += 1 // Increment the available parking spaces when leaving
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        notificationCenter.add(request)
//    }
//}
//
//
////
//struct HomeTestView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.52860, longitude: -83.98626),
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
//    @ObservedObject var viewModel = LocationViewModel()
//
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $region).ignoresSafeArea()
//            VStack {
//                Text(viewModel.isInGeofence ? "Inside Geofence" : "Outside Geofence")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.black.opacity(0.5))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//
//                Spacer() // Pushes everything to the top
//            }
//        }
//    }
//}

// Version 5 Works
//struct ParkingLocation: Identifiable {
//    let id: UUID = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//    var capacity: Int
//    @Published var availableSpaces: Int
//}
//
//// ViewModel to manage location, notifications, and parking locations
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var isInGeofence = false
//    @Published var availableParkingSpaces = 50 // Initialize with total parking spaces
//    
//    // You need to change the coordinates on these to match all of the parking locations on campus 
//    @Published var parkingLocations: [ParkingLocation] = [
//        ParkingLocation(name: "L32 Walker Dr. Parking Deck (Suites)", coordinate: CLLocationCoordinate2D(latitude: 34.022, longitude: -118.285)),
//        ParkingLocation(name: "L14 Parking Deck (Gym)", coordinate: CLLocationCoordinate2D(latitude: 34.025, longitude: -118.280)),
//        ParkingLocation(name: "Drill Field", coordinate: CLLocationCoordinate2D(latitude: 34.52854, longitude: -83.98641))
//        // Add more locations as needed
//    ]
//
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        requestPermissions()
//    }
//
//    func requestPermissions() {
//        locationManager?.requestAlwaysAuthorization()
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
//            guard granted, let self = self else { return }
//            DispatchQueue.main.async {
//                self.setupGeofence()
//            }
//        }
//    }
//
//    func setupGeofence() {
//        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: 34.528724, longitude: -83.988236)
//        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 150, identifier: "Cottrell")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//        locationManager?.startMonitoring(for: geofenceRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        sendNotification(title: "Geofence Entry", body: "You have entered the geofence.")
//        isInGeofence = true
//        availableParkingSpaces -= 1 // Decrement the available parking spaces
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        sendNotification(title: "Geofence Exit", body: "You have exited the geofence.")
//        isInGeofence = false
//        availableParkingSpaces += 1 // Increment the available parking spaces when leaving
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        notificationCenter.add(request)
//    }
//}
//
//struct HomeTestView: View {
//    @StateObject var viewModel = LocationViewModel()
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.52860, longitude: -83.98626),
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
//
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $region, annotationItems: viewModel.parkingLocations) { location in
//                MapAnnotation(coordinate: location.coordinate) {
//                    VStack {
//                        Image(systemName: "car.fill")
//                            .foregroundColor(.blue)
//                            .onTapGesture {
//                                print("Tapped \(location.name)")
//                            }
//                        Text(location.name)
//                            .font(.caption)
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//            .ignoresSafeArea()
//
//            VStack {
//                Text(viewModel.isInGeofence ? "Inside Geofence" : "Outside Geofence")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.black.opacity(0.5))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//
//                Spacer() // Pushes everything to the top
//            }
//        }
//    }
//}





//// Define parking location with capacity and available spaces
//struct ParkingLocation: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//    var capacity: Int
//    var availableSpaces: Int
//}
//
//// ViewModel to manage location, notifications, and parking locations
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var parkingLocations: [ParkingLocation] = [
//        ParkingLocation(name: "L32 Walker Dr. Parking Deck (Suites)", coordinate: CLLocationCoordinate2D(latitude: 34.022, longitude: -118.285), capacity: 50, availableSpaces: 50),
//        ParkingLocation(name: "L14 Parking Deck (Gym)", coordinate: CLLocationCoordinate2D(latitude: 34.025, longitude: -118.280), capacity: 30, availableSpaces: 30),
//        // Add more locations as needed
//    ]
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.0235, longitude: -118.2825),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        requestPermissions()
//    }
//
//    func requestPermissions() {
//        locationManager?.requestAlwaysAuthorization()
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
//            guard granted, let self = self else { return }
//            DispatchQueue.main.async {
//                self.setupGeofence()
//            }
//        }
//    }
//
//    func setupGeofence() {
//        // Assuming you would set up a geofence for each parking location
//        for location in parkingLocations {
//            let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name)
//            geofenceRegion.notifyOnEntry = true
//            geofenceRegion.notifyOnExit = true
//            locationManager?.startMonitoring(for: geofenceRegion)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if let locationIndex = parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
//            parkingLocations[locationIndex].availableSpaces = max(parkingLocations[locationIndex].availableSpaces - 1, 0)
//            sendNotification(title: "Geofence Entry", body: "Entered \(region.identifier).")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if let locationIndex = parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
//            parkingLocations[locationIndex].availableSpaces = min(parkingLocations[locationIndex].availableSpaces + 1, parkingLocations[locationIndex].capacity)
//            sendNotification(title: "Geofence Exit", body: "Exited \(region.identifier).")
//        }
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        notificationCenter.add(request)
//    }
//}
//
//
//// SwiftUI View displaying the map with annotations
//struct HomeTestView: View {
//    @StateObject var viewModel = LocationViewModel()
//
//    var body: some View {
//        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.parkingLocations) { location in
//            MapAnnotation(coordinate: location.coordinate) {
//                VStack {
//                    Image(systemName: "car.fill")
//                        .foregroundColor(.blue)
//                        .onTapGesture {
//                            print("Tapped \(location.name)")
//                        }
//                    Text(location.name)
//                        .font(.caption)
//                    Text("Available: \(location.availableSpaces)/\(location.capacity)")
//                        .font(.caption2)
//                        .foregroundColor(.green)
//                }
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//
//// SwiftUI Preview
//struct HomeTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTestView()
//    }
//}



// Version 6:
// Define parking location with capacity and available spaces
struct ParkingLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var capacity: Int
    var availableSpaces: Int
}

// ViewModel to manage location, notifications, and parking locations
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var parkingLocations: [ParkingLocation] = [
        ParkingLocation(name: "L32 Walker Dr. Parking Deck (Suites)", coordinate: CLLocationCoordinate2D(latitude: 34.022, longitude: -118.285), capacity: 50, availableSpaces: 50),
        ParkingLocation(name: "L14 Parking Deck (Gym)", coordinate: CLLocationCoordinate2D(latitude: 34.025, longitude: -118.280), capacity: 30, availableSpaces: 30),
        // Add more locations as needed
    ]
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0235, longitude: -118.2825),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        setupNotifications()
    }

    func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            guard granted, let self = self else { return }
            DispatchQueue.main.async {
                self.setupGeofence()
            }
        }
    }

    func setupGeofence() {
        // Set up a geofence for each parking location
        for location in parkingLocations {
            let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name)
            geofenceRegion.notifyOnEntry = true
            geofenceRegion.notifyOnExit = true
            locationManager?.startMonitoring(for: geofenceRegion)
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        DispatchQueue.main.async {
            if let locationIndex = self.parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
                self.parkingLocations[locationIndex].availableSpaces = max(self.parkingLocations[locationIndex].availableSpaces - 1, 0)
                self.sendNotification(title: "Geofence Entry", body: "Entered \(region.identifier).")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DispatchQueue.main.async {
            if let locationIndex = self.parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
                self.parkingLocations[locationIndex].availableSpaces = min(self.parkingLocations[locationIndex].availableSpaces + 1, self.parkingLocations[locationIndex].capacity)
                self.sendNotification(title: "Geofence Exit", body: "Exited \(region.identifier).")
            }
        }
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
// howdy
// SwiftUI View displaying the map with annotations
struct HomeTestView: View {
    @StateObject var viewModel = LocationViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.parkingLocations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            print("Tapped \(location.name)")
                        }
                    Text(location.name)
                        .font(.caption)
                    Text("Available: \(location.availableSpaces)/\(location.capacity)")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// SwiftUI Preview
struct HomeTestView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTestView()
    }
}

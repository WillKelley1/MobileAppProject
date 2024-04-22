//
//  ContentView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/4/24.
//
//import SwiftUI
//import CoreLocation
//import UserNotifications
//
//// ViewModel to manage location and notifications
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published var isInSeikoStore = false
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
//    //34.52865° N, 83.99156° W
//    //Can I make the geofence a square instead
//    func setupGeofence() {
//        // Define the dorm room's location and geofence radius
//        let dormLocation = CLLocationCoordinate2D(latitude: 34.52897, longitude: -83.98278) // Coordinates for
//        // Dorm Location :CLLocationCoordinate2D(latitude: 34.52865, longitude: -83.99156)
//        // Left Side of the Cottrell Center for Demonstration purposes
//        //34.52897° N, 83.98278° W
//        let geofenceRegion = CLCircularRegion(center: dormLocation, radius: 10, identifier: "DormRoom")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//
//        locationManager?.startMonitoring(for: geofenceRegion)
//    }
//    
//    // Handle entry and exit events
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        //self.isInSeikoStore = true;
//        sendNotification(title: "Welcome Back!", body: "You've entered your dorm room.")
////        if let location = manager.location {
////                let latitude = location.coordinate.latitude
////                let longitude = location.coordinate.longitude
////                let body = "You've entered your dorm room. Current Location: \(latitude), \(longitude)"
////                sendNotification(title: "Welcome Back!", body: body)
////            } else {
////                sendNotification(title: "Welcome Back!", body: "You've entered your dorm room.")
////            }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        sendNotification(title: "Goodbye!", body: "You're leaving your dorm room.")
//        //self.isInSeikoStore = true;
//    }
//    
//    // Local Notification
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        notificationCenter.add(request)
//    }
//    // Add debugging prints
//        func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//            print("Started monitoring geofence: \(region.identifier)")
//        }
//        
//        func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//            print("Monitoring failed for region: \(region?.identifier ?? "Unknown") with error: \(error.localizedDescription)")
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Location manager failed with error: \(error.localizedDescription)")
//        }
//}
//
//struct ContentView: View {
//    @ObservedObject var viewModel = LocationViewModel()
//    
//    var body: some View {
//        Text("Geofence Monitoring Active")
//            .padding()
////        VStack(spacing: 8) {
////            if viewModel.isInSeikoStore {
////                Text("Check Amazing Watches - The Latests Trends")
////                    .font(.largeTitle)
////            }
////            
////            Image(systemName: viewModel.isInSeikoStore ? "watch.analog" : "globe")
////                .resizable()
////                .scaledToFit()
////                .frame(width: 150)
////                .padding()
////            
//////            Text("Location manager: \(viewModel.location?.description ?? "No Location Provided!")")
////            
////        }
//        
//        
//        
//    }
//}
//
//#Preview {
//    ContentView()
//}

//@main
//struct GeofenceApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


//
//import SwiftUI
//import CoreLocation
//import MapKit
//
//struct GeofenceView: View {
//    @StateObject private var viewModel = GeofenceViewModel()
//
//    var body: some View {
//        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: .follow, overlays: viewModel.overlays)
//            .onAppear {
//                viewModel.setupGeofence()
//            }
//            .ignoresSafeArea()
//            .alert(item: $viewModel.userPrompt) { prompt in
//                Alert(title: Text(prompt.title), message: Text(prompt.message), dismissButton: .default(Text("OK")))
//            }
//    }
//}
//
//class GeofenceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.009020), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//    @Published var overlays: [MKOverlay] = []
//    @Published var userPrompt: UserPrompt?
//
//    private var locationManager: CLLocationManager?
//    
//    override init() {
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
//    }
//    
//    func setupGeofence() {
//        let geofenceCenter = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.009020)
//        let geofenceRadius: CLLocationDistance = 100
//        let geofenceRegion = CLCircularRegion(center: geofenceCenter, radius: geofenceRadius, identifier: "MyGeofence")
//        geofenceRegion.notifyOnEntry = true
//        geofenceRegion.notifyOnExit = true
//        locationManager?.startMonitoring(for: geofenceRegion)
//        
//        // Add overlay for visualization
//        let circleOverlay = MKCircle(center: geofenceCenter, radius: geofenceRadius)
//        overlays.append(circleOverlay)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        userPrompt = UserPrompt(title: "Geofence Entered", message: "You have entered a geofenced area.")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        userPrompt = UserPrompt(title: "Geofence Exited", message: "You have exited a geofenced area.")
//    }
//}
//
//struct UserPrompt: Identifiable {
//    var id = UUID()
//    var title: String
//    var message: String
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeofenceView()
//    }
//}

// 34.52869° N, 83.99166° W
//@main
//struct GeoParkApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

//
//  HomeView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/9/24.
//
//
//import SwiftUI
//import MapKit
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
//        let geofenceRegion = CLCircularRegion(center: dormLocation, radius: 20, identifier: "Cottrell")
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
//
//struct HomeView: View {
//    @State private var selectedTab: Int = 0
//    @State private var showSettings: Bool = false
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.52860, longitude: -83.98626), // Example coordinates (New York City)
//        //34.52860° N, 83.98626° W
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        )
//    @ObservedObject var viewModel = LocationViewModel()
//    var body: some View {
//        ZStack {
////            LinearGradient(
////                gradient: Gradient(colors: [
////                    Color(hex:"#09203F"),
////                    Color(hex:"#596164")
////                    ]),
////                    startPoint: .top,
////                    endPoint: .bottom
////                )
////                .ignoresSafeArea()
//            Map(coordinateRegion: $region)
//                        .ignoresSafeArea() // This will make the map extend to the screen edges
//            VStack{
//                
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: { showSettings.toggle() }) {
//                            Image(systemName: "gear")
//                                .font(.system(size: 24))
//                                .padding()
//                                }
//                                .sheet(isPresented: $showSettings) {
//                                    SettingsView()
//                                   }
//                               }
//                               //Spacer()
//                           }
////                HStack(spacing: -1.0) {
////                    Text("GEO").font(.largeTitle).foregroundColor(Color.yellow)
////                    Text("PARK").font(.largeTitle).foregroundColor(Color.blue)
////                }.padding(.top, 330)
//                Spacer()
//                }
//                           
//                
//                       }
//                   }
//               }
//                
//                
//                
//            
//          
//
//struct SettingsView: View {
//    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Appearance")) {
//                    Toggle("Dark Mode", isOn: $isDarkMode)
//                }
//                
//                Section(header: Text("Support")) {
//                    Button("Write a Review") {
//                        // Add code to open App Store review page
//                    }
//                    
//                    NavigationLink(destination: AboutView()) {
//                        Text("About the App")
//                    }
//                }
//            }
//            .navigationBarTitle("Settings")
//        }
//    }
//}
//
//struct AboutView: View {
//    var body: some View {
//        VStack {
//            Text("GeoPark")
//                .font(.largeTitle)
//                .bold()
//            
//            Text("Version 1.0")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            Spacer()
//            
//            Text("App Description")
//                .padding()
//            Text("BCM is an app designed to connect and already connected group of believers through one app")
//            
//            Spacer()
//        }
//        .navigationBarTitle("About", displayMode: .inline)
//    }
//}
//
//#Preview {
//    HomeView()
//}

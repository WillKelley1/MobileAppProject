//
//  BasicView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/16/24.
//

import SwiftUI

struct BasicView: View {
    @StateObject private var locationViewModel = LocationViewModel()
    var body: some View {
        Text("Geofence Monitoring Active")
                .padding()
                .onAppear {
                        // Ensuring the ViewModel initializes
            }
    }
}

#Preview {
    BasicView()
}

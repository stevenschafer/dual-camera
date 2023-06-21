//
//  dual_cameraApp.swift
//  dual-camera
//
//  Created by Steven Schafer on 6/18/23.
//

import SwiftUI

@main
struct CameraApp: App {

    init() {
        UINavigationBar.applyCustomAppearance()
    }

    var body: some Scene {
        WindowGroup {
            CameraView()
        }
    }
}

fileprivate extension UINavigationBar {

    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

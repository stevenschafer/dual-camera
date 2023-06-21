//
//  CameraView.swift
//  dual-camera
//
//  Created by Steven Schafer on 6/19/23.
//

/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    @State private var isFlashing = false
    @State private var captureButtonAlignment: Alignment = .bottom

    private static let barHeightFactor = 0.15


    var body: some View {

        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottomTrailing) {

                    // Main camera
                    ViewfinderView(image:  $model.backViewfinderImage )
                        .overlay(alignment: captureButtonAlignment) {
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                        }
                        .animation(.easeInOut(duration: 0.1), value: captureButtonAlignment)
                        .task {
                            await model.camera.start()
                        }
                        .background(.black)

                    // Front camera
                    ViewfinderView(image:  $model.backViewfinderImage )
                        .frame(width: 122, height: 220)
                        .background(.black)
                        .cornerRadius(24)
                        .shadow(radius: 10, x: 0, y: 4)
                        .offset(x: position.width + dragOffset.width - 32, y: position.height + dragOffset.height - 128)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    position.height += value.translation.height
                                    position.width += value.translation.width
                                }
                        )

                    Color.white
                        .opacity(isFlashing ? 1 : 0)
                        .animation(.linear(duration: 0.1).repeatCount(2))
                }
            }
            .task {
//                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }

    private func buttonsView() -> some View {
        HStack(spacing: 60) {

            Spacer()

//            NavigationLink {
//                PhotoCollectionView(photoCollection: model.photoCollection)
//                    .onAppear {
//                        model.camera.isPreviewPaused = true
//                    }
//                    .onDisappear {
//                        model.camera.isPreviewPaused = false
//                    }
//            } label: {
//                Label {
//                    Text("Gallery")
//                } icon: {
//                    ThumbnailView(image: model.thumbnailImage)
//                }
//            }

            Button {
                generateHapticFeedback()

                // handle the simulated flash feedback animation
                isFlashing = true
                // Stop the flashing animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isFlashing = false
                }

                // take the photo
                model.camera.takePhoto()
            } label: {
                Image("Capture")
            }

//            Button {
//                model.camera.switchCaptureDevice()
//            } label: {
//                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
//                    .font(.system(size: 36, weight: .bold))
//                    .foregroundColor(.white)
//            }

            Spacer()

        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(.bottom, 32)
    }

    private func generateHapticFeedback() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success) // Choose the desired feedback type
        }

}

//struct FrontCameraView: View {
//    @StateObject private var model = DataModel()
//    @GestureState private var dragOffset = CGSize.zero
//    @State private var position = CGSize.zero
//
//    var body: some View {
//        VStack {
//            ViewfinderView(image:  $model.viewfinderImage )
//                .overlay(alignment: .center) {
//                    FrontCameraView()
//                }
//                .cornerRadius(10)
//                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
//                .gesture(
//                    DragGesture()
//                        .updating($dragOffset) { value, state, _ in
//                            state = value.translation
//                        }
//                        .onEnded { value in
//                            position.height += value.translation.height
//                            position.width += value.translation.width
//                        }
//                )
//        }
//        .task {
//            await model.camera.start()
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}


import HaishinKit
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let mixer: MediaMixer

    func makeUIView(context: Context) -> MTHKView {
        let view = MTHKView(frame: .zero)
        view.videoGravity = .resizeAspectFill

        Task {
            await mixer.addOutput(view)
        }

        return view
    }

    func updateUIView(_ uiView: MTHKView, context: Context) {}
}

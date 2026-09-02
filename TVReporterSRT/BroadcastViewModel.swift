import AVFoundation
import Foundation
import HaishinKit
import SRTHaishinKit
import SwiftUI

@MainActor
final class BroadcastViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case preparing
        case connecting
        case live
        case failed(String)

        var title: String {
            switch self {
            case .idle: return "PRONTO"
            case .preparing: return "PREPARANDO"
            case .connecting: return "CONECTANDO"
            case .live: return "NO AR"
            case .failed: return "ERRO"
            }
        }
    }

    @Published var settings = StreamSettings()
    @Published private(set) var state: State = .idle
    @Published var usingFrontCamera = false
    @Published var muted = false

    let mixer = MediaMixer()

    private var connection: SRTConnection?
    private var stream: SRTStream?
    private var isPrepared = false

    var isLive: Bool { state == .live }

    func requestPermissionsAndPrepare() async {
        guard !isPrepared else { return }
        state = .preparing

        let camera = await AVCaptureDevice.requestAccess(for: .video)
        let mic = await AVCaptureDevice.requestAccess(for: .audio)

        guard camera, mic else {
            state = .failed("Permita acesso à câmera e ao microfone nos Ajustes do iPhone.")
            return
        }

        do {
            try await attachDevices()
            isPrepared = true
            state = .idle
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    private func attachDevices() async throws {
        let position: AVCaptureDevice.Position = usingFrontCamera ? .front : .back
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            throw NSError(domain: "TVReporterSRT", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Não foi possível abrir a câmera."
            ])
        }

        guard let microphone = AVCaptureDevice.default(for: .audio) else {
            throw NSError(domain: "TVReporterSRT", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Não foi possível abrir o microfone."
            ])
        }

        try await mixer.attachVideo(camera)
        try await mixer.attachAudio(microphone)
    }

    func start() {
        guard !isLive else { return }

        Task {
            if !isPrepared {
                await requestPermissionsAndPrepare()
                guard isPrepared else { return }
            }

            state = .connecting

            let connection = SRTConnection()
            let stream = SRTStream(connection: connection)
            self.connection = connection
            self.stream = stream

            await mixer.addOutput(stream)

            do {
                // V1: conexão direta SRT Caller -> vMix Listener.
                // Os parâmetros de latência/streamid/passphrase são enviados pela URL.
                guard let srtURL = URL(string: settings.srtURL) else {
                    throw NSError(domain: "TVReporterSRT", code: 3, userInfo: [
                        NSLocalizedDescriptionKey: "A URL SRT configurada é inválida."
                    ])
                }

                try await connection.connect(srtURL)
                await stream.publish()
                state = .live
            } catch {
                state = .failed(error.localizedDescription)
                await cleanup()
            }
        }
    }

    func stop() {
        Task {
            await cleanup()
            state = .idle
        }
    }

    func toggleCamera() {
        Task {
            usingFrontCamera.toggle()
            do {
                try await attachDevices()
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }

    private func cleanup() async {
        if let stream {
            await stream.close()
            await mixer.removeOutput(stream)
        }
        if let connection {
            await connection.close()
        }
        self.stream = nil
        self.connection = nil
    }
}

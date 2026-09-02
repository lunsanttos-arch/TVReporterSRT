import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: BroadcastViewModel
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            CameraPreview(mixer: model.mixer)
                .ignoresSafeArea()

            LinearGradient(
                colors: [.black.opacity(0.55), .clear, .black.opacity(0.72)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    statusBadge
                    Spacer()
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }

                Spacer()

                VStack(spacing: 16) {
                    Text("\(model.settings.width)p • \(model.settings.fps) fps • \(model.settings.bitrateKbps / 1000) Mbps")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())

                    HStack(spacing: 18) {
                        Button(action: model.toggleCamera) {
                            Image(systemName: "camera.rotate.fill")
                                .font(.title2)
                                .frame(width: 54, height: 54)
                                .background(.ultraThinMaterial, in: Circle())
                        }

                        Button {
                            model.isLive ? model.stop() : model.start()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(model.isLive ? Color.red : Color.white)
                                    .frame(width: 86, height: 86)

                                if model.isLive {
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.white)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Circle()
                                        .stroke(.red, lineWidth: 6)
                                        .frame(width: 68, height: 68)
                                }
                            }
                        }

                        Button {
                            model.muted.toggle()
                        } label: {
                            Image(systemName: model.muted ? "mic.slash.fill" : "mic.fill")
                                .font(.title2)
                                .frame(width: 54, height: 54)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }

                    Text(model.isLive ? "TOQUE PARA ENCERRAR" : "ENTRAR AO VIVO")
                        .font(.headline)
                }
                .padding(.bottom, 22)
            }
            .padding()
        }
        .foregroundStyle(.white)
        .task {
            await model.requestPermissionsAndPrepare()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(model)
        }
        .alert("Falha na transmissão", isPresented: Binding(
            get: {
                if case .failed = model.state { return true }
                return false
            },
            set: { _ in }
        )) {
            Button("OK") { model.stop() }
        } message: {
            if case let .failed(message) = model.state {
                Text(message)
            }
        }
    }

    private var statusBadge: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(model.isLive ? .red : .green)
                .frame(width: 8, height: 8)
            Text(model.state.title)
                .font(.caption.bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

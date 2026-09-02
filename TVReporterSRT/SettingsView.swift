import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var model: BroadcastViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Destino SRT") {
                    TextField("IP / Host", text: $model.settings.host)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Porta", value: $model.settings.port, format: .number)
                        .keyboardType(.numberPad)

                    TextField("Stream ID (opcional)", text: $model.settings.streamID)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("Senha SRT (opcional)", text: $model.settings.passphrase)
                }

                Section("Baixa latência") {
                    Picker("Latência SRT", selection: $model.settings.latencyMs) {
                        Text("120 ms").tag(120)
                        Text("200 ms").tag(200)
                        Text("300 ms").tag(300)
                        Text("500 ms").tag(500)
                        Text("1000 ms").tag(1000)
                    }

                    Picker("Bitrate", selection: $model.settings.bitrateKbps) {
                        Text("2 Mbps").tag(2_000)
                        Text("3 Mbps").tag(3_000)
                        Text("4 Mbps").tag(4_000)
                        Text("6 Mbps").tag(6_000)
                        Text("8 Mbps").tag(8_000)
                    }

                    Picker("FPS", selection: $model.settings.fps) {
                        Text("30 fps").tag(30)
                        Text("60 fps").tag(60)
                    }
                }

                Section("URL gerada") {
                    Text(model.settings.srtURL)
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                }

                Section {
                    Text("Perfil inicial: SRT Caller → vMix Listener. O padrão já está configurado para 192.168.20.53:6767.")
                        .font(.footnote)
                }
            }
            .navigationTitle("Transmissão")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") { dismiss() }
                }
            }
        }
    }
}

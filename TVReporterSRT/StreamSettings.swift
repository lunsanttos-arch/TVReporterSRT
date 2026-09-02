import Foundation

struct StreamSettings: Codable, Equatable {
    var host: String = "192.168.20.53"
    var port: Int = 6767
    var latencyMs: Int = 200
    var bitrateKbps: Int = 4_000
    var fps: Int = 30
    var width: Int = 1920
    var height: Int = 1080
    var streamID: String = ""
    var passphrase: String = ""

    var srtURL: String {
        var components = URLComponents()
        components.scheme = "srt"
        components.host = host
        components.port = port

        var query: [URLQueryItem] = [
            URLQueryItem(name: "mode", value: "caller"),
            URLQueryItem(name: "latency", value: String(latencyMs))
        ]

        if !streamID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            query.append(URLQueryItem(name: "streamid", value: streamID))
        }

        if !passphrase.isEmpty {
            query.append(URLQueryItem(name: "passphrase", value: passphrase))
            query.append(URLQueryItem(name: "pbkeylen", value: "16"))
        }

        components.queryItems = query
        return components.string ?? "srt://\(host):\(port)"
    }
}

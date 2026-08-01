import Foundation

enum APIError: Error {
    case decodingError
    case httpError(Int, String)
    case unknown
}

class APIClient {

    static let baseURL = URL(string: "http://localhost:8000")!

    static func request<T: Codable>(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        headers: [String: String]? = nil,
        token: String? = nil
    ) async throws -> T {

        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.unknown
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("JO", forHTTPHeaderField: "X-Country-Code")
        if headers != nil {
            for (key, value) in headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // -------- REQUEST LOG --------
        print("""
        📤 REQUEST
        → \(method) \(url.absoluteString)
        """)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        // -------- RESPONSE LOG --------
        print("""
        📥 RESPONSE
        ← Status: \(http.statusCode)
        ← URL: \(url.absoluteString)
        """)

        // Optional: log response body (DEBUG ONLY)
        if let bodyString = String(data: data, encoding: .utf8) {
            print("← Body: \(bodyString)")
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.httpError(http.statusCode, message)
        }

        do {
            let jsondecoder = try JSONDecoder.apiDecoder.decode(
                T.self,
                from: data
            )
            return jsondecoder
        } catch {
            throw APIError.decodingError
        }
    }
}


extension JSONDecoder {

    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .useDefaultKeys

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

            guard let date = formatter.date(from: value) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid date: \(value)"
                )
            }

            return date
        }

        return decoder
    }
}

import Foundation
import CoreLocation

struct WeatherResult: Decodable {
    struct Main: Decodable { let temp: Double; let humidity: Int }
    struct Weather: Decodable { let description: String }
    let main: Main
    let weather: [Weather]
}

class WeatherService {
    // Replace with your OpenWeatherMap key when using
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResult, Error>) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "WeatherService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "WeatherService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(WeatherResult.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

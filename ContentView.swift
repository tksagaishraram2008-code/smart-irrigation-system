import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var statusText: String = "Idle"
    @State private var apiKey: String = "YOUR_API_KEY"

    private var weatherService: WeatherService {
        WeatherService(apiKey: apiKey)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Live Weather for Main Crop")
                .font(.title)

            Text(statusText)
                .padding()

            HStack(spacing: 12) {
                Button("Request Permission") {
                    locationManager.requestPermission()
                }
                Button("Get Location & Weather") {
                    statusText = "Requesting location..."
                    locationManager.requestLocation()
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .onReceive(locationManager.$location) { location in
            guard let loc = location else { return }
            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            statusText = String(format: "Location: %.5f, %.5f\nFetching weather...", lat, lon)

            weatherService.fetchWeather(lat: lat, lon: lon) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let w):
                        let cond = w.weather.first?.description ?? "-"
                        statusText = String(format: "Location: %.5f, %.5f\nTemp: %.1f°C\nHumidity: %d%%\nCondition: %@", lat, lon, w.main.temp, w.main.humidity, cond)
                    case .failure(let err):
                        statusText = "Weather fetch error: \(err.localizedDescription)"
                    }
                }
            }
        }
        .onReceive(locationManager.$errorMessage) { err in
            if let e = err {
                statusText = "Location error: \(e)"
            }
        }
        .onReceive(locationManager.$authorizationStatus) { status in
            switch status {
            case .notDetermined:
                break
            case .restricted, .denied:
                statusText = "Location denied/restricted — enable in Settings"
            default:
                break
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
#endif

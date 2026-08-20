iOS Sample: Location + Weather (SwiftUI)

This folder contains a minimal SwiftUI sample showing how to:

- Request runtime location permission (When In Use)
- Read the current location via CoreLocation
- Call OpenWeatherMap API using URLSession and display temperature/humidity/condition

Files added:
- LocationManager.swift  — ObservableObject wrapper around CLLocationManager
- WeatherService.swift   — Simple URLSession-based fetcher for OpenWeatherMap
- ContentView.swift      — SwiftUI view demonstrating permission flow and fetching
- Info.plist             — Minimal keys (NSLocationWhenInUseUsageDescription)

Setup / Integration

1) Create a new SwiftUI app in Xcode or add these files to your existing project.

2) Info.plist: Ensure NSLocationWhenInUseUsageDescription is present (this sample includes it).

3) Replace YOUR_API_KEY in ContentView.swift with your OpenWeatherMap API key.
   Sign up at https://openweathermap.org/ to obtain a key.

4) Usage notes:
   - This sample uses requestLocation() which asks the device for a single location update.
   - For better accuracy, consider using startUpdatingLocation() and debounce/filter updates.
   - If you need background updates, add the Background Modes capability and request
     appropriate background location permissions (with elevated review from Apple).

5) Integrating with the irrigation controller:
   - Send parsed weather data (temp, humidity, conditions) from the app to your backend API
     using HTTPS, or directly to the controller if it exposes a secure endpoint (MQTT/HTTPS).
   - Prefer server-side storage and decisioning if multiple devices/controllers need the data.

Want me to:
- Add a full runnable Xcode project structure (project file, targets)?
- Add example code to POST weather to your irrigation backend/controller?
- Implement a native Android + iOS sync flow to keep main crop location in a shared backend?

Choose the next step and I'll add it.
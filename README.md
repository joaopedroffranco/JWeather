# JWeather

**Note:** The `J` suffix denotes that this is an in-house solution tailored for our specific needs.

### Features
- Users can view the initial weather forecast for predefined coordinates (e.g., Amsterdam).
- Users can search for other locations worldwide.
- Tapping on a searched location displays its forecast data modally.
- The forecast information includes:
  - Location name
  - Temperature details (current, feels like, minimum, and maximum)
  - Weather description text and associated icon
  - Wind measurements
  - Precipitation data (rain or snow), when available
  - Alerts, which are crucial before heading out.

### Setup

- **Xcode Version:** 13.4.1 (Note: My personal MacBook does not support later versions.)
- **Minimum iOS Version:** 15.5 for the main target and packages.
- **Device Support:** Supports iPhone only, in portrait mode, as a landscape view is impractical for this use case.

### Technology Stack

- **UI Implementation:** Built using `SwiftUI` for ease of UI development.
- **ViewModel Architecture:** Implemented with `Combine` to enable reactive binding between views and enhance responsiveness.
- **Code Document:** Each file and entity is well-documented with detailed comments.
- **Tests:** Each view model and data layer is tested with diverse scenarios to ensure reliability and performance.
- **Memory Management:** The application is free of memory leaks and retain cycles, ensuring that all entities are properly deallocated.

### Frameworks

To ensure modularity, separation of concerns, and improved build times, the project is structured as follows:

- **JFoundation:** Contains shareable utilities and extensions.
- **JUI:** Implements the design system and UI components.
- **JData:** Manages network integration and data handling.
- **App:** The main bundle housing primary features:
  - **Home:** Displays the initial location and allows searches for additional locations.
  - **Forecast:** Shows the weather forecast for selected locations.

**Package Management:** Utilizes `Swift Package Manager` for managing local frameworks, providing a straightforward integration process.

**Dependency Management:** There are no circular dependencies in the project structure.
# Hoppr: AI trip itinerary planner

# Overview

[Hoppr](https://github.com/rainforelabs/hoppr) is an AI-powered trip itinerary planner app, built primarily in Swift. It leverages the [Google Gemini 3 Flash](https://deepmind.google/models/gemini/flash/) model to generate intelligent travel itineraries, communicating with the LLM via a custom API backed by the [Convex](https://www.convex.dev/) back end. The repository is maintained by [codestronaut](https://github.com/codestronaut) at [rainforelabs](https://github.com/rainforelabs).

![Hoppr Demo](https://raw.githubusercontent.com/rainforelabs/hoppr/refs/heads/main/hoppr-demo.gif)

---

## Features

- **AI Trip Planning**: Uses Gemini 3 Flash for smart, context-aware travel planning.
- **Modern iOS Architecture**: Written in Swift, leveraging SwiftUI and MapKit.
- **Custom Backend Integration**: Communicates with a secure, custom API ([hoppr-api](https://github.com/rainforelabs/hoppr-api)) built on Convex.

---

## Tech Stack

- **Language**: Swift
- **Frameworks & APIs**:
  - SwiftUI
  - MapKit
  - Gemini 3 Flash (via custom API)
  - Convex

---

## Repository Structure

- `Hoppr.xcodeproj/` — Xcode project file.
- `Hoppr/` — Application source code.
- `README.md` — Project overview (see below).
- `hoppr-demo.gif` — Application demo animation.

---

## Getting Started

### Prerequisites

- macOS with Xcode installed (latest recommended).
- Swift knowledge and iOS development basics.

**Note:**  
As this is a Proof-of-Concept (POC), no API key or special credentials are needed. All user data is tied to the device ID, so you can run and use Hoppr immediately after building.

### Setup

1. **Clone the Repository**
    ```bash
    git clone https://github.com/rainforelabs/hoppr.git
    cd hoppr
    ```

2. **Install Dependencies**
    - Open `Hoppr.xcodeproj` in Xcode. Dependencies (if any) will be managed via Swift Package Manager.

3. **Build & Run**
    - Select a simulator or your device in Xcode.
    - Press *Run* or use `Cmd+R`.

---

## Usage

1. Launch the app on your iOS device or simulator.
2. No signup or API key is required; the app uses your device ID for all data operations.
3. Enter your trip preferences or let Hoppr suggest options.
4. Review your AI-generated itinerary.

---

## Support & Contact

- Open an issue for bugs, feature requests, or discussions.
- You can reach the team via [rainforelabs](https://github.com/rainforelabs).

---

## License

*Currently no license file detected — please clarify licensing with the repository maintainers before reusing in commercial or open source projects.*

---

Built with ❤️ by [rainforelabs](https://github.com/rainforelabs)

# Event Management System

A Flutter-based Event Management System designed to simplify event organization, event discovery, scheduling, and ticket management. The application provides separate dashboards for **Administrators** and **Users**, with Firebase-powered authentication, real-time data management, chatbot integration, and dark mode support.

## Features

### Admin

* Create and manage events
* Manage event schedules
* Manage ticketing
* Manage event-related data
* Admin settings and controls

### User

* Browse available events
* View scheduled events
* Purchase and manage tickets
* Access event information
* User settings

### Common Features

* Firebase Authentication
* Google Sign-In
* Firebase Firestore
* Firebase Storage
* Gemini chatbot
* Dark and light mode
* Real-time data synchronization
* Responsive Flutter UI

## Tech Stack

| Technology              | Purpose                                |
| ----------------------- | -------------------------------------- |
| Flutter                 | Cross-platform application development |
| Dart                    | Application programming language       |
| Firebase Authentication | User authentication                    |
| Firebase Firestore      | Real-time database                     |
| Firebase Storage        | Event files and image storage          |
| Gemini                  | AI chatbot                             |
| GitHub                  | Version control and collaboration      |

## Architecture

The application follows a layered architecture to maintain separation of concerns, scalability, and maintainability.

```text
lib/
├── models/
│   ├── event_model.dart
│   └── user_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── event_service.dart
│   ├── chat_service.dart
│   └── firebase_storage_service.dart
│
├── views/
│   ├── admin/
│   ├── user/
│   └── common/
│
└── widgets/
    ├── event_card.dart
    ├── ticket_card.dart
    └── custom_button.dart
```

The project separates **Models**, **Services**, and **Views**, while reusable components such as `EventCard`, `TicketCard`, and `CustomButton` reduce code duplication.

## Application Flow

### Admin Dashboard

```text
Admin Dashboard
├── Event Registration
├── Event Schedule
├── Ticketing
├── Settings
└── Gemini Chatbot
```

### User Dashboard

```text
User Dashboard
├── Available Events
├── Scheduled Events
├── Ticketing
├── Settings
└── Gemini Chatbot
```

Both dashboards share access to the chatbot and common application functionality.

## Firebase Integration

Firebase is used as the application's backend infrastructure.

* **Firebase Authentication** — handles email/password and Google authentication.
* **Cloud Firestore** — stores event and user-related data with real-time synchronization.
* **Firebase Storage** — stores event images and documents.
* **Firebase Analytics** — supports monitoring and improvement of application usage.

The project transitioned from local storage to Firebase to improve scalability, security, synchronization, and cross-device data access.

## Testing & Quality Assurance

The application uses multiple testing approaches:

* **Unit Testing** — validates individual functions.
* **Integration Testing** — verifies interactions between application modules.
* **UI Testing** — checks responsiveness, accessibility, dark mode, and chatbot interactions.
* **Performance Testing** — evaluates application and database performance.
* **Edge Case Testing** — tests scenarios such as ticket cancellations and offline usage.

Tools used include **Flutter DevTools**, Flutter testing tools, and **Firebase Test Lab**.

## Development Methodology

The project follows an **Agile development approach** with:

* Iterative development
* Feature-based sprints
* Continuous testing
* User feedback
* Regular reviews and refinements
* GitHub-based version control

This approach allows features to be developed and improved incrementally throughout the project lifecycle.

## Performance & Quality Improvements

Several improvements were considered during development:

* Migration from local storage to Firebase Firestore
* Optimized event retrieval
* Batched and indexed Firestore queries
* Caching of frequently accessed data
* Improved offline functionality
* Comprehensive ticketing and authentication testing

These improvements target scalability, responsiveness, reliability, and user experience.

## Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Git
* A Firebase project

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/event-management-system.git
cd event-management-system
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase for your Flutter project.

Then run:

```bash
flutter run
```

## Project Goals

The main goals of the project are to:

* Simplify event organization
* Provide efficient ticket management
* Enable secure authentication
* Provide real-time event updates
* Deliver a scalable cross-platform application
* Improve the user experience through AI chatbot support and dynamic theming

## Future Improvements

Potential future improvements include:

* Automated CI/CD pipelines
* More advanced analytics
* Improved caching and offline support
* Additional ticketing features
* Expanded chatbot capabilities
* Further performance optimization

## Authors

**Zain Tahir**
FA23-BCE-111 — Sr. No. 32

**Shehryar Arif**
FA23-BCE-102 — Sr. No. 26

## License

This project was developed as part of a Software Engineering academic project.

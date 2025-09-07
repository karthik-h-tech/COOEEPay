# CooeePay

A Flutter app for plan selection and payment flow, designed for CallCooee's communication-focused audience. This app allows users to choose from Free, Premium, and Pro plans, apply promo codes, and simulate payment processing with a mock Stripe checkout API.

## Features

- **Plan Selection Screen**: Display three plans with vibrant UI, promo code validation, and navigation to payment confirmation.
- **Payment Confirmation Screen**: Show selected plan details, apply discounts, simulate API call, and display success/error animations.
- **Responsive Design**: Optimized for various screen sizes (iPhone SE, iPad, Android devices).
- **Brand Appeal**: Modern, communication-focused design with animations inspired by voice/video call aesthetics.
- **Mock API Integration**: Simulates Stripe checkout with configurable endpoint.

## Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to start the app on a connected device or emulator.

### Configuration
- To use a real mock API endpoint, set the `CHECKOUT_ENDPOINT` environment variable:
  ```
  flutter run --dart-define=CHECKOUT_ENDPOINT=https://your.mock/endpoint
  ```
- Without it, the app uses a local mock fallback.

## Project Structure
- `lib/core/`: Theme, responsive utilities, and helpers.
- `lib/features/checkout/`: Screens, widgets, models, providers, and services for the checkout flow.
- `assets/animations/`: Lottie animations for success and error states.

## Dependencies
- flutter_riverpod: State management
- google_fonts: Typography
- confetti: Success animation
- lottie: Custom animations

## Screenshots
(Add screenshots here if available)

## Contributing
Contributions are welcome. Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License.

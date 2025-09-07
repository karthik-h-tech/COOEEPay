# CooeePay

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue.svg)](https://flutter.dev/)

A Flutter app for plan selection and payment flow, designed for CallCooee's communication-focused audience. This app allows users to choose from Free, Premium, and Pro plans, apply promo codes, and simulate payment processing with a mock Stripe checkout API.

## Abstract

CooeePay simplifies subscription management and payment experience for users looking for flexible communication plans. It combines vibrant UI, responsive design, and mock API integration to create a realistic checkout flow. The app demonstrates Flutter best practices, state management with Riverpod, and animations for improved user engagement.

## Features

- **Plan Selection Screen**: Choose Free, Premium, or Pro plans with dynamic promo code validation.
- **Payment Confirmation Screen**: Review plan details, apply discounts, simulate payment via mock API, and display success/error animations.
- **Payment Options**: Choose between multiple payment methods in a reusable dialog.
- **Responsive Design**: Adjusts layout for mobile, tablet, and desktop screens.
- **Brand Appeal**: Modern UI aligned with CallCooee’s communication aesthetics.
- **Mock API Integration**: Simulates Stripe checkout, configurable with an endpoint or local fallback.
<<<<<<< HEAD

## Project Structure

```text
lib/
├── app.dart                  # Main app entry and routing: Defines MaterialApp, theme, and routes.
├── main.dart                 # Main entry point: Calls runApp(CooeePayApp()).
├── core/
│   ├── theme.dart            # ThemeData with colors, typography, buttons, and scaffold styling.
│   ├── utils.dart            # Helper functions: money formatting, discount calculation.
│   └── responsive.dart       # Responsive helpers: Detect mobile/tablet/desktop.
├── features/
│   ├── checkout/
│   │   ├── models/
│   │   │   └── plan.dart      # Plan model with id, name, price, description.
│   │   ├── providers.dart     # Riverpod state providers: selected plan, promo code, discount, payment state.
│   │   ├── services/
│   │   │   └── payment_service.dart  # Mock API simulating Stripe checkout.
│   │   ├── widgets/
│   │   │   ├── plan_card.dart         # UI card for individual plan.
│   │   │   ├── promo_field.dart       # Input field for promo codes with validation.
│   │   │   ├── primary_cta.dart       # Reusable elevated button widget.
│   │   │   └── upgrade_dialog.dart    # Dialog for dashboard/back navigation.
│   │   └── screens/
│   │       ├── plan_selection_screen.dart      # Displays plans, promo field, Proceed to Payment button.
│   │       ├── payment_options_screen.dart     # Select payment method, trigger mock API.
│   │       ├── payment_confirmation_screen.dart  # Order summary, call PaymentService.checkout, confetti/error animation.
│   │       └── payment_success_screen.dart     # Shows success with plan info and Return to Dashboard.
│   └── welcome/
│       └── welcome_screen.dart         # App landing page with logo and start button.
assets/
├── animations/
│   ├── success.json                     # Lottie animation for success.
│   └── error.json                       # Lottie animation for error.
├── images/
│   └── cooeepay_logo.png                # App logo.
```

## Installation

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/karthik-h-tech/COOEEPay.git
   cd cooeepay
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Configuration
Optional: Use a real mock API endpoint:
```bash
flutter run --dart-define=CHECKOUT_ENDPOINT=https://your.mock/endpoint
```
Without this, app uses a local fallback for checkout simulation.

## Usage

1. Launch app → Welcome screen → Tap “Get Started”.
2. Select a plan (Free/Premium/Pro) → Enter promo code COOEE20 (optional).
3. Proceed to payment confirmation → Confirm & Pay.
   - For **Free plan**, payment is skipped; “Confirm & Pay” immediately activates the plan.
   - For **Premium or Pro plans**, user selects a payment method → Mock API simulates success or error → Displays confetti or error animation.
4. Use “Return to Dashboard” to go back to welcome screen.

## Advantages

- **Easy to Understand**: Clear plan selection and payment flow.
- **Reusable Components**: Widgets and dialogs are modular, maintainable, and structured for readability.
- **Engaging UI**: Lottie animations and confetti for success improve user experience.
- **Responsive Layout**: Optimized for various screen sizes and orientations for better accessibility.
- **Mock API Ready**: Payment flow can integrate with real endpoints without affecting app structure.
- **Structured Flow**: Free vs Paid plan logic ensures smooth user journey and avoids unnecessary steps.

## Dependencies

- flutter_riverpod: State management
- google_fonts: Typography
- confetti: Success celebration
- lottie: Custom animations
- http: Mock API calls

## Running Tests

```bash
flutter test
```





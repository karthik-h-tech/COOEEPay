# TODO List for Flutter App Plan Selection and Payment Flow

## 1. Fix Navigation in Plan Selection Screen
- [x] Change "Proceed to Payment" button in `plan_selection_screen.dart` to navigate to '/payment-confirmation' instead of '/payment-options' to align with task requirements.

## 2. Verify Payment Confirmation Screen
- [x] Ensure `payment_confirmation_screen.dart` displays selected plan, price, promo discount correctly.
- [x] Confirm mock API call to simulate Stripe checkout is working.
- [x] Check success/error animations (confetti for success, shake for error, Lottie animations).
- [x] Verify "Return to Dashboard" button navigates back.

## 3. Check Responsiveness
- [x] Test UI on various screen sizes (iPhone SE, iPad, Android devices) using `responsive.dart` utilities.
- [x] Ensure grid layout adjusts correctly for phone/tablet/desktop.

## 4. Enhance UI for Brand Appeal
- [x] Review `plan_card.dart` for communication-focused icons and animations.
- [x] Add subtle animations inspired by voice/video call aesthetics (e.g., pulse on selected plan).
- [x] Ensure vibrant, modern colors from `theme.dart` are applied consistently.

## 5. Test Promo Code Validation
- [x] Verify real-time validation in `promo_field.dart` with green checkmark for valid codes (COOEE20, VIBE20, FRIENDS20) and red error for invalid.
- [x] Confirm 20% discount is applied correctly.

## 6. Improve Upgrade Dialog
- [x] In `upgrade_dialog.dart`, make "Upgrade" button navigate to plan selection or stay on screen.
- [x] Ensure dialog explains benefits clearly.

## 7. Final Testing
- [x] Run the app and test full flow: Plan Selection -> Payment Confirmation -> Success/Error.
- [x] Check for any missing features or bugs.
- [x] Prepare Loom video justifying design choices (e.g., grid layout for easy comparison, brand colors for engagement).

## 8. Documentation
- [x] Update README.md with app description and how to run.

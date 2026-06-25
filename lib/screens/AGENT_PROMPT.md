# AGENT PROMPT — Add Construction Recommendation Screen to Flow

I have added two new files to the project:

1. `lib/screens/construction_recommendation_screen.dart` — the new screen
2. Updated `lib/models/classification_result.dart` — adds `ConstructionRecommendation`
   and `ConstructionUse` classes, and a new `constructionRecommendation` field to
   `ClassificationResult`, plus updated mock data for Narra and Molave.

## Step 1 — Replace classification_result.dart

Replace the entire content of `lib/models/classification_result.dart` with the new
version I provided (the file that includes `ConstructionRecommendation`,
`ConstructionUse`, and the updated `MockResults` with `constructionRecommendation`
fields).

## Step 2 — Wire the screen into protection_screen.dart

In `lib/screens/protection_screen.dart`, the "Check Maturity" button currently
navigates to `MaturityScreen`. Change it to navigate to
`ConstructionRecommendationScreen` instead.

Add this import at the top of `protection_screen.dart`:
```dart
import 'construction_recommendation_screen.dart';
```

Find the ElevatedButton `onPressed` near the bottom of the screen that says:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MaturityScreen(result: widget.result),
  ),
);
```

Replace it with:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ConstructionRecommendationScreen(result: widget.result),
  ),
);
```

Also update the button label text from `'Check Maturity'` to
`'View Construction Recommendation'`.

## Step 3 — Verify the full flow

The complete screen flow should now be:
Capture → Classification → Maturity Status → Protection Status → Construction Recommendation

The "View Cutting Guide" button in maturity_screen.dart already goes to
ProtectionScreen, so no changes needed there.

Do not change any other logic, layout, or widget in these files.

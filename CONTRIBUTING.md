# Contributing

Thanks for helping shape Jotty.

## Development Setup

1. Install Xcode 26.5 or newer.
2. Clone the repo.
3. Open `Jotty.xcodeproj`.
4. Run the `Jotty` scheme on an iOS simulator.

Command-line build:

```sh
xcodebuild \
  -project Jotty.xcodeproj \
  -scheme Jotty \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  build CODE_SIGNING_ALLOWED=NO
```

## Good First Contributions

- Add tests for `NoteStore`
- Add tests for `NoteSummarizer`
- Improve the PDF template layout
- Add empty states for editor and archive flows
- Add a real app icon
- Improve accessibility labels and Dynamic Type behavior

## Pull Request Guidelines

- Keep changes focused and easy to review.
- Include screenshots for UI changes.
- Mention the build command or checks you ran.
- Avoid adding external dependencies unless the issue calls for it.
- Keep the app useful offline by default.

## Design Direction

Jotty should feel calm, quick, and practical. Prefer dense but readable app UI over marketing-style surfaces. Smart features should feel like a second look at the user's own thinking, not a replacement for it.

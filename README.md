# Irregulars

An iPhone and iPad app for the 269 irregular verbs of English — a reference you can
trust and a place to drill them until they stick.

[App Store](https://apps.apple.com/app/id1540487254)

## What it does

**The reference is free.** All 269 verbs with their transcription, spoken pronunciation,
translation and example sentences. Sorted A–Z or grouped by the pattern they follow, so
`sing / sang / sung` sits next to `ring / rang / rung`. Search, favourites, and a choice
of voice and speaking rate.

**The practice is what Pro pays for.** Five kinds of test:

| Test | What it asks |
| --- | --- |
| Translation | The meaning, both ways round |
| Forms | The past simple and past participle, typed |
| Sentences | The missing form inside a real sentence |
| Listening | The form as it sounds, typed |
| Speaking | The form said out loud — recognised on the device |

Without Pro the tests cover 25 verbs; with it, all 269, plus the filters that choose what
to drill. Pro is a one-time payment.

Progress is kept as you go: how many verbs you have learnt, how many are still in
progress, and which ones you keep getting wrong.

## Around the app

- **Widget** — a verb on the Home Screen, small or medium, set to all verbs or just
  your favourites
- **Spotlight** — verbs are indexed, so a system search finds them
- **Deep links** — `verbs://<infinitive>` opens a verb directly
- **Home screen shortcuts** — search, favourites, tests, statistics
- **Reminders** — a verb at the times of day you choose
- **Printing** — the list as a table
- **iPad** — a three-column layout with a sidebar rather than a stretched phone screen
- **Mac** — a menu bar with the usual commands, through Mac Catalyst
- Nine languages, Dynamic Type, VoiceOver, dark mode

## Privacy

Nothing leaves the device. There is no analytics SDK, no account and no server: the verbs
ship inside the app and everything you do with them stays in the app's own storage, shared
with the widget. Speech recognition for the speaking test runs on the device and refuses
to run any other way — a device that cannot recognise speech offline is treated as having
no recogniser at all, rather than quietly sending a voice somewhere else.

## Building

Xcode 26 with the iOS 26 SDK. Open `Verbs.xcodeproj` and run the `Verbs` scheme; no
dependencies to fetch, no package manager, no generated project.

```
Verbs/          the app
VerbsWidget/    the widget extension
VerbsTests/     unit tests
VerbsUITests/   UI tests, which also take the App Store screenshots
```

## How it is built

- **Swift 6** language mode with strict concurrency, across every target
- **SwiftUI** throughout — no view controllers left, and the navigation state of the
  whole app lives in one router rather than in the columns
- **Observation** for the models and the view models
- **One composition root**: the object graph is built once in `AppDependencies` and handed
  down, so nothing reaches for a singleton except the entry point and the two system
  delegates
- **App Intents** for the widget's configuration, **StoreKit 2** for the purchase,
  **String Catalogs** for the nine languages, and a privacy manifest

## License

© Oleg Samoylov. All rights reserved.

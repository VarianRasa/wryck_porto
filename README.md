# Muhammad Varian Warrick Portfolio

Flutter web portfolio based on Muhammad Varian Warrick's CV.

## Highlights

- CV-like document layout with responsive web polish.
- Full detail pages for profile, education, internship, projects, skills, tools, and language.
- Featured projects, project search, project filters, and readable project deep links.
- Side control panel for table of contents, ID/EN language toggle, search, filters, theme, and actions.
- Light and dark document themes.
- Quick actions for copying email, opening LinkedIn, contacting by email, and opening the CV PDF.
- `/admin` edit panel for updating homepage copy, section titles, CV entries,
  featured projects, currently-exploring items, media/link attachments, and
  contact/action links.
- Advanced edit panel modes for homepage settings, detail entries, and contact
  data.

## Notes

The CV PDF is available at `web/cv_muhammad_varian_warrick.pdf`.

## Firebase Setup

The edit panel is connected to the Firebase project `wryck-porto` by default.
The web Firebase configuration is stored in
`lib/services/firebase_portfolio_backend.dart`, and can still be overridden with
compile-time values when needed.

Default Firebase project:

```text
projectId: wryck-porto
authDomain: wryck-porto.firebaseapp.com
storageBucket: wryck-porto.firebasestorage.app
admin email: m.varianwarrick04@gmail.com
```

If you ever need to point the app to another Firebase project, run with:

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_AUTH_DOMAIN=... \
  --dart-define=FIREBASE_STORAGE_BUCKET=...
```

Firebase Console checklist:

1. Enable Authentication -> Sign-in method -> Email/Password.
2. Create an Authentication user with `m.varianwarrick04@gmail.com`.
3. Enable Cloud Firestore.
4. Enable Firebase Storage.
5. Publish the rules from `firebase/firestore.rules` and
   `firebase/storage.rules`, or copy them into the
   Firebase Console rules editor.
6. Open `/admin`, sign in with the admin email, edit content, then save.

The Firestore document is `portfolio/content`. The app saves edited CV entries
under `entries`, contact/action links under `contacts`, editable section titles
under `sections`, homepage settings under `pageSettings`, and `updatedAt` as a
server timestamp. Uploaded images, GIFs, videos, and documents are stored in
Firebase Storage under `portfolio-media/<entry-slug>/...`; their public download
URLs are saved inside each entry's `mediaItems` field.

## License

The source code is released under the MIT License. See `LICENSE`.

The personal CV content, profile photo, CV PDF, and other personal media in this
repository remain the property of Muhammad Varian Warrick and are not licensed
for reuse unless explicitly permitted.

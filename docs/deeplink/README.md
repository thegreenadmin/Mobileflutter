# Payment QR universal links (`/pay/<token>`)

One QR code now carries the URL **`https://thegreenmall.net/pay/<token>`** instead
of a bare token. The same link serves both audiences:

- **App installed** → iOS Universal Link / Android App Link hands the URL straight
  to the app, which unwraps `<token>` and runs the normal decode → pay flow.
- **App not installed** → the link opens the website, which shows a "Get the app"
  page and sends the user to the App Store / Play Store (**CTA A, install funnel**).

The app-side wiring (entitlements, intent-filter, deep-link routing, token
unwrapping) lives in this Flutter repo. The three items below are **server-side**
and must be done by the web / backend team.

---

## 1. Host the association files (web team)

Serve both files over **HTTPS**, from the apex domain, **no redirects**, with
`Content-Type: application/json`:

| File in this folder | Must be served at |
| --- | --- |
| `apple-app-site-association` | `https://thegreenmall.net/.well-known/apple-app-site-association` (no `.json` extension) |
| `assetlinks.json` | `https://thegreenmall.net/.well-known/assetlinks.json` |

> **Hosting on the WordPress site?** `thegreenmall.net` runs WordPress behind
> Cloudflare, which returns a 404 for `.well-known/*` unless the files are placed
> and rewritten correctly. See [`HOSTING_WORDPRESS.md`](./HOSTING_WORDPRESS.md)
> for the exact fix and verification steps.

Notes:
- iOS App ID is `6F246JUX8A.com.thegreenmall` (Team ID + bundle id) — already filled in.
- **`assetlinks.json` needs a real SHA-256.** Replace `REPLACE_WITH_PLAY_APP_SIGNING_SHA256`
  with the **Play App Signing** certificate fingerprint from
  Play Console → your app → **Test and release → App integrity → App signing key certificate** (SHA-256).
  If you also sideload/test a build signed with the upload key, add that key's
  SHA-256 to the same array.
- Verify after deploy:
  - iOS: `https://app-site-association.cdn-apple.com/a/v1/thegreenmall.net`
  - Android: `https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://thegreenmall.net&relation=delegate_permission/common.handle_all_urls`

## 2. The `/pay/<token>` landing page (web team)

For visitors **without** the app (CTA A):
- Optionally show the merchant name / amount decoded from `<token>`.
- Primary action: **Get the app** → App Store (iOS) / Play Store (Android),
  with platform detection via user-agent.

## 3. Make the QR emit the URL (backend team)

`POST user/payment/qr/generate` currently returns `qr_string` as a bare signed
payload. Change it to return:

```
https://thegreenmall.net/pay/<URL-encoded signed payload>
```

Keep `<token>` **exactly** the same signed payload that was the bare QR before —
the app sends that token straight to `user/payment/qr/decode`, so **the decode
endpoint needs no change**. Just URL-encode the token in the path.

The app is backward-compatible: it accepts both the new URL form and a legacy
bare payload, so generate and decode can be rolled out independently.

---

## Apple Developer portal (iOS, one-time)

The **Associated Domains** capability must be enabled for App ID
`com.thegreenmall`, and the provisioning profiles (managed via fastlane match)
regenerated so the entitlement is present in the signed build.

# Deploying `https://thegreenmall.net` universal / app links

This makes the payment QR link `https://thegreenmall.net/pay/<token>` open the
app directly when installed (and fall through to the website otherwise).

There are **two hosted files** that prove the website ↔ app ownership, plus a
**one-time Apple portal** step and an **Android SHA-256** you must fill in.

> App-side config is already done in this repo: iOS Associated Domains
> entitlement (`applinks:thegreenmall.net`) and the Android App Link
> intent-filter. The items below are what's left, and they all live **outside**
> this Flutter repo (web server + the two stores' consoles).

---

## 1. Files to host

Copy the two files in this folder to your web server so they're served at these
**exact** URLs:

| Repo file | Must be served at | Content-Type |
| --- | --- | --- |
| `apple-app-site-association` | `https://thegreenmall.net/.well-known/apple-app-site-association` | `application/json` |
| `assetlinks.json` | `https://thegreenmall.net/.well-known/assetlinks.json` | `application/json` |

**Hard requirements (both files):**
- Served over **HTTPS** with a valid certificate.
- **No redirects** — a 301/302 (even `http→https` or `non-www→www`) makes iOS
  reject the file. The apex `thegreenmall.net` must serve it with a `200`.
- Publicly reachable — no auth, no geo/IP block, no `Cache-Control: private`.
- The Apple file has **no `.json` extension** and must still return
  `Content-Type: application/json`.

### nginx
```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
    add_header Cache-Control "public, max-age=3600";
}
location = /.well-known/assetlinks.json {
    default_type application/json;
}
```

### Apache (`.htaccess` in `.well-known/`)
```apache
<Files "apple-app-site-association">
    ForceType application/json
</Files>
```

---

## 2. iOS — one-time Apple Developer portal step

The AASA file is already filled with the correct App ID
`6F246JUX8A.com.thegreenmall`. In addition:

1. **Apple Developer portal → Identifiers → `com.thegreenmall`** → enable the
   **Associated Domains** capability → Save.
2. **Regenerate provisioning profiles** so the new entitlement is in the signed
   build. With fastlane match (this repo's setup):
   ```bash
   cd ios
   bundle exec fastlane match development --force
   bundle exec fastlane match appstore --force
   ```
3. Ship an app build that includes the entitlement (already in the 3
   `Runner*.entitlements`). The next TestFlight build from the `build-ios` job
   carries it.

> iOS fetches the AASA at install/update time (via Apple's CDN). After hosting +
> a fresh build, **delete and reinstall** the app to force a re-fetch when testing.

---

## 3. Android — fill in the SHA-256, then host

`assetlinks.json` currently has a placeholder:
```json
"sha256_cert_fingerprints": ["REPLACE_WITH_PLAY_APP_SIGNING_SHA256"]
```

Because the app is distributed through Google Play (the CI uploads an `.aab`),
the certificate that actually signs the installed APK is the **Play App Signing**
key, not the upload key. Get its SHA-256:

- **Play Console → your app → Test and release → App integrity → App signing key
  certificate → copy the `SHA-256 certificate fingerprint`.**

Paste it (colon-separated hex, uppercase is fine) into the array. You can list
**multiple** fingerprints — add the upload key and/or debug key too if you want
sideloaded / debug builds to verify as well:

```json
"sha256_cert_fingerprints": [
  "AA:BB:CC:...:Play_App_Signing",
  "11:22:33:...:upload_key_optional",
  "44:55:66:...:debug_key_for_testing_optional"
]
```

Get the non-Play fingerprints locally if needed:
```bash
# Upload keystore (this repo's xyzkeystore) — needs the keystore password:
keytool -list -v -keystore xyzkeystore -alias <your-alias> | grep -A1 SHA256

# Or all variants Gradle knows about (debug always, release if env is set):
cd android && ./gradlew :app:signingReport
```

---

## 4. Verify after deploy

**iOS (Apple CDN — may take a few minutes to propagate):**
```bash
curl -i https://thegreenmall.net/.well-known/apple-app-site-association
curl https://app-site-association.cdn-apple.com/a/v1/thegreenmall.net
```
Both should return the JSON with `6F246JUX8A.com.thegreenmall` and `/pay/*`.

**Android (Google's verifier):**
```bash
curl -i https://thegreenmall.net/.well-known/assetlinks.json
curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://thegreenmall.net&relation=delegate_permission/common.handle_all_urls"
```
On a device with the app installed:
```bash
adb shell pm get-app-links com.thegreenmall      # expect: thegreenmall.net  verified
adb shell pm verify-app-links --re-verify com.thegreenmall
```

**End to end:** generate a payment code, then with the app installed point the
phone's **native camera** at the QR → it should open the app on the payment
screen. Without the app, it opens the website `/pay/...` page.

---

## 5. Rollout order (no breakage at any step)

1. **Backend** (already pushed to `staging`): `qr/generate` emits the URL; decode
   accepts both forms. Deploy it.
2. **Host** the two `.well-known` files (this guide).
3. **iOS:** enable Associated Domains + regenerate profiles, then ship a build.
4. **Android:** make sure `assetlinks.json` is live **before** users install the
   build that has the intent-filter — `autoVerify` checks the file at install time.

Each piece is backward-compatible, so the order is flexible and nothing breaks
in between. The only feature that needs the hosted files is the *direct app open*
and the *no-app website funnel*; in-app QR scanning works regardless.

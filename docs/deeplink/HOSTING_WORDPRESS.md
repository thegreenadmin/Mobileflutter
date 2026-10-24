# Hosting the `.well-known` files on the WordPress site (thegreenmall.net)

`thegreenmall.net` runs **WordPress behind Cloudflare**. That setup breaks the
two deep-link association files unless you place them correctly and stop
WordPress from swallowing the request. This doc is the WordPress-specific
companion to [`DEPLOYMENT.md`](./DEPLOYMENT.md) — read that for the full
end-to-end rollout; read this for *how to actually serve the files on this site.*

The two files that must go live:

| Repo file | Must be served at |
| --- | --- |
| [`apple-app-site-association`](./apple-app-site-association) | `https://thegreenmall.net/.well-known/apple-app-site-association` |
| [`assetlinks.json`](./assetlinks.json) | `https://thegreenmall.net/.well-known/assetlinks.json` |

---

## The symptom (what "not deployed" looks like)

Both URLs return **HTTP 404** with `Content-Type: text/html` and the WordPress
"Page not found" page:

```
$ curl -i https://thegreenmall.net/.well-known/apple-app-site-association
HTTP/2 404
content-type: text/html; charset=UTF-8
<!DOCTYPE html> ... <title>Page not found – The Green Mall</title> ...
```

Apple and Google will **not** verify the links in this state.

## Why it happens

WordPress's `.htaccess` rewrites any URL that is **not a real file on disk** to
`index.php`, which renders the 404 page. Proof it's a *placement* problem and not
a server problem: a real static file is served fine —

```
$ curl -o /dev/null -w "%{http_code} %{content_type}\n" \
    https://thegreenmall.net/wp-includes/js/jquery/jquery.min.js
200 application/javascript
```

So static hosting works; the `.well-known` files simply aren't sitting in the web
root where Apache/WordPress can find them (they were uploaded to the wrong
directory, or WordPress's rewrite is intercepting them), and Cloudflare may be
caching the 404 on top.

---

## The fix (do all four)

### 1. Put the files in the true web root

Upload them into a `.well-known/` folder **in the same directory as
`wp-config.php` and WordPress's `index.php`** (usually `public_html/` or
`htdocs/`):

```
<webroot>/.well-known/apple-app-site-association     <-- no .json extension
<webroot>/.well-known/assetlinks.json
```

Do **not** put them under `wp-content/`, the theme folder, or any subdirectory —
only the web root's `.well-known/` is checked by iOS/Android.

### 2. Stop WordPress from rewriting `.well-known`

Add this at the **very top** of the web-root `.htaccess`, **above** the
`# BEGIN WordPress` block (Apache):

```apache
RewriteEngine On
RewriteRule ^\.well-known/ - [L]
```

If the host runs **nginx** instead, add a location block (see `DEPLOYMENT.md` for
the `application/json` variants):

```nginx
location ^~ /.well-known/ {
    default_type application/json;
    try_files $uri =404;
}
```

### 3. Force the Apple file's Content-Type

The Apple file has **no extension**, so the server won't guess `application/json`
on its own. Add an `.htaccess` inside `.well-known/`:

```apache
<Files "apple-app-site-association">
    ForceType application/json
</Files>
```

(Modern iOS is lenient on Content-Type, but `200` + valid JSON + **no redirect**
is mandatory. `application/json` is the safe default.)

### 4. Purge Cloudflare cache

Cloudflare will keep serving the cached 404 otherwise:
**Cloudflare dashboard → Caching → Configuration → Purge Cache** — purge the two
URLs, or purge everything. Also confirm no Cloudflare **redirect rule** (e.g.
non-www → www, or a "flatten" rule) rewrites `/.well-known/*`; a 301/302 makes
iOS reject the AASA file.

---

## Verify after deploy

Run these — you want **HTTP 200**, `content-type: application/json`, **0
redirects**, and valid JSON:

```bash
# iOS
curl -sSIL https://thegreenmall.net/.well-known/apple-app-site-association \
  | grep -iE "HTTP/|content-type|location"
curl -sS https://thegreenmall.net/.well-known/apple-app-site-association | python3 -m json.tool

# Apple's CDN copy (may lag a few minutes; this is what devices actually fetch)
curl -sS https://app-site-association.cdn-apple.com/a/v1/thegreenmall.net

# Android
curl -sSIL https://thegreenmall.net/.well-known/assetlinks.json \
  | grep -iE "HTTP/|content-type|location"
curl -sS "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://thegreenmall.net&relation=delegate_permission/common.handle_all_urls"
```

Expected payloads:
- AASA contains `6F246JUX8A.com.thegreenmall` and the `/pay/*` path.
- assetlinks contains `com.thegreenmall` and a **real** SHA-256 (not the
  placeholder — see below).

---

## Don't forget: the Android SHA-256 is still a placeholder

`assetlinks.json` ships with:

```json
"sha256_cert_fingerprints": ["REPLACE_WITH_PLAY_APP_SIGNING_SHA256"]
```

Android link verification will fail even once the file is reachable until you
replace this with the real **Play App Signing** SHA-256
(Play Console → Test and release → App integrity → App signing key certificate).
Full details in [`DEPLOYMENT.md` §3](./DEPLOYMENT.md).

---

## Quick reference — current identifiers

| Thing | Value |
| --- | --- |
| Apple Team ID (App ID prefix) | `6F246JUX8A` |
| iOS bundle ID | `com.thegreenmall` |
| Android package | `com.thegreenmall` |
| Associated domain | `applinks:thegreenmall.net` |
| Deep-link path | `/pay/*` |

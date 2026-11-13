# Firebase config per build environment

| Folder | Firebase project | Used by |
|---|---|---|
| `beta/` | `stage-thegreenmall` | Beta builds (TestFlight / Play internal), Test Lab, Maestro, local runs |
| `release/` | `thegreenmall-6d910` | Store release builds |

`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` are the
working copies the build reads. They hold the **beta** files by default, so local
runs talk to the stage project. CI copies `firebase/<environment>/` over them
before building (see `.github/workflows/build.yml`, step "Select Firebase config").

To change a project's config, replace the file in its folder here. If you change
the beta files, copy them over the working copies too.

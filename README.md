# HopOn
Easily inject code into OS X apps

_You're gonna get some hop-ons_.

This code is rough, but workable. I'm not an expert in mach_inject, XPC, or launchd, so this may be buggy. But it's at least a start.

## Injecting Code with HopOn
Here's a rough outline of the steps to use HopOn:

0. Add HopOn as a submodule

0. Bootstrap HopOn: `script/bootstrap`.

0. Add HopOn.xcodeproj to your project or workspace.

0. Add HopOn.framework and com.diephouse.matt.HopOn-Injector to your project's dependencies.

0. Add a build phase to copy HopOn.framework into your app's Frameworks directory.

0. Add a build phase to copy com.diephouse.matt.HopOn-Injector to `Contents/Library/LaunchServices` in the Wrapper destination.

0. Set the `Runpath Search Paths` to `@loader_path/../Frameworks` in your app's build settings.

0. Add a file called `HOPON_HOST_IDENTIFIER` in a directory above the HopOn directory that contains the identifier of your app. This is needed for the launch service's permissions.

0. Add a `SMPrivilegedExecutables` dictionary to your app's info.plist with the key `com.diephouse.matt.HopOn-Identifier` and the value `identifier "com.diephouse.matt.HopOn-Identifier"`.

0. Create a "Bundle" target in your app to host the injected code. You can add classes and use `+load` or a function like this:

    ```
__attribute__((constructor))
void load()
{
    ...
}
```

0. Copy your bundle into your app in a build phase.

0. In your app, call `+[HopOn injectBundleAtURL: intoApplication:];` to inject your bundle into a target app.

## License
Available under the MIT License.

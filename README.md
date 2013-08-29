# BkTask (Library)

The target named _BkCore_ builds a static library targetted for iOS, with a directory besides with all public headers.

# BkTask (Framework)

The target named _BkTask (Framework)_ builds a static framework targetted for iOS, with the same classes and features that the static library.

# Static Frameworks on iOS

Static Frameworks are not available by default on iOS. To enable them Xcode needs some additional configuration files.
See [here](https://github.com/kstenerud/iOS-Universal-Framework) to download the zip.
Use _install.sh_ in _Real Framework_ to install the specifications. The script will also prompt you to install a _static framework_ target template.

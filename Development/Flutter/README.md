[back](../README.md)

Flutter transforms the development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded experiences from a single codebase.
Flutter is an open source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase.

## Links & References

- [Flutter Documentation](https://docs.flutter.dev/)

## Loose Notes

In theory, this can be setup on a headless machine, I ran into issues getting X11 forwarding to actually route the display to my local machine. Opted for Desktop VM instead and have had no issues. 
Basically, install Android Studio, run it's setup script at least once. I also created a test project to select and install an SDK. SDK's should be located at `$HOME/Android/Sdk` just in case flutter gets confused and can't find it. 

For the Desktop, I just used snap to install flutter. 
- `sudo snap install flutter --classic`
You can also download the install bundle for [3.16.8 here](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.8-stable.tar.xz). 
- Extract the tar.xz to a directory of your choice:   
```bash
cd ~/development
tar xf ~/Downloads/flutter_linux_vX.X.X-stable.tar.xz
```
- Add the `flutter` tool to your path:  
`export PATH="$PATH:`pwd`/flutter/bin"`
  - This command sets your PATH variable for your current terminal window only, add the path to your `$HOME/.bashrc` file for persistence across terminal sessions. 
- (Optional) Pre-download development binaries:  
`flutter precache`

### Verify Flutter installation: 
After installing, run `flutter doctor`

This command checks your environment and displays a report in the terminal window. Flutter bundles the Dart SDK. You don’t need to install Dart.

Fix anything it complains about, I've avoided Google Chrome for now, didn't want to add Google to my Linux VM. 

Lastly, after Android SDK's are installed, accept the licenses via:  
`flutter doctor --android-licenses`

### Linux Dependencies

Linux desktop apps require the following: 

- Clang
- CMake
- git
- GTK development headers
- Ninja build
- pkg-config
- liblzma-dev
- libstdc++-12-dev

Install on debian/Ubuntu via:  
`sudo apt-get install clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev`

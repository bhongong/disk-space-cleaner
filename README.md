```markdown
# Disk Space Cleaner App

A simple cross-platform disk space cleaner app built using Flutter. This application allows users to select a root folder, search for specific files or folders within it, and delete selected results. It is ideal for cleaning up space by locating and removing unnecessary files and directories, like `node_modules` folders in projects.

## Features

- **Root Folder Selection**: Choose a root directory to begin scanning.
- **Keyword Search**: Search for files or folders by name.
- **Filter by Type**: Choose whether to search for files or folders.
- **Selectable Results**: Select individual items or all results for deletion.
- **Bulk Delete**: Delete all selected files or folders with a single action.

## Built With

- **Flutter** - The UI framework for building cross-platform applications.
- **Provider** - A state management solution used to manage app state.
- **File Picker** - A Flutter package for picking directories.

## Screenshots

> Add screenshots of the app interface here if desired.

## Getting Started

Follow these instructions to set up the project locally and get it running.

### Prerequisites

- **Flutter SDK**: Make sure you have Flutter installed. You can download it [here](https://flutter.dev/docs/get-started/install).
- **IDE**: Recommended to use [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/disk-space-cleaner.git
   cd disk-space-cleaner
   ```

2. **Install dependencies**:
   Run the following command to install the required Flutter dependencies.
   ```bash
   flutter pub get
   ```

### Running the App

#### For Desktop

1. **Enable Desktop Support**:
   Flutter desktop support is required for Windows, macOS, and Linux.
   ```bash
   flutter config --enable-windows-desktop
   flutter config --enable-macos-desktop
   flutter config --enable-linux-desktop
   ```

2. **Run the app**:
   Choose your target platform (e.g., `windows`, `macos`, `linux`) and use the following command:
   ```bash
   flutter run -d windows  # or -d macos, -d linux
   ```

#### For Mobile (Android & iOS)

1. **Connect a mobile device or start an emulator**.

2. **Run the app**:
   ```bash
   flutter run
   ```

#### For Web

1. **Enable Web Support**:
   ```bash
   flutter config --enable-web
   ```

2. **Run the app**:
   ```bash
   flutter run -d chrome
   ```

## Building the App

### For Desktop

1. **Build for Windows**:
   ```bash
   flutter build windows
   ```
   The output executable will be in the `build\windows\runner\Release` folder.

2. **Build for macOS**:
   ```bash
   flutter build macos
   ```
   The output `.app` will be in the `build/macos/Build/Products/Release` folder.

3. **Build for Linux**:
   ```bash
   flutter build linux
   ```
   The output executable will be in the `build/linux/release/bundle` folder.

### For Mobile

1. **Build for Android**:
   ```bash
   flutter build apk --release
   ```
   The APK will be available in the `build/app/outputs/flutter-apk` directory.

2. **Build for iOS** (Requires macOS and Xcode):
   ```bash
   flutter build ios --release
   ```
   The output can be found in `build/ios/iphoneos`.

### For Web

1. **Build for Web**:
   ```bash
   flutter build web
   ```
   The output files will be in the `build/web` directory. You can serve these files using a web server.

## Usage

1. **Select Root Folder**: Click on the folder icon to browse and select a root folder.
2. **Enter Keyword**: Enter the name of the file or folder you want to search for, such as `node_modules`.
3. **Choose File or Folder**: Select if you are searching for files or folders.
4. **Scan**: Click the "Scan" button to begin searching within the root folder.
5. **Select Items**: Check individual paths or use the "Select All" option to mark all results.
6. **Delete Selected**: Click "Delete Selected" to remove all selected items.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions for new features or find bugs.

## License

This project is licensed under the MIT License.
```

### Notes on Building for Different Platforms

- **Windows, macOS, and Linux**: Flutter desktop support is currently in stable, but make sure you have the required dependencies for building on each platform.
- **iOS**: Building for iOS requires macOS with Xcode installed. The app must also comply with Apple’s guidelines if you plan to distribute it.
- **Web**: Building for the web requires a modern web server if you wish to host it online. 

This `README.md` provides an overview and should help users install, run, and build your disk space cleaner app on multiple platforms.

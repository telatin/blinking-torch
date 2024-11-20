# BlinkTorch iOS App

A very simple app to make your flash torch or screen blinking while walking around

## Features

- **Torch Blinking**: Controls the iPhone's camera flash to create a visible blinking pattern
- **Screen Blinking**: Alternates the screen between black and white for additional visibility
- **Adjustable Rate**: Control the blinking frequency from 0.5 to 5.0 Hz

## Requirements

- iOS 15.0 or later
- iPhone with camera flash
- Xcode 13.0 or later (for development)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/telatin/blinking-torch
```

2. Open the project in Xcode:
```bash
cd BlinkTorch
open BlinkTorch.xcodeproj
```

3. If needed, add required permissions to Info.plist:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>processing</string>
</array>
<key>Privacy - Camera Usage Description</key>
<string>SafetyTorch needs access to the camera to control the torch</string>
```

4. Build and run the project on your device

## Usage

1. Launch the app
2. Use the "Start Torch Blink" button to begin flash blinking
3. Use the "Start Screen Blink" button to begin screen blinking
4. Adjust the blink rate using the slider (0.5 - 5.0 Hz)
5. Press the respective stop buttons to cease blinking
6. The app will continue blinking in the background until explicitly stopped

## License

This project is licensed under the MIT License - see the LICENSE file for details
 
## Support

For support, please open an issue in the GitHub repository or contact the maintainers.

---
Built with ❤️ for safety
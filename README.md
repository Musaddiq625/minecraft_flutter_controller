# 📱 Minecraft Controller (Flutter App)

Control Minecraft on your PC using your **phone as a controller**!\
This project provides a **Flutter mobile app** that sends UDP commands to a **Python backend**, which then injects keyboard and mouse inputs into Minecraft.

---

## 🚀 Features

- 🔗 **UDP Connection**: Connects to the Python backend using server IP and port.
- 🎮 **On-Screen Controls**: Buttons for movement, hotbar, and actions; joystick for looking.
- 🔄 **JSON Payloads**: Sends structured JSON for press, click, and movement commands.
- ⚙️ **Configurable**: Customize server IP, port, and UI sensitivity in settings.

---

## 🛠️ Requirements

- **Flutter SDK** (3.x recommended)
- **Dart SDK** (2.19+)
- Android or iOS device/emulator
- Device and PC on the **same local network**

---

## 🚀 Installation & Running

1. **Clone this repo**:

   ```bash
   git clone https://github.com/Musaddiq625/minecraft_flutter_controller.git
   cd minecraft_controller
   ```

2. **Fetch dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app on your device**:

   ```bash
   flutter run --release
   ```

4. (Optional) **Build an APK**:

   ```bash
   flutter build apk --release
   ```

---

## 📝 JSON Protocol

The app sends UDP packets containing JSON objects.

Example formats:

```json
{ "action": "press", "key": "w" }
{ "action": "click" }
{ "action": "move", "x": 1, "y": -1 }
```

| Command | Description                           |
| ------- | ------------------------------------- |
| press   | Press and release a key (e.g., WASD)  |
| click   | Single mouse click (attack/use)       |
| move    | Continuous look/aim movement (dx, dy) |

---

## 📦 Dependencies

Check the `pubspec.yaml` for the full package list. Core dependencies include:

- Flutter SDK (`flutter`)
- UDP client (`udp: ^5.0.3`)
- (Other packages as needed for UI or state management)

---

## 🎮 Usage

1. **Start the Python backend** on your PC:

   ```bash
   python main.py
   ```

   It will display your **local IP address**.

2. **Enter the IP and port** in the Flutter app’s Settings and tap **Connect**.

3. Use the on-screen controls to move, look, jump, attack, open inventory, etc.

---

## 🛠️ Troubleshooting

- **Cannot connect**: Ensure both devices are on the same Wi-Fi network and the IP/port are correct.
- **No response**: Verify the Python script is running with appropriate permissions.
- **Laggy controls**: Increase joystick sensitivity or reduce network interference.

---


## 🔐 Security

- This app communicates over your local network using UDP and does not use any encryption or authentication.
- **Make sure both devices are on a trusted network.** Avoid using public Wi-Fi for security reasons.

---

## ⚠️ Minecraft Settings

- Make sure Minecraft is running and focused on your PC.
- Go to Options > Controls > Mouse Settings, and **enable Raw Input** to ensure the game accepts movement commands correctly.

---

## 🧑‍💻 Author & Links

- **Author:** [Musaddiq Ahmed Khan (Musaddiq625)](https://github.com/Musaddiq625)
- **Flutter App:** https://github.com/Musaddiq625/minecraft_flutter_controller.git
- **Python Backend:** https://github.com/Musaddiq625/minecraft_python_controller.git

This is just a basic proof of concept to spark your creativity! If you can improve or extend it, feel free to fork and submit a PR.

Made with ❤️ by Musaddiq625 — contributions welcome!


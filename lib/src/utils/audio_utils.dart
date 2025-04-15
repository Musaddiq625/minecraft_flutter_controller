import 'package:audioplayers/audioplayers.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';

class AudioUtils {
  /// Creating new instance of audio player to play sound individually
  static Future<void> placeBlockSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource(AssetConstants.block));
  }

  /// Creating new instance of audio player to play sound individually
  static Future<void> buttonSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource(AssetConstants.buttonClick));
  }
}

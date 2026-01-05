import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  // Play sound effect
  Future<void> playSoundEffect(String soundName) async {
    try {
      await _audioPlayer. play(AssetSource('audio/effects/$soundName.mp3'));
    } catch (e) {
      print('Error playing sound:  $e');
    }
  }

  // Start voice recording (placeholder pour plus tard)
  Future<void> startRecording() async {
    _isRecording = true;
    print('Recording feature coming soon!');
    // TODO: Implémenter plus tard avec un package compatible
  }

  // Stop recording (placeholder)
  Future<void> stopRecording() async {
    _isRecording = false;
    print('Stop recording');
  }

  // Play recorded voice (placeholder)
  Future<void> playRecordingWithEffect() async {
    print('Playback feature coming soon!');
    // TODO: Implémenter plus tard
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
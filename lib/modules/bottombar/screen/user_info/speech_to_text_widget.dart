import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextWidget extends StatefulWidget {
  const SpeechToTextWidget({super.key});

  @override
  State<SpeechToTextWidget> createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  final SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = "Press the mic and start speaking...";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) => print("STATUS: $status"),
      onError: (error) => print("ERROR: $error"),
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    await _speech.listen(
      localeId: "en_US",
      listenMode: ListenMode.confirmation,
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
    );

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Speech To Text (English)",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            /// 🔹 TEXT HIỂN THỊ Ở ĐÂY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _recognizedText,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔹 NÚT MIC
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              _speechEnabled
                  ? "Speech available"
                  : "Speech not available on this device",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

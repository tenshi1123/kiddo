import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

class PronunciationDemo extends StatefulWidget {
  const PronunciationDemo({super.key});

  @override
  State<PronunciationDemo> createState() => _PronunciationDemoState();
}

class _PronunciationDemoState extends State<PronunciationDemo> {
  final String correctSentence = "the quick brown fox jumps over the lazy dog";

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = "";
  double _score = 0;

  Map<String, String?> ipaCache = {};

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // =============================
  // SPEECH
  // =============================
  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          localeId: "en_US",
          onResult: (val) {
            setState(() {
              _recognizedText = val.recognizedWords;
              _score = similarityPercent(_recognizedText, correctSentence);
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // =============================
  // SIMILARITY
  // =============================
  int levenshtein(String a, String b) {
    List<List<int>> dp = List.generate(
      a.length + 1,
      (i) => List<int>.filled(b.length + 1, 0),
    );

    for (int i = 0; i <= a.length; i++) dp[i][0] = i;
    for (int j = 0; j <= b.length; j++) dp[0][j] = j;

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        int cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost]
            .reduce((x, y) => x < y ? x : y);
      }
    }

    return dp[a.length][b.length];
  }

  double similarityPercent(String a, String b) {
    if (a.isEmpty) return 0;
    int dist = levenshtein(a.toLowerCase(), b.toLowerCase());
    int maxLen = a.length > b.length ? a.length : b.length;
    return ((maxLen - dist) / maxLen) * 100;
  }

  // =============================
  // FETCH IPA
  // =============================
  Future<String?> fetchIPA(String word) async {
    if (ipaCache.containsKey(word)) return ipaCache[word];

    final url =
        Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/$word");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final phonetics = data[0]["phonetics"];

          for (var p in phonetics) {
            if (p["text"] != null && p["text"].toString().isNotEmpty) {
              ipaCache[word] = p["text"];
              return p["text"];
            }
          }
        }
      }
    } catch (_) {}

    ipaCache[word] = "Not found";
    return "Not found";
  }

  // =============================
  // SHOW DETAILS
  // =============================
  void showPronunciationDetails() {
    List<String> words = correctSentence.split(" ").toSet().toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  String word = words[index];

                  return ListTile(
                    title: Text(word),
                    subtitle:
                        ipaCache[word] != null ? Text(ipaCache[word]!) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        String? ipa = await fetchIPA(word);

                        // 👇 rebuild bottom sheet
                        setModalState(() {});
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Pronunciation Demo1")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              correctSentence,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text("Recognized: $_recognizedText"),
            const SizedBox(height: 20),
            Text(
              "Score: ${_score.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: showPronunciationDetails,
              child: const Text("Pronunciation Details"),
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: _listen,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

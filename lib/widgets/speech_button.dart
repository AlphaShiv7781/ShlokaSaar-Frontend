import 'package:flutter/material.dart';

class SpeechButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isListening;

  const SpeechButton({
    super.key,
    required this.onPressed,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isListening ? Colors.red : Colors.deepOrange,
      onPressed: onPressed,
      child: Icon(
        isListening ? Icons.mic_off : Icons.mic,
        color: Colors.white,
      ),
    );
  }
}

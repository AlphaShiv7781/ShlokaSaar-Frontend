import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';

import '../blocs/shloka_bloc.dart';
import '../blocs/shloka_event.dart';
import '../blocs/shloka_state.dart';
import '../widgets/input_field.dart';
import '../widgets/speech_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speechToText;
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = "";
  late TextEditingController _textController;

  void _requestMicPermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required for speech search')),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _requestMicPermission();
    _speechToText = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      if (!_speechEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition failed to initialize')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing speech: $e')),
      );
    }
    setState(() {});
  }

  void _startListening() async {
    setState(() => _isListening = true);
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 1),
      pauseFor: const Duration(seconds: 5),
    );
  }

  void _stopListening() async {
    setState(() => _isListening = false);
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _textController.text = _lastWords;
    });

    if (result.finalResult && _lastWords.isNotEmpty) {
      context.read<ShlokaBloc>().add(FetchShloka(_lastWords));
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text(
              'ShlokaSaar',
            style: TextStyle(
              color: Colors.white
            ),
          ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 40),
        child: SpeechButton(
          onPressed: _speechEnabled ? () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          } : (){},
          isListening: _isListening,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,40,10,20),
        child: Column(
          children: [
            InputField(controller : _textController),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange.shade300,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.deepOrange.shade900, width: 2),
                ),
              ),
                onPressed: (){
                  context.read<ShlokaBloc>().add(FetchShloka(_textController.text));
                  _textController.clear();
                },
                child: Text(
                    'Search for Explanation',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white
                  ),
                ),
            ),

            SizedBox(height: 20,),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.deepOrange,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white54
                ),
                child: BlocBuilder<ShlokaBloc, ShlokaState>(
                  builder: (context, state) {
                    if (state is ShlokaLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ShlokaLoaded) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // Translation Card
                            Container(
                              padding : EdgeInsets.all(20),
                              decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepOrange.shade300
                              ),

                              child: Column(
                                children: [
                                  Text('Translation' ,style: TextStyle(fontSize: 20 , color: Colors.white , fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
                                  SizedBox(height: 20,),
                                  Text('English :- ${state.translationEnglish}',
                                    style: const TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Hindi :- ${state.translationHindi}',
                                    style: GoogleFonts.notoSansDevanagari(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                               height: 20,
                            ),

                            // Explanation Card
                            Container(
                              padding : EdgeInsets.all(20),
                              decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepOrange.shade300
                              ),

                              child: Column(
                                children: [
                                  Text('Explanation' ,style: TextStyle(fontSize: 20 , color: Colors.white , fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
                                  SizedBox(height: 20,),
                                  Text('English :- ${state.explanationEnglish}',
                                    style: const TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Hindi :- ${state.explanationHindi}',
                                    style: GoogleFonts.notoSansDevanagari(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              padding : EdgeInsets.all(20),
                              decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepOrange.shade300
                              ),

                              child: Column(
                                children: [
                                  Text('Summary' ,style: TextStyle(fontSize: 20 , color: Colors.white , fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
                                  SizedBox(height: 20,),
                                  Text('English :- ${state.summaryEnglish}',
                                    style: const TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Hindi :- ${state.summaryHindi}',
                                    style: GoogleFonts.notoSansDevanagari(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    } else if (state is ShlokaError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      );
                    }
                    return const Text(
                      'Enter a Shloka or use microphone to get translation.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
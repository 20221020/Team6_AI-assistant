import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minsu_v2/openai_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'music_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:minsu_v2/camera.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:math';

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);

  final String name;
  Home({required this.name});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ImagePicker picker = ImagePicker();
  final speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  final player = AudioPlayer();
  String text='';
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  late List<XFile>? imagefiles = [];
  int digit = -1;
  String current_label = "";
  String message = "";
  List<String> imgPaths = ["","","","",""];
  StreamSubscription? playerCompleteSubscription;

  // 카메라 관련 변수 선언
  bool checkButtonPressed = false;
  List<String> capturedImages = [];

  Future<void> navigateToCameraScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onCaptureComplete: (digit, label, message, images) {
            setState(() {
              this.digit = digit;
              current_label = label;
              capturedImages = images;
              this.message = message;
            });
          },
        ),
      ),
    );
    // if (result != null) {
    //   setState(() {
    //     current_label = result;
    //   });
    // }
  }
    // void navigateToCheckPage() {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => CheckPage(
    //         images: capturedImages,
    //         onBackButtonPressed: () {
    //           setState(() {
    //             checkButtonPressed = false;
    //           });
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ),
    //   );
    // }

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    // flutterTts.setCompletionHandler((){});
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }
  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    checkButtonPressed = false;
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {lastWords; message;});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      lastWords = result.recognizedWords;
      print(lastWords);
      if (speechToText.isNotListening == true){
        if (lastWords=='민수야'){
          message = await openAIService.chatGPTAPI(lastWords);
          await flutterTts.speak(message);
        }
        else{
        message = await openAIService.isyesPromptAPI(lastWords);
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(message);
        if (message == '잠을 깨실수 있도록 신나는 음악을 틀어 드릴게요'){await playRandomVideo();}
        print('message:$message');
        }
      }
    });
  }

  Future<void> SpeakAndListen(String content,String yourName) async {
    try {
      await flutterTts.setLanguage("ko-KR"); // Set the language
      await flutterTts.setPitch(1.0); // Set the pitch of the voice
      await flutterTts.setVolume(1.0);

      // setState(() {
      //   message;
      //   digit;
      //   current_label;
      // });

      // Ensure speak awaits completion
      await flutterTts.awaitSpeakCompletion(true);
      // Cancel the old subscription if it exists
      playerCompleteSubscription?.cancel();

      if (digit == 2 || digit == 3 || digit == 4 ) {
        await player.play(AssetSource('sounds/beep.mp3'));
        playerCompleteSubscription = player.onPlayerComplete.listen((_) async {
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(yourName + '님, ' + content);
          lastWords = '';
        });
      }
      else if (digit == 1 || digit ==6){
        await player.play(AssetSource('sounds/warning.mp3'));
        playerCompleteSubscription = player.onPlayerComplete.listen((_) async {
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(yourName + '님, ' + content);
          lastWords = '';
          // await startListening();
        });
      }
      else if (digit==5){
        lastWords = '';
      }
      else { await flutterTts.speak(yourName + '님, ' + content);
      print('digit: $digit');
      lastWords = '';
      await startListening();
      }

    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  List<String> ids = ['Pp07icnTPGE', 'GDWnNbBIzCc','-vBcCjHcXUM','wEdFCd1FmpA', 'Ii8L0qEvfC8','y7JPgbLfpfA','4zyE4Hhns0E','tkwY4V7IB7c'];
  final rand = Random();

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'Pp07icnTPGE', // The video ID, not the full YouTube URL
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Future<void> playRandomVideo() async{
    String randomVideoId = ids[rand.nextInt(ids.length)];
    _controller.load(randomVideoId);
    _controller.play();
    print('play');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.deepPurpleAccent,
        title: const Text('AI Driver Assistant MINSU'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: PageView(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                // image selection
                SizedBox(height: 40,),
                Text("Welcome, ${widget.name}!", style: TextStyle(fontSize: 17),),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: () async {
                  checkButtonPressed = true;
                  await navigateToCameraScreen();
                  await SpeakAndListen(message,widget.name);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green
                ),
                  child: Text("Open Camera"),
                ),

                // driver's status monitoring
                SizedBox(height: 10,),
                Text("Current driving status:", style: TextStyle(fontSize: 15)),

                // print text about driver condition
                SizedBox(height: 10,),
                Text(
                  digit == -1
                      ? ""
                      : current_label
                  , style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 30,),
                Center(
                  child: InkWell(
                    onTap: () async {
                      if (await speechToText.hasPermission &&
                          speechToText.isNotListening) {
                        await startListening();
                      } else if (speechToText.isListening) {
                        await stopListening();
                      } else {
                        initSpeechToText();
                      }
                      setState(() {});
                    },
                    child: speechToText.isListening
                        ? Center(child: LoadingAnimationWidget.beat(
                            size: 300,
                            color:Colors.deepPurple[400]!,
                            ),
                          )
                        : (digit==1 || digit==6
                            ? Image.asset(
                                "assets/images/podori.jpg",
                                height: 300,
                                width: 300,
                              )
                            : Image.asset(
                                "assets/assistant_icon.png",
                                height: 300,
                                width: 300,
                                )
                              ),
                  ),
                ),

                // chat bubble
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 30, left: 40),
                  child: const Text(
                    "Minsu says",
                    style: TextStyle(
                      color: Color.fromRGBO(19, 61, 95, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(200, 200, 200, 1),
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      digit == 5 || digit == -1
                          ? '무엇을 도와드릴까요?'
                          : widget.name+ '님, '+ message,
                      style: TextStyle(
                        color: Color.fromRGBO(19, 61, 95, 1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10, right: 40),
                  child: const Text(
                    "You says",
                    style: TextStyle(
                      color: Color.fromRGBO(19, 61, 95, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(200, 200, 200, 1),
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      lastWords == ""
                        ? '응답이 없습니다.'
                        : lastWords,
                      style: TextStyle(
                        color: Color.fromRGBO(19, 61, 95, 1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
            checkButtonPressed == false? YoutubePlayer(
                  controller: _controller, // You should pass the controller here
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                ): Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
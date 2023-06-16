import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

// MusicPlayer is a custom widget to play, pause, and stop music.
class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

// _MusicPlayerState is the state of the MusicPlayer widget.
class _MusicPlayerState extends State<MusicPlayer> {
  bool _connected = false;

  // @override
  // void initState() {
  //   super.initState();
  //   connectToSpotifyRemote();
  // }
  //
  // Future<void> connectToSpotifyRemote() async {
  //   try {
  //     var connected = await SpotifySdk.connectToSpotifyRemote(
  //       clientId: "your_client_id",
  //       redirectUrl: "your_redirect_url",
  //     );
  //     setState(() {
  //       _connected = connected;
  //     });
  //   } catch (e) {
  //       print(e.toString());
  //   }
  // }

  // Future<void> play() async {
  //   var trackId = "spotify:track:06AKEBrKUckW0KREUWRnvT"; // Replace with the desired track id
  //   await SpotifySdk.play(spotifyUri: trackId);
  // }

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'K18cpp_-gP8', // The video ID, not the full YouTube URL
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          //   Text('Connected: $_connected'),
          //   ElevatedButton(
          //     onPressed: _connected ? play : null,
          //     child: Text('Play'),
          //   ),

            YoutubePlayer(
              controller: _controller, // You should pass the controller here
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

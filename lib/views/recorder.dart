import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:help/constants/colors.dart';
import 'package:path_provider/path_provider.dart';

class Recorder extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  const Recorder({Key key, this.localFileSystem}) : super(key: key);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {


  TextEditingController _controller;

  FlutterAudioRecorder _recorder;
  Recording _recording;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  Timer _t;

  bool isPlaying = false;

  String _alert;

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  Future _init() async {
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      customPath = appDocDirectory.path +
          customPath +
          DateTime.now().second.toString();      // .wav <---> AudioFormat.WAV
      // .mp4 .m4a .aac <---> AudioFormat.AAC
      // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

      _recorder = FlutterAudioRecorder(customPath,
          audioFormat: AudioFormat.WAV, sampleRate: 22050);
      await _recorder.initialized;
    }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);

      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(Icons.fiber_manual_record);
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay);
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  void _play() {
    AudioPlayer player = AudioPlayer();
    player.play(_recording.path, isLocal: true);
  }

  @override
  void initState() {
    Future.microtask(() {
      _prepare();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var playIcon = Image.asset(
      'assets/images/mic.png',
      width: 60,
      color: klightGrey,
    );
    var waveIcon = Image.asset(
      'assets/images/stop-button 1.png',
      width: 60,
      color: klightGrey,
    );
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: kWhite,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          SizedBox(
            height: 36,
          ),
          Center(
              child: !isPlaying !=_recording
                  ? Text(
                      'Record',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kWhite),
                    )
                  : Text(
                      'Recording',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kWhite),
                    )),
          SizedBox(
            height: height / 4,
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  if (!isPlaying) {
                    isPlaying = true;
                    _stopRecording();
                  } else {
                    isPlaying = false;
                    debugPrint('The stop $isPlaying');
                    _startRecording();
                  }
                  setState(() {});
                  debugPrint('Tee $isPlaying');
                },
                child: isPlaying ? waveIcon : playIcon),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              '${_recording?.duration ?? "-"}',
              style: TextStyle(fontSize: 24,color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              child: Text('Play'),
              disabledTextColor: Colors.white,
              disabledColor: Colors.grey.withOpacity(0.5),
              onPressed: _recording?.status == RecordingStatus.Stopped
                  ? _play
                  : null,
            ),
          ),
        ],
      )),
    );
  }


}

import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:get/get.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:path_provider/path_provider.dart';

class Recorder extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  const Recorder({Key key, this.localFileSystem}) : super(key: key);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  RecordingStatus _recordingStatus = RecordingStatus.Unset;
  Timer _t;
  bool isPlaying = false;
  bool isRecording = false;
  String recordingPath;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        print('clicked');
        String customPath = '/helpMe_recording_';
        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        recordingPath = appDocDirectory.path +
            customPath +
            DateTime.now().minute.toString() +
            '_' +
            DateTime.now().second.toString();
        print(recordingPath);
        _recorder = FlutterAudioRecorder(recordingPath,
            audioFormat: AudioFormat.WAV, sampleRate: 22050);
        await _recorder.initialized;
        _recording = await _recorder.current();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _startRecording() async {
    await _init();
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
      _recordingStatus = _recording.status;
      isRecording = true;
    });

    _t = Timer.periodic(Duration(milliseconds: 50), (Timer t) async {
      current = await _recorder.current();
      if (_recordingStatus == RecordingStatus.Stopped) {
        t.cancel();
      }
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _pauseRecording() async {
    await _recorder.pause();
    setState(() {
      _recordingStatus = RecordingStatus.Paused;
      print('pause status is $_recordingStatus');
    });
  }

  Future _resumeRecording() async {
    await _recorder.resume();
    setState(() {
      _recordingStatus = RecordingStatus.Recording;
      print('resume status is $_recordingStatus');
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    uploadAudioFirebase();
    _t.cancel();
    setState(() {
      _recording = result;
      _recordingStatus = _recording.status;
      isRecording = false;
      print('stop status is $_recordingStatus');
    });
    Get.rawSnackbar(
        backgroundColor: Colors.white,
        messageText: Text('Your Recordings are saved in: $recordingPath'));
  }

//  Future _prepare() async {
//    var hasPermission = await FlutterAudioRecorder.hasPermissions;
//    if (hasPermission) {
//      setState(() => _hasPermision = true);
//    } else {
//      setState(() {
//        _alert = "Permission Required.";
//        print(_alert);
//        setState(() => _hasPermision = false);
//      });
//    }
//  }

//  Stream<Duration>
  _play() {
    AudioPlayer player = AudioPlayer();
    player.play(_recording.path, isLocal: true);
  }

// uploading audio recordings to firebase to be used when user click back or stop the recording
  uploadAudioFirebase() async {
    User user = auth.currentUser;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(' ${user.phoneNumber} Recordings' + DateTime.now().toString());
    print(user.displayName);

    final StorageUploadTask uploadTask = storageReference.putFile(
        File(_recording.path), StorageMetadata(contentType: 'audio/wav'));
  }

  //To Change the text based on the recording status
  String desc() {
    switch (_recordingStatus) {
      case RecordingStatus.Unset:
        return 'Record';
      case RecordingStatus.Recording:
        return 'Recording';
      case RecordingStatus.Paused:
        return 'Paused';
      case RecordingStatus.Stopped:
        return 'Record';
      case RecordingStatus.Initialized:
        return 'Record';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var playIcon = Image.asset(
      'assets/images/mic.png',
      width: 60,
      color: klightGrey,
    );
    var stopIcon = Image.asset(
      'assets/images/stop-button 1.png',
      width: 60,
      color: klightGrey,
    );

    //to cancel the recording when the phones back button is pressed
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
                onPressed: () async {
                  Get.snackbar(
                      'Saved', 'Your Recordings are saved in: $recordingPath');
                  Navigator.pop(context);
                }),
            SizedBox(
              height: 36,
            ),
            Center(
              child: Text(
                desc(),
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: kWhite),
              ),
            ),
            SizedBox(
              height: height / 4,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        //To Change the function of the play button based on the recording status
                        switch (_recordingStatus) {
                          case RecordingStatus.Unset:
                            return _startRecording();
                          case RecordingStatus.Recording:
                            return _pauseRecording();
                          case RecordingStatus.Paused:
                            return _resumeRecording();
                          case RecordingStatus.Stopped:
                            return _startRecording();
                          // case RecordingStatus.Initialized:
                          //   return _startRecording();
                        }
                      },
                      child: playIcon),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        _stopRecording();
                      },
                      child: stopIcon),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                '${_recording?.duration ?? "-"}',
                style: TextStyle(fontSize: 24, color: Colors.white),
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
        ),
      ),
    );
  }
}

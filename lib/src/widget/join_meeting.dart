import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:livemeet/src/util/common_widgets.dart';

class JoinMeeting extends StatefulWidget {
  const JoinMeeting({Key? key}) : super(key: key);

  @override
  State<JoinMeeting> createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting>
    with AutomaticKeepAliveClientMixin<JoinMeeting> {
  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    _meetingIdController.dispose();
    _userNameController.dispose();
    _serverController.dispose();
    JitsiMeet.removeAllListeners();
    super.dispose();
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _serverUrlInput(),
            const SizedBox(
              height: 20,
            ),
            _meetingIdInput(),
            const SizedBox(
              height: 20,
            ),
            _userNameInput(),
            const SizedBox(
              height: 10,
            ),
            CheckboxListTile(
              title: const Text("Audio Only"),
              value: isAudioOnly,
              onChanged: _onAudioOnlyChanged,
            ),
            CheckboxListTile(
              title: const Text("Audio Muted"),
              value: isAudioMuted,
              onChanged: _onAudioMutedChanged,
            ),
            CheckboxListTile(
              title: const Text("Video Muted"),
              value: isVideoMuted,
              onChanged: _onVideoMutedChanged,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60.0,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  bool isStatusOk = validate();
                  if (isStatusOk == false) {
                    return;
                  }
                  _joinMeeting();
                },
                child: const Text(
                  "Join Meeting",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  Widget _serverUrlInput() {
    return TextField(
      controller: _serverController,
      decoration: getTextFieldDecoration(
          context,
          'Server URL (Leave empty for default)',
          'Hint: Leave empty for meet.jitsi.si',
          null,
          null,
          null),
    );
  }

  //
  Widget _meetingIdInput() {
    return TextField(
      controller: _meetingIdController,
      decoration: getTextFieldDecoration(
          context, 'Meeting Id', 'Meeting Id', null, null, null),
    );
  }

  Widget _userNameInput() {
    return TextField(
      controller: _userNameController,
      decoration: getTextFieldDecoration(
          context, 'Display Name', 'Display Name', null, null, null),
    );
  }

  bool validate() {
    if (_meetingIdController.text.trim().isEmpty) {
      snackBarShow(context, 'Meeting Id cannot be empty');
      return false;
    }

    if (_userNameController.text.trim().isEmpty) {
      snackBarShow(context, 'Display Name cannot be empty');
      return false;
    }

    return true;
  }

  _joinMeeting() async {
    String? serverUrl =
        _serverController.text.trim().isEmpty ? null : _serverController.text;

    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };

    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }

    // Define meetings options here
    var options = JitsiMeetingOptions(room: _meetingIdController.text)
      ..serverURL = serverUrl
      ..userDisplayName = _userNameController.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": _meetingIdController.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": _userNameController.text}
      };

    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  //
}

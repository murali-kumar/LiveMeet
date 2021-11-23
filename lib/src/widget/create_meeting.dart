import 'package:flutter/material.dart';
import 'package:livemeet/src/util/common_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({Key? key}) : super(key: key);

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting>
    with AutomaticKeepAliveClientMixin<CreateMeeting> {
  String _meetingId = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'Create a meeting id and send it to people that you want to meet with. Make sure that you save it so that you can use it later, too.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Meeting ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(minWidth: 300),
              decoration: BoxDecoration(
                //color: Colors.grey,
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
              ),
              child: Text(_meetingId),
            ),
            Ink(
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _meetingId)).then((_) {
                    snackBarShow(context, 'Copied to clipboard!');
                  });
                },
                icon: Icon(
                  Icons.copy,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _meetingId = const Uuid().v1();
              });
            },
            child: const Text('Create Meeting ID')),
      ],
    );
  }
}

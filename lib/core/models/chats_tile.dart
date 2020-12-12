import 'package:flutter/material.dart';
import 'package:help/ui/constants/colors.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String jobPosition;
  final String date;
  final Stream<int> unreads;
  final void Function() onPressed;

  const ChatTile({
    Key key,
    this.name,
    this.jobPosition,
    this.onPressed,
    this.date,
    this.unreads,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: kBgColor),
                ),
                StreamBuilder<int>(
                  stream: unreads,
                  builder: (context, snapshot) {
                    int value = snapshot.data;
                    if (value != null && value > 0) {
                      return CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 12,
                            child: Text('$value'),
                          );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jobPosition,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
                Text(
                  date ?? '',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

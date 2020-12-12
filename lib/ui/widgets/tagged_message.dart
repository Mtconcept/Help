import 'package:flutter/material.dart';
import 'package:help/ui/constants/colors.dart';

class TaggedMessage extends StatelessWidget {
  final String message;
  final VoidCallback onTap;
  final bool canCancel;

  const TaggedMessage({
    Key key,
    @required this.message,
    @required this.onTap,
    this.canCancel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: klightGrey,
      child: Container(
        color: kBgColor, //kdarktGrey.withOpacity(0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                color: klightGrey,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  color: kdarktGrey.withOpacity(0.3),
                  child: Stack(
                    children: [
                      Text(
                        message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: kBgColor,
                        ),
                      ),
                      canCancel
                          ? Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 15,
                                ),
                                onTap: onTap,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/buttons.dart';
import '../../constants/colors.dart';
import '../../constants/textFields.dart';
import 'raise_claim_controller.dart';

class RaiseClaim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhite,
      body: GetBuilder<RaiseClaimController>(
        init: RaiseClaimController(),
        builder: (model) => SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Center(
                  child: SvgPicture.asset(
                    'assets/svgs/claim.svg',
                    width: 90,
                  ),
                ),
                SizedBox(height: 25),
                Center(
                    child: Text(
                  'Raise a Claim',
                  style: TextStyle(fontSize: 20, color: kBgColor),
                )),
                SizedBox(
                  height: 24,
                ),
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: klightGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please Be Brief\n& Precise',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: kBgColor,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        MyTextFields(
                          controller: model.nameEditingController,
                          fieldTitle: 'Your Name',
                          maxline: 1,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        DropdownButton(
                          value: model.gender,
                          items: [
                            DropdownMenuItem(
                              child: Text('Male'),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text('Female'),
                              value: 1,
                            ),
                          ],
                          onChanged: model.setGender,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        MyTextFields(
                          controller: model.ageEditingController,
                          fieldTitle: 'Your Age',
                          maxline: 1,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        MyTextFields(
                          controller: model.claimEditingController,
                          maxLength: null,
                          maxline: null,
                          fieldTitle: " Drop Your Claims",
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: klightGrey,
                              activeColor: kdarktGrey,
                              value: model.isChecked,
                              onChanged: model.agreeChecked,
                            ),
                            Flexible(
                              child: Text(
                                'I agree that every information entered is 100% true',
                                style: TextStyle(fontSize: 16, color: kBgColor),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        Center(
                          child: MyButtons(
                            onPress: model.sendClaim,
                            color: kBgColor,
                            text: "Send Claim",
                            textColor: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator() {
    return Center(
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: kBgColor,
        ),
      ),
    );
  }
}

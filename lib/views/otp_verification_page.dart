import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPVerificationPage extends StatefulWidget {
  final Map<String, dynamic> userCredentials;
  const OTPVerificationPage({Key? key, required this.userCredentials})
      : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  ConfirmationResult? confirmationResult;
  @override
  void initState() {
    // TODO: Connect To Firebase and Authenticate user
    var instance = FirebaseAuth.instance;
    try {
      if (widget.userCredentials['isEmail'] == false) {
        instance.verifyPhoneNumber(
          phoneNumber: widget.userCredentials['phonenumber'].toString(),
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? forceResendingToken) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        );
        return;
      }
      instance
          .createUserWithEmailAndPassword(
        email: widget.userCredentials['email'],
        password: 'DummyPassword',
      )
          .then((value) {
        log("User Created Successfully");
      }).catchError((error) {
        log((error as FirebaseAuthException).message ?? "Error Occured");
      });
    } catch (e) {
      log("Error Occured $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _normalTextSpanTextStyle =
        TextStyle(color: Colors.grey[700], fontSize: 12.sp);
    var _emossedTextSpanTextStyle = TextStyle(
        color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold);
    List<FocusNode> otpFocusNodes = List.generate(6, (_) {
      return FocusNode();
    });
    List<TextEditingController> otpTextEditingController =
        List.generate(6, (_) {
      return TextEditingController();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Region Header Starts Here
          Padding(
            padding: EdgeInsets.fromLTRB(28.75.w, 75.h, 0, 0),
            child: Row(
              children: [
                Text(
                  "We've sent you a code",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 28.sp,
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(28.75.w, 4.h, 0, 0),
            child: Row(
              children: [
                Text(
                  'We’ll send you a confirmation code',
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          //Region Header Ends Here
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) {
                return Container(
                  height: 69.h,
                  width: 47.w,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.grey[500]!,
                      width: 1.w,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    child: TextField(
                      focusNode: otpFocusNodes[index],
                      controller: otpTextEditingController[index],
                      obscureText: true,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) async {
                        if (index == otpFocusNodes.length - 1) {
                          String finalOtp = '';
                          for (var textEditor in otpTextEditingController) {
                            finalOtp += textEditor.text;
                          }
                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: widget.userCredentials['phonenumber'],
                            verificationCompleted: (value) {
                              log('User Authenticated Successfully');
                            },
                            verificationFailed: (value) {},
                            codeSent: (verificationId, a) async {
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: finalOtp);

                              // Sign the user in (or link) with the credential
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithCredential(credential);
                              if (userCredential.user == null) {
                                log('Error Occured While Verifying User');
                                return;
                              } else {
                                log("User Registered Successfully ${userCredential.additionalUserInfo}");
                              }
                            },
                            codeAutoRetrievalTimeout: (value) {},
                          );
                        }
                      },
                      onChanged: (txt) {
                        if (txt.length == 1) {
                          if (index < otpFocusNodes.length - 1) {
                            otpFocusNodes[index + 1].requestFocus();
                          }
                        }
                        if (txt.trim().isEmpty) {
                          if (index - 1 >= 0) {
                            otpFocusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(29.w, 21.h, 34.h, 34.h),
            child: Row(
              children: [
                Text(
                  "Didn't Revieve a code? ",
                  style: _normalTextSpanTextStyle,
                ),
                InkWell(
                    onTap: () {
                      //TODO: Add Logic
                    },
                    child: Text('Wait For 57 sec',
                        style: _emossedTextSpanTextStyle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

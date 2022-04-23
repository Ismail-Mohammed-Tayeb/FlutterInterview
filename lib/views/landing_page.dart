import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/shared/regex_util.dart';
import 'package:flutter_interview/views/otp_verification_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController mailOrNumberField = TextEditingController();
    var _normalTextSpanTextStyle =
        TextStyle(color: Colors.grey[700], fontSize: 12.sp);
    var _emossedTextSpanTextStyle = TextStyle(
        color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Region Header Starts Here
          Padding(
            padding: EdgeInsets.fromLTRB(28.75.w, 75.h, 0, 0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                SizedBox(
                  width: 11.75.w,
                ),
                Text(
                  'Connect your wallet',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 28.sp,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            'We’ll send you a confirmation code',
            style: TextStyle(
              fontSize: 16.5.sp,
              color: Colors.grey[600],
            ),
          ),
          //Region Header Ends Here
          const Spacer(),
          //Region Body Starts Here
          Container(
            width: 327.w,
            height: 69.h,
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
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Flag.fromCode(
                      FlagsCode.GB,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: mailOrNumberField,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Phone number or Email',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 36.h),
            child: SizedBox(
              width: 327.w,
              height: 69.h,
              child: ElevatedButton(
                onPressed: () async {
                  if (mailOrNumberField.text.isEmpty) return;
                  Map<String, dynamic> userData = {};
                  if (emailRegEx.hasMatch(mailOrNumberField.text.trim())) {
                    userData["email"] = mailOrNumberField.text.trim();
                    userData["isEmail"] = true;
                  } else {
                    userData["phonenumber"] = mailOrNumberField.text.trim();
                    userData["isEmail"] = false;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return OTPVerificationPage(
                          userCredentials: userData,
                        );
                      },
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFC5FF29),
                    ),
                    elevation: MaterialStateProperty.all<double>(.0),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    )),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(29.w, 21.h, 34.h, 34.h),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'By signing up I agree to Zëdfi’s ',
                style: _normalTextSpanTextStyle,
                children: [
                  TextSpan(
                    text: 'Privacy Policy ',
                    style: _emossedTextSpanTextStyle,
                  ),
                  const TextSpan(
                    text: 'and ',
                  ),
                  TextSpan(
                    text: 'Terms of Use ',
                    style: _emossedTextSpanTextStyle,
                  ),
                  const TextSpan(
                    text: 'and allow Zedfi to use your information for future ',
                  ),
                  TextSpan(
                      text: 'Marketing purposes.',
                      style: _emossedTextSpanTextStyle)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

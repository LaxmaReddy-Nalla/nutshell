import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:nutshell/phone.dart';
import 'package:nutshell/short.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> with TickerProviderStateMixin{
    var onTapRecognizer;
bool _isLoading=false;
  TextEditingController textEditingController ;
                        //  ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // bool _isLoading = false;

  void callSnackBar(String msg, [int er]) {
    // msg="There is no record with this user, please register first by clicking Register or check the user mail id or Password";
    final SnackBar = new prefix0.SnackBar(
      content: new Text(msg),
      duration: new Duration(seconds: 3),
      // action: new SnackBarAction(label: "Register",
      // onPressed: (){
      //   Navigator.pushNamed(context, "Register");
      // },),
    );
    _scaffoldKey.currentState.showSnackBar(SnackBar);
  }


  
  String errorMessage = '';
  String status, actualCode;

  String phoneNo;
  String smsCode;
  String verificationId;
    AuthCredential  _authCredential;
 
  void initState() {
    // TODO: implement initState
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
     textEditingController = TextEditingController();

    super.initState();
 
  }

  @override
  void dispose() {
       errorController.close();
    textEditingController.dispose();
    super.dispose();
  }

 Future<void> PhoneS(String smsCode) async {
   setState(() {
     _isLoading=true;
   });
         callSnackBar("Validating otp");

    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
print("smscode $smsCode");
print("actual code $actualCode");

    _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
      setState(() {
        _isLoading=false;
      });
      callSnackBar("Otp timeout or invalid Otp");
    }).then((user) async {
      if (user.additionalUserInfo.isNewUser) {
        print(user.user.uid);
        print("firest uset");
        return Navigator.pushNamed(context, '/subs');
      }
      setState(() {
        status = 'Authentication successful';
      });
      final Firestore _firestore = Firestore.instance;

      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        print(user.toString());

        if (user != null) {
          DocumentSnapshot _docSnap =
              await _firestore.collection("users").document(user.uid).get();

          await new Future.delayed(const Duration(milliseconds: 5000));
          if (_docSnap.data['subscription']) {
             setState(() {
        _isLoading=false;
      });
            Navigator.pushNamedAndRemoveUntil(context, "/paperback", (_) => false);
          } else {
             setState(() {
        _isLoading=false;
      });
            Navigator.pushNamed(context, "/subs");
          }
        } else {
          // Navigator.pushNamedAndRemoveUntil(context, '/intro', (_) => false);
          // goToLoginPage();
          await new Future.delayed(const Duration(milliseconds: 5000));
           setState(() {
        _isLoading=false;
      });
          Navigator.pushNamedAndRemoveUntil(context, "/intro", (_) => false);
        }
      } catch (e) {
         setState(() {
        _isLoading=false;
      });
        print(e);

      }

      // Navigator.pushNamed(context, '/subs');
    });
  }

  
  // signIn(){
  //   FirebaseAuth.instance.signInWithPhoneNumber(
  //     verificationId: verificationId,
  //     smsCode: smsCode,

  //   ).then((user){
  //     Navigator.pushReplacementNamed(context, "HomeScreen");
  //   });

  // }

  String phoneValidator(String value) {
    if (value.length != 13 || value.length == null) {
      print("validation failed");
      // return 'Phone Number must be of 10 digits';
      callSnackBar("Phone Number must be of 10 digits");
      //return null;
    } else {
      callSnackBar("Sending Otp to mobile Number");
        Navigator.pushNamed(context, "otp",arguments: phoneNo);
      // verifyPhone();
      //return null;
    }
  }

  String SmsValidator(String value) {
    if (value.length != 6 || value.length == null) {
      print("validation failed");

      // return 'Phone Number must be of 10 digits';
      callSnackBar(
          "Please Enter Proper 6 digit SMS code sent to your Mobile Number");
    } else {
      callSnackBar("You are signing in please wait !!");
      
          // Navigator.of(context).pop();
          // Navigator.pushNamed(context, '/Login');
          PhoneS(value);
        
      }
      // return null;
    }
  

  @override
  Widget build(BuildContext context) {
   actualCode=ModalRoute.of(context).settings.arguments;
print("$actualCode");
    SizeConfig().init(context);
  //  String i=ModalRoute.of(context).settings.arguments;
    //0 is for otp
    
    return
         Scaffold(  
           backgroundColor: Colors.white,
           appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[IconButton(icon:Icon(Icons.arrow_back), onPressed: (){
          textEditingController.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Phone()));
        })],
       

      ),
             
             key: _scaffoldKey,

          body: 
          WillPopScope(
            onWillPop: () {
          textEditingController.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Phone()));
              
            },
                      child: SingleChildScrollView(
              child:
        Center(
            child: Container(
              color: Colors.white,
     margin: EdgeInsets.only(top:SizeConfig.wt*0.13),
      width: SizeConfig.wt*0.8,

   
      child: Center(
        child: Column(             crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top:15.0),
                //     child: Text(
                //       "OTP Verification",
                //       style:
                //           TextStyle(color: Theme.of(context).primaryColor, fontSize: 33,fontWeight: FontWeight.w600),
                //     ),
                //   ),
                // ),
                // SizedBox(height:SizeConfig.ht*0.1),
                 Padding(
                   padding:  EdgeInsets.only(top:50.0),
                   child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "One time password(OTP) has been ",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 20),
                        ),
                         Text(
                          "sent to your mobile ",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 20),
                        ),
                        ]),
                 ),
                //  Padding(
                //    padding: const EdgeInsets.all(8.0),
                //    child: Center(
                //      child:Text(
                //                     "+91-${i}",//1 is for phone number
                                    
                //                     style: TextStyle(
                //                         color: Theme.of(context).primaryColor,
                //                         fontSize: 25,
                //                         fontWeight: FontWeight.w400),
                //                   ), 
                //    ),
                //  ),
                  Center(
                    child: Text(
                            "Please enter the same here",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 20),
                          ),
                  ),

                  GestureDetector(
                                child: Container(
                                  width: SizeConfig.wt*0.35,
                                  child: PinCodeTextField(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    length: 6,
                                    obsecureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.underline,
                                      // borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 35,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                      inactiveColor: Colors.grey
                                    ),
                                    animationDuration: Duration(milliseconds: 300),
                                    // backgroundColor: Colors.blue.shade50,
                                    enableActiveFill: true,
                                    errorAnimationController: errorController,
                                    controller: textEditingController,
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    onChanged: (value) {
                                      print(value);

                                      setState(() {
                                        currentText = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                  ),
                                ),
                  ),
                  Padding(
                                padding: EdgeInsets.only(top: SizeConfig.ht * 0.045),
                                child: RaisedButton(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.ht * 0.01,
                                        bottom: SizeConfig.ht * 0.01,
                                        left: SizeConfig.wt * 0.08,
                                        right: SizeConfig.wt * 0.08),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      print("curent text $currentText");
                             SmsValidator(currentText);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(50.0),
                                    ),
                                    child:_isLoading?Center(child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              )) : Text("VERIFY OTP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22))),
                              ),
                             
                              // Center(
                              //     child: Padding(
                              //   padding: EdgeInsets.only(
                              //       top: SizeConfig.ht * 0.018, bottom: SizeConfig.ht * 0.018),
                              //   child: FlatButton(
                              //     onPressed: () {
                              //       print("Resend OTP");
                              //     },
                              //     child: Text(
                              //       "Resend OTP",
                              //       style: TextStyle(
                              //           color: Theme.of(context).primaryColor,
                              //           fontSize: 22),
                              //     ),
                              //   ),
                              // )),

               
 
               
              ],
        ),
      ),
    ),
        )
      ),
          ),
    );
  }
}
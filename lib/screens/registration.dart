import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:new_demo_firebase/utils/firebase_repository.dart';
import 'package:new_demo_firebase/widgets/common/custom_input_decoration.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();
  final TextEditingController userNameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController = TextEditingController();
  final TextEditingController emailNameTextController = TextEditingController();
  final TextEditingController mobileTextController = TextEditingController();
  bool isAcceptedTermAndCond = false;

  final firebaseRepository = FirebaseRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff444444),
            )),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Registration',style: TextStyle(fontSize: 22, color: Color(0xff444444),fontWeight:  FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF1F1F1),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [_buildForm()],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: firstNameTextController,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              labelText: "First Name",
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: lastNameTextController,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              labelText: "Last Name",
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: userNameTextController,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              labelText: "User Name",
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordTextController,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: CustomInputDecoration(
                hintText: "Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.pink,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordTextController,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            autocorrect: false,
            decoration: CustomInputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.pink,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailNameTextController,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              labelText: "Email Address",
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: mobileTextController,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              labelText: "Mobile",
              prefixIcon: Icon(
                Icons.mobile_screen_share,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildTermsAndCond(),
          SizedBox(
            height: 30,
          ),
          Center(
            child: MaterialButton(
              onPressed: () => signUp(),
              height: 35,
              minWidth: 70,
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: isLoading ? CupertinoActivityIndicator() : Text('SIGN UP',style: TextStyle(fontSize: 16, color: Colors.white ,fontWeight:  FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTermsAndCond() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
          value: isAcceptedTermAndCond,
          visualDensity: VisualDensity.compact,
          onChanged: (val) {
            setState(() {
              isAcceptedTermAndCond = val;
            });
          },
        ),
        SizedBox(
          width: 20,
        ), // you can control gap between checkbox and label with this field
        Flexible(
          child: Text(
            'I agree to the Terms and Conditions of usage and Privacy Policy',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void onSubmitPressed() {
    print('onSubmitPressed');
  }

  signUp() {
    setState(() {
      isLoading = true;
    });

    firebaseRepository.checkEmail(email: emailNameTextController.text).then((value) {
      if (value.docs.length > 0) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already exist')));
      } else {
        firebaseRepository
            .addUserData(
                firstName: firstNameTextController.text,
                lastName: lastNameTextController.text,
                email: emailNameTextController.text,
                mobileNo: mobileTextController.text,
                password: passwordTextController.text,
                userName: userNameTextController.text)
            .then((value) async {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacementNamed(context, AppRouter.LOGIN_SCREEN);
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }
}

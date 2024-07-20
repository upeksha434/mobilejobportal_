import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body:Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/right-bg.png"),

                fit: BoxFit.cover,
                opacity: 0.85 // Adjust opacity as needed
            ),
          ),

          child:_loginUI(context),


        ),
      ),
    );
  }



  Widget _loginUI(BuildContext context){
    return SingleChildScrollView(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text('surveyY',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        color: Colors.white

                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin:EdgeInsets.only(
              top:MediaQuery.of(context).size.height*0.02,

            ),
            width:MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
            decoration:const BoxDecoration(

                gradient:LinearGradient(
                    begin:Alignment.topCenter,
                    end:Alignment.bottomCenter,

                    colors:[
                      Colors.white,
                      Colors.white,

                    ]

                ),
                borderRadius:BorderRadius.vertical(
                  top:Radius.circular(30),

                )

            ),
            child: Padding(
              padding:EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start  ,
                children: [

                  Align
                    (
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/Icon.png",
                        width:150,
                        fit:BoxFit.contain,
                      )),

                  Container(
                    child: Padding(
                      padding:EdgeInsets.all(MediaQuery.of(context).size.width*0.04),
                      child: Text(
                        'Login',


                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),


                  TextField(
                    controller: AuthController.emailController,
                    decoration:
                    const InputDecoration(label: Text('Email')),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: AuthController.passwordController,
                    obscureText:  !_isPasswordVisible,
                    //obscureText: AuthController.isPasswordVisible.value,
                    decoration:
                    InputDecoration(label: Text('Password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),

                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width:double.infinity,
                      height:56,
                      child:Obx(() => ElevatedButton(
                        onPressed: (){
                          AuthController.signIn();
                        }, child: AuthController.loading.value ? const CircularProgressIndicator(color: Colors.white,) : const Text('Login',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),),
                      ))
                  )

                ],
              ),
            ),

          ),




        ],

      ),
    );

  }
}

//_obscurePassword to track the password visibility
//suffix icon to toggle password visibility
//function to toggle _obscurePassword

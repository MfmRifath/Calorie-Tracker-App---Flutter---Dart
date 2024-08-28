import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(CupertinoIcons.back)),
        title: Text('Login'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        SizedBox(height: 10.0,),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
          
                onChanged: (value) {
                },
                obscureText: false, // Hide password input
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.mail,),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.02,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff58B9A8),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey, // Text color in TextField
                  fontSize: screenHeight * 0.02,
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
          
                onChanged: (value) {
                },
                obscureText: true, // Hide password input
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.lock),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.02,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff58B9A8),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey, // Text color in TextField
                  fontSize: screenHeight * 0.02,
                ),
              ),
            ],
          ),
        ),
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0 ,right: 20.0),
            child: SizedBox(
              width: double.infinity, // Takes full width
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xff58B9A8)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                child: Text(
                  'Log in',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){},
                    child: Text('Forget Password?',
                      style: TextStyle(
                          color: Color(0xff58B9A8)
                      ),))
              ],),
          )
        ],
      )
        ],) ,
    );
  }
}

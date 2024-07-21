import 'package:flutter/material.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.of(context).maybePop();
              // Handle menu button press
            }),
        title: ResponsiveText(
          text: 'Profile',
          fontSize: 26,
          color: Colors.white,
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w400,
        ),
        //centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                ),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.04, left: MediaQuery.of(context).size.height * 0.01, right: MediaQuery.of(context).size.height * 0.01),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07, right: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.02),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(
                                'assets/images/dog.jpg') // Replace with your profile image asset
                        )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ResponsiveText(text: 'Courage', fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ResponsiveText(text: 'I am a passionate traveller who loves Snowy Mountains and camping in there.', fontSize: 20, color: Colors.white70, fontWeight: FontWeight.w400)
                          ]
                          )
                        ]
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                ),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04, left: MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.02),
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07, top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.83,
                                  child: ResponsiveText(
                                      text: 'Contact Information',
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.83,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                        child: Icon(Icons.email, color: Colors.white),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: ResponsiveText(
                                            text: 'temporarymail@temporary.com',
                                            fontSize: 20,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.83,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                        child: Icon(Icons.phone, color: Colors.white),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: ResponsiveText(
                                            text: '0333-333-3333',
                                            fontSize: 20,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.83,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                        child: Icon(Icons.location_on_outlined, color: Colors.white),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: ResponsiveText(
                                            text: 'Lahore, Pakistan',
                                            fontSize: 20,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ]
                        )
                )
              ),
            ]
          );
        }
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        // mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(String mail) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: mail,
    );
    String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        // mode: LaunchMode.externalApplication,
      );
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ListView(
      children: [
        SizedBox(height: deviceSize.height/4/4/4/2,),
        Image.asset(
          'assets/logo.png',
          height: deviceSize.height / 3,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(1),
          margin: EdgeInsets.only(
            left: deviceSize.width / 4 / 4 / 2,
            right: deviceSize.width / 4 / 4 / 2,
            top: deviceSize.height / 4 / 4 / 4,
          ),
          child: Text(
            'GoFurbish.Co.Ltd',
            style: TextStyle(
                color: Color(0xff900D3E),
                fontWeight: FontWeight.bold,
                fontSize: deviceSize.height / 4 / 4 / 2),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(1),
          margin: EdgeInsets.only(
            left: deviceSize.width / 4 / 4 / 2,
            right: deviceSize.width / 4 / 4 / 2,
            top: deviceSize.height / 4 / 4 / 2,
          ),
          child: InkWell(
            onTap: ()async{
              await launchUrl(Uri.parse('https://generator.lorem-ipsum.info/terms-and-conditions'));
            },
            child: Text(
              'Terms And Conditions',
              style: TextStyle(
                  color: Color(0xff900D3E),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  fontSize: deviceSize.height / 4 / 4 / 3),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(1),
          margin: EdgeInsets.only(
            left: deviceSize.width / 4 / 4 / 2,
            right: deviceSize.width / 4 / 4 / 2,
            top: deviceSize.height / 4 / 4 / 2,
          ),
          child: InkWell(
            onTap: () async {
              _launchURL('amangupta9076@gmail.com');
            },
            child: Text(
              'Send Email',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xff900D3E),
                  fontWeight: FontWeight.w500,
                  fontSize: deviceSize.height / 4 / 4 / 3),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await _makePhoneCall('tel:9167158784');
          },
          child: Container(
            width: double.infinity,
            height: deviceSize.height / 4 / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff900D3E),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: deviceSize.width / 4 / 4 / 2,
              right: deviceSize.width / 4 / 4 / 2,
              top: deviceSize.height / 4 / 4 / 2,
            ),
            child: Text(
              'Call us',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: deviceSize.height / 4 / 4 / 3),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx_app/screens/myproduct_screen.dart';
import 'package:olx_app/screens/product_upload_screen.dart';
import 'package:olx_app/screens/support_screen.dart';
import '/provider/auth.dart';
import '/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int index;

  const BottomNavigationScreen({
    required this.index,
  });
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  bool selectedText = false;
  int _index = 0;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  _showAlertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          final deviceSize = MediaQuery.of(context).size;
          return AlertDialog(
              backgroundColor: Colors.white,
              iconPadding: EdgeInsets.only(
                  top: 0, bottom: deviceSize.height / 4 / 4 / 4),
              title: Text('Log Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceSize.height / 4 / 4 / 3,
                      fontWeight: FontWeight.bold)),
              content: Container(
                margin: EdgeInsets.only(
                    left: deviceSize.width / 4 / 4 / 3,
                    right: deviceSize.width / 4 / 4 / 3),
                child: Text('Are you sure you want to Log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: deviceSize.height / 4 / 4 / 3,
                        fontWeight: FontWeight.w500)),
              ),
              icon: Column(children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  size: deviceSize.height / 4 / 4,
                )
              ]),
              actions: [
                Column(children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff900D3E),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff900D3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE9E9E9),
                        border:
                            Border.all(color: Color(0xff900D3E), width: .6)),
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 3,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        await Provider.of<Auth>(context, listen: false)
                            .logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('Yes',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  )
                ])
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List _bottomnavigation = [
      {
        'icon': Icon(
          Icons.home,
          size: deviceSize.height / 4 / 4 * .6,
        ),
        'label': 'Home',
      },
      {
        'icon': Icon(
          Icons.add_business_outlined,
          size: deviceSize.height / 4 / 4 * .6,
        ),
        'label': 'Add Product',
      },
      {
        'icon': Icon(
          Icons.business_sharp,
          size: deviceSize.height / 4 / 4 * .6,
        ),
        'label': 'My Product',
      },
      {
        'icon': Icon(
          Icons.support_agent,
          size: deviceSize.height / 4 / 4 * .6,
        ),
        'label': 'Support',
      },
    ];
    late Widget _child;
    // if (widget.index < 5 && widget.index > -1) {
    //   _index = widget.index;
      switch (_index) {
        case 0:
          _child = HomeScreen();
          break;
        case 1:
          _child = ProductUploadScreen();
          break;
        case 2:
          _child = MyProductScreen();
          break;
        case 3:
          _child = SupportScreen();
          break;
      }
  //  }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height / 4 / 3 * .9),
        child: AppBar(
          elevation: 3,
          backgroundColor: Color(0xff900D3E),
          leadingWidth: 0,
          title: Text(
            _index == 0
                ? 'GoFurbish'
                : _index == 1
                    ? 'Add Product'
                    : _index == 2
                        ? 'My Product'
                        : _index == 3
                            ? 'Support'
                            : '',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: deviceSize.height / 4 / 4 / 2 * .8),
          ),
          actions: [
            OutlinedButton(
                onPressed: () async {
                  _showAlertDialog();
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      body: SafeArea(child: _child),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        selectedItemColor: Color(0xff900D3E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: deviceSize.width / 4 / 4 / 2,
        unselectedFontSize: deviceSize.width / 4 / 4 / 2,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) async {
          setState(() {
            _index=newIndex;
          });
          print(_index);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => BottomNavigationScreen(
          //               index: newIndex,
          //             )));
        },
        currentIndex: _index,
        items: [
          ..._bottomnavigation.map(
            (bottomitem) => BottomNavigationBarItem(
              icon: bottomitem['icon'],
              backgroundColor:
                  selectedText == false ? Colors.grey : Color(0xff900D3E),
              label: bottomitem['label'],
            ),
          )
        ],
      ),
    );
  }
}

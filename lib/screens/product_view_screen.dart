import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx_app/screens/photo_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/auth.dart';
import 'product_edit_screen.dart';
import 'splash_screen.dart';

class ProductViewScreen extends StatefulWidget {
  final String docid,
      prodname,
      proddesc,
      prodid,
      prodprice,
      prodquantity,
      prodcat,
      prodimg,
      sellernumber,
      sellerid,
      selleremail,
      sellername;
  const ProductViewScreen(
      {super.key,
      required this.prodname,
      required this.proddesc,
      required this.prodprice,
      required this.prodquantity,
      required this.prodcat,
      required this.sellernumber,
      required this.selleremail,
      required this.prodimg,
      required this.sellername,
      required this.sellerid,
      required this.docid,
      required this.prodid});

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
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

  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection("products").doc(id).delete();
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

  _showdeleteDialog(id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          final deviceSize = MediaQuery.of(context).size;
          return AlertDialog(
              backgroundColor: Colors.white,
              iconPadding: EdgeInsets.only(
                  top: 0, bottom: deviceSize.height / 4 / 4 / 4),
              content: Container(
                margin: EdgeInsets.only(
                    left: deviceSize.width / 4 / 4 / 3,
                    right: deviceSize.width / 4 / 4 / 3),
                child: Text('Are you sure you want to delete product ?',
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
                  FontAwesomeIcons.trashCan,
                  color: Colors.red,
                  size: deviceSize.height / 4 / 4,
                ),
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
                        await deleteProduct(id);
                        Navigator.pop(context);
                        Navigator.pop(context);
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height / 4 / 3 * .9),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 3,
          backgroundColor: Color(0xff900D3E),
          leadingWidth: 0,
          title: Text(
            widget.prodname,
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
      body: SafeArea(
          child: Column(children: [
        Expanded(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PhotoViewScreen(url: widget.prodimg)));
                },
                child: Image.network(
                  widget.prodimg,
                  height: deviceSize.height / 3,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
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
                  '${widget.prodname[0].toUpperCase()}${widget.prodname.substring(1).toLowerCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: deviceSize.height / 4 / 4 / 3),
                ),
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
                  '₹ ' + widget.prodprice,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: deviceSize.height / 4 / 4 / 3),
                ),
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
                  'Qunatity: ' + widget.prodquantity,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: deviceSize.height / 4 / 4 / 3),
                ),
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
                  '${widget.proddesc[0].toUpperCase()}${widget.proddesc.substring(1).toLowerCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: deviceSize.height / 4 / 4 / 3),
                ),
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
                  'Seller Name: ' +
                      '${widget.sellername[0].toUpperCase()}${widget.sellername.substring(1).toLowerCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: deviceSize.height / 4 / 4 / 3),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: deviceSize.height / 4 / 3,
          margin: EdgeInsets.only(
              left: deviceSize.width / 4 / 4 / 3,
              right: deviceSize.width / 4 / 4 / 3,
              top: deviceSize.height / 4 / 4 / 4,
              bottom: deviceSize.height / 4 / 4 / 4),
          child: Row(children: [
            Expanded(
                child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff900D3E),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: TextButton.icon(
                  onPressed: () async {
                    if (widget.sellerid ==
                        Provider.of<Auth>(context, listen: false).userId) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProductEditScreen(
                                    docid: widget.docid,
                                    prodcat: widget.prodcat,
                                    proddesc: widget.proddesc,
                                    prodid: widget.prodid,
                                    prodimg: widget.prodimg,
                                    prodname: widget.prodname,
                                    prodprice: widget.prodprice,
                                    prodquantity: widget.prodquantity,
                                    selleremail: widget.selleremail,
                                    sellername: widget.sellername,
                                    sellernumber: widget.sellernumber,
                                  )));
                    } else {
                      await _makePhoneCall('tel:${widget.sellernumber}');
                    }
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.phoneVolume,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    child: Text(
                      widget.sellerid ==
                              Provider.of<Auth>(context, listen: false).userId
                          ? 'Edit Product'
                          : 'Call Seller',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.height / 4 / 4 / 3,
                          color: Colors.white),
                    ),
                  )),
            )),
            SizedBox(
              width: deviceSize.width / 4 / 4 / 4,
            ),
            Expanded(
                child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff900D3E),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: TextButton.icon(
                  onPressed: () async {
                    if (widget.sellerid ==
                        Provider.of<Auth>(context, listen: false).userId) {
                      await _showdeleteDialog(widget.docid);
                    } else {
                      _launchURL(widget.selleremail);
                    }
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    child: Text(
                      widget.sellerid ==
                              Provider.of<Auth>(context, listen: false).userId
                          ? 'Delete Product'
                          : 'Send an email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.height / 4 / 4 / 3,
                          color: Colors.white),
                    ),
                  )),
            )),
          ]),
        )
      ])),
    );
  }
}

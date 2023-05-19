// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx_app/screens/product_edit_screen.dart';
import 'package:olx_app/screens/product_view_screen.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selcetedcategory = 'Choose Category';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(children: [
      Container(
        width: double.infinity,
        height: deviceSize.height / 4 / 3,
        padding: EdgeInsets.only(
          left: deviceSize.width / 4 / 4 / 2,
          right: deviceSize.width / 4 / 4 / 2,
        ),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(1),
                child: Text(
                  Provider.of<Auth>(context, listen: false).username == ''
                      ? 'Welcome'
                      : 'Welcome ${Provider.of<Auth>(context, listen: false).username[0].toUpperCase()}${Provider.of<Auth>(context, listen: false).username.substring(1).toLowerCase()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: deviceSize.height / 4 / 4 / 2 * .7),
                ),
              ),
            ),
            Container(
              width: deviceSize.width / 2 * .8,
              height: deviceSize.height / 4 / 3 * .9,
              decoration: BoxDecoration(color: Colors.white),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                hint: FittedBox(
                  child: Text(
                    selcetedcategory,
                    style: TextStyle(
                      fontFamily: 'SourceSerifPro',
                      fontWeight: FontWeight.w400,
                      fontSize: deviceSize.height / 4 / 4 / 3,
                      color: Colors.black,
                    ),
                  ),
                ),
                isExpanded: true,
                iconSize: deviceSize.width / 4 / 3,
                style: TextStyle(
                  fontSize: deviceSize.height / 4 / 4 / 3,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SourceSerifPro',
                ),
                items: [
                  'Choose Category',
                  'Electronics',
                  'Clothing',
                  'Vehicle',
                  'Other'
                ].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: FittedBox(child: Text(val)),
                    );
                  },
                ).toList(),
                onChanged: (val) async {
                  setState(
                    () {
                      selcetedcategory = val.toString();
                    },
                  );
                },
              )),
            ),
          ],
        ),
      ),
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      'No product found to sell',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),
                    ),
                  )
                : selcetedcategory == 'Choose Category'
                    ? ListView(
                        children: snapshot.data!.docs.map((document) {
                        final dynamic data = document.data();
                        return GestureDetector(
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.only(
                                top: deviceSize.height / 4 / 4 / 2,
                                left: deviceSize.width / 4 / 4 / 2,
                                right: deviceSize.width / 4 / 4 / 2),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: deviceSize.width / 4 / 4 / 4,
                                  right: 1,
                                  top: deviceSize.height / 4 / 4 / 4 / 2,
                                  bottom: deviceSize.height / 4 / 4 / 4 / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['productimage'].toString(),
                                        width: deviceSize.width / 3 * .8,
                                        height: deviceSize.height / 4 * .7,
                                        fit: BoxFit.fill,
                                      )),
                                  SizedBox(
                                    width: deviceSize.width / 4 / 4 / 2,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data['productname'][0].toUpperCase()}${data['productname'].substring(1).toLowerCase()}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        deviceSize.height /
                                                            4 /
                                                            4 /
                                                            3),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              deviceSize.height / 4 / 4 / 4 / 2,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '₹ ' + data['productprice'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        deviceSize.height /
                                                            4 /
                                                            4 /
                                                            3),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              deviceSize.height / 4 / 4 / 4 / 2,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Desc: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data['productdesc'][0].toUpperCase()}${data['productdesc'].substring(1).toLowerCase()}',
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        deviceSize.height /
                                                            4 /
                                                            4 /
                                                            3),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              deviceSize.height / 4 / 4 / 4 / 2,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sellername: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data['sellername'][0].toUpperCase()}${data['sellername'].substring(1).toLowerCase()}',
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        deviceSize.height /
                                                            4 /
                                                            4 /
                                                            3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  data['sellerid'] !=
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .userId
                                      ? Container()
                                      : Container(
                                          height: deviceSize.height / 4 * .7,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ProductEditScreen(
                                                                    docid:
                                                                        document
                                                                            .id,
                                                                    prodcat: data[
                                                                        'category'],
                                                                    proddesc: data[
                                                                        'productdesc'],
                                                                    prodid: data[
                                                                        'productid'],
                                                                    prodimg: data[
                                                                        'productimage'],
                                                                    prodname: data[
                                                                        'productname'],
                                                                    prodprice: data[
                                                                        'productprice'],
                                                                    prodquantity:
                                                                        data[
                                                                            'productquantity'],
                                                                    selleremail:
                                                                        data[
                                                                            'selleremail'],
                                                                    sellername:
                                                                        data[
                                                                            'sellername'],
                                                                    sellernumber:
                                                                        data[
                                                                            'sellernumber'],
                                                                  )));
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .penToSquare,
                                                    )),
                                              ])),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductViewScreen(
                                          prodcat: data['category'],
                                          prodid: data['productid'],
                                          proddesc: data['productdesc'],
                                          prodimg: data['productimage'],
                                          prodname: data['productname'],
                                          prodprice: data['productprice'],
                                          prodquantity: data['productquantity'],
                                          selleremail: data['selleremail'],
                                          sellernumber: data['sellernumber'],
                                          sellername: data['sellername'],
                                          sellerid: data['sellerid'],
                                          docid: document.id,
                                        )));
                          },
                        );
                      }).toList())
                    : snapshot.data!.docs
                            .where((element) =>
                                element['category'] == selcetedcategory)
                            .toList()
                            .isEmpty
                        ? Center(
                            child: Text(
                              'Product not found under\n ${selcetedcategory} category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: deviceSize.height / 4 / 4 / 3),
                            ),
                          )
                        : ListView(
                            children: snapshot.data!.docs
                                .where((element) =>
                                    element['category'] == selcetedcategory)
                                .toList()
                                .map((document) {
                            final dynamic data = document.data();
                            return GestureDetector(
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.only(
                                    top: deviceSize.height / 4 / 4 / 2,
                                    left: deviceSize.width / 4 / 4 / 2,
                                    right: deviceSize.width / 4 / 4 / 2),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: deviceSize.width / 4 / 4 / 4,
                                      right: 1,
                                      top: deviceSize.height / 4 / 4 / 4 / 2,
                                      bottom:
                                          deviceSize.height / 4 / 4 / 4 / 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            data['productimage'].toString(),
                                            width: deviceSize.width / 3 * .8,
                                            height: deviceSize.height / 4 * .7,
                                            fit: BoxFit.fill,
                                          )),
                                      SizedBox(
                                        width: deviceSize.width / 4 / 4 / 2,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Name: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${data['productname'][0].toUpperCase()}${data['productname'].substring(1).toLowerCase()}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: deviceSize.height /
                                                  4 /
                                                  4 /
                                                  4 /
                                                  2,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Price: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '₹ ' + data['productprice'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: deviceSize.height /
                                                  4 /
                                                  4 /
                                                  4 /
                                                  2,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Desc: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${data['productdesc'][0].toUpperCase()}${data['productdesc'].substring(1).toLowerCase()}',
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: deviceSize.height /
                                                  4 /
                                                  4 /
                                                  4 /
                                                  2,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Sellername: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${data['sellername'][0].toUpperCase()}${data['sellername'].substring(1).toLowerCase()}',
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      data['sellerid'] !=
                                              Provider.of<Auth>(context,
                                                      listen: false)
                                                  .userId
                                          ? Container()
                                          : Container(
                                              height:
                                                  deviceSize.height / 4 * .7,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ProductEditScreen(
                                                                        docid: document
                                                                            .id,
                                                                        prodcat:
                                                                            data['category'],
                                                                        proddesc:
                                                                            data['productdesc'],
                                                                        prodid:
                                                                            data['productid'],
                                                                        prodimg:
                                                                            data['productimage'],
                                                                        prodname:
                                                                            data['productname'],
                                                                        prodprice:
                                                                            data['productprice'],
                                                                        prodquantity:
                                                                            data['productquantity'],
                                                                        selleremail:
                                                                            data['selleremail'],
                                                                        sellername:
                                                                            data['sellername'],
                                                                        sellernumber:
                                                                            data['sellernumber'],
                                                                      )));
                                                        },
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .penToSquare,
                                                        )),
                                                  ])),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProductViewScreen(
                                              prodcat: data['category'],
                                              prodid: data['productid'],
                                              proddesc: data['productdesc'],
                                              prodimg: data['productimage'],
                                              prodname: data['productname'],
                                              prodprice: data['productprice'],
                                              prodquantity:
                                                  data['productquantity'],
                                              selleremail: data['selleremail'],
                                              sellernumber:
                                                  data['sellernumber'],
                                              sellername: data['sellername'],
                                              sellerid: data['sellerid'],
                                              docid: document.id,
                                            )));
                              },
                            );
                          }).toList());
          },
        ),
      )
    ]);
  }
}

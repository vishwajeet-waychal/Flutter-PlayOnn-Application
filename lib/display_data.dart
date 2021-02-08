import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intership_task/image_view.dart';
import 'package:flutter_intership_task/modal/week_day_label.dart';
import 'package:flutter_intership_task/screen_transition/page_transition_effect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:intl/intl.dart';

class DisplayData extends StatefulWidget {
  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {

  List data;
  String url = 'http://playonnuat-env.eba-ernpdw3w.ap-south-1.elasticbeanstalk.com/api/v1/establishment/test/list?offset=0&limit=10';

  Future<void> fetchData() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var result = await http.get(
          Uri.encodeFull(url),
          headers: {"Accept": "application/json"}
          );
      setState(() {
        data = json.decode(result.body);
      });
    } else {
      print('error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Widget displayData() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return listTile(data, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Details",
                      style: GoogleFonts.josefinSans(
                          textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.grey[300]
                                )
                              ]
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: displayData(),
            )
          ],
        ),
      ),
    );
  }
}

class listTile extends StatefulWidget {

  int index;
  List data;
  listTile(this.data, this.index);

  @override
  _listTileState createState() => _listTileState();
}

class _listTileState extends State<listTile> {
  @override
  Widget build(BuildContext context) {
    bool isMonday = false, isTuesday = false, isWednesday = false, isThursday = false, isFriday = false, isSaturday = false, isSunday = false;
    var createOn, updatedOn, inputDate, outputFormat, openTime, closeTime;
    DateTime parseDate;

    parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(widget.data[widget.index]['createOn']);
    inputDate = DateTime.parse(parseDate.toString());
    outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    createOn = outputFormat.format(inputDate);

    parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(widget.data[widget.index]['updatedOn']);
    inputDate = DateTime.parse(parseDate.toString());
    outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    updatedOn = outputFormat.format(inputDate);

    parseDate = new DateFormat("HH:mm").parse(widget.data[widget.index]['openTime']);
    inputDate = DateTime.parse(parseDate.toString());
    outputFormat = DateFormat('hh:mm a');
    openTime = outputFormat.format(inputDate);

    parseDate = new DateFormat("HH:mm").parse(widget.data[widget.index]['closeTime']);
    inputDate = DateTime.parse(parseDate.toString());
    outputFormat = DateFormat('hh:mm a');
    closeTime = outputFormat.format(inputDate);

    for(int i = 0; i < widget.data[widget.index]['dayOfWeeksOpen'].length; i++) {
      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Mon") {
        isMonday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Tue") {
        isTuesday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Wed") {
        isWednesday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Thu") {
        isThursday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Fri") {
        isFriday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Sat") {
        isSaturday = true;
      }

      if(widget.data[widget.index]['dayOfWeeksOpen'][i] == "Sun") {
        isSunday = true;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 5, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: Colors.indigoAccent[100],
        elevation: 15,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(widget.data[widget.index]['sports']['iconBlackUrl'], height: 20, width: 20, fit: BoxFit.fill,),
                      SizedBox(width: 10,),
                      Text(
                        widget.data[widget.index]['sports']['name'],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ID : " + widget.data[widget.index]['id'].toString(),
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: Colors.blueAccent
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
              Divider(),
              SizedBox(height: 10,),
              widget.data[widget.index]['images'] != null ? CarouselSlider.builder(
                itemCount: widget.data[widget.index]['images'].length,
                itemBuilder: (context, index3, realIdx) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context, ScaleRoute(page: ImageView(widget.data[widget.index]['images'][index3])));
                            },
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/gif/loading.gif',
                            image: widget.data[widget.index]['images'][index3],
                          )
                      )
                  );
                },
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 0,
                  reverse: false,
                  enableInfiniteScroll: false
                ),
              ) : Container(),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Open time: ",
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              color: Colors.purple,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          openTime,
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Close time: ",
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              color: Colors.purple,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          closeTime,
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Slot time size: ",
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              color: Colors.purple,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          widget.data[widget.index]['slotTimeSize'].toString(),
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Cost per slot: ",
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              color: Colors.purple,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          "Rs. " + widget.data[widget.index]['costPerSlot'].toString(),
                          style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  children: [
                    Text(
                      "Week days:",
                      style: GoogleFonts.workSans(
                          fontSize: 15,
                          color: Colors.purple,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(width: 5,),
                    WeekDay("S", isSunday),
                    SizedBox(width: 5,),
                    WeekDay("M", isMonday),
                    SizedBox(width: 5,),
                    WeekDay("T", isTuesday),
                    SizedBox(width: 5,),
                    WeekDay("W", isWednesday),
                    SizedBox(width: 5,),
                    WeekDay("T", isThursday),
                    SizedBox(width: 5,),
                    WeekDay("F", isFriday),
                    SizedBox(width: 5,),
                    WeekDay("S", isSaturday),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Created on: ",
                          style: GoogleFonts.workSans(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          createOn,
                          style: GoogleFonts.workSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Modified on: ",
                          style: GoogleFonts.workSans(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          updatedOn,
                          style: GoogleFonts.workSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w300
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

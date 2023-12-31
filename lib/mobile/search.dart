import 'package:PharmacyApp/shared/connect.dart';
/*
todo:
   connect
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'home.dart' as HomePage;
import 'package:PharmacyApp/shared/medicine.dart';
import 'package:http/http.dart' as http;
import 'package:PharmacyApp/shared/connect.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  static const String route = '/route_search';

  @override
  State<Search> createState() => _SearchState();
}

enum Filter { searchBy, Name, Genre }

class _SearchState extends State<Search> {
  late List<String> categories = ['null'];
  late List<Widget> categoriesWidgets;
  List<Medicine> medicines = [];

  @override
  void initState(){
    super.initState();
    filter = Filter.searchBy;

  }

  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();
  bool _isLoading = false;
  String? _selectedSearchType = 'search by';
  int itemCount = 0;
  final TextEditingController _searchController =
      TextEditingController(text: '');
  List<Medicine> allItems = [];
  final List<Medicine> _tempList = [];

  final List<Medicine> _searchResults = [];
  Filter? filter = Filter.searchBy;

  Timer t = Timer(const Duration(seconds: 10), () async {
    http.Response response = await http.get(Uri.parse('url'));
  });

  void search(String query, Filter filter) {
    ScaffoldKey.currentState!.setState(() {
      _searchResults.clear();
      for (Medicine item in allItems) {
        if (filter == Filter.searchBy) {
          _searchResults.add(item);
        } else if (filter == Filter.Genre) {
          if (item.category.contains(query)) {
            _searchResults.add(item);
          }
        } else if (filter == Filter.Name) {
          if (item.scientificName.contains(query)) {
            _searchResults.add(item);
          }
        }
      }
    });
  }

  void sortBy(List<Medicine> sortedList) {
    if (sortedList.isNotEmpty) {
      setState(() {
        sortedList.sort((a, b) => a.scientificName.compareTo(b.scientificName));
      });
    }
  }

  void _switchLoading(bool b) {
    _isLoading = b;
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      backgroundColor: Color.fromRGBO(22, 1, 32, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(153, 153, 153, 1.0),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _getMedicines();
                search(_searchController.text, filter!);
              },
            ),
          ),
          onChanged: (value) {
            //search(value, filter!);
          },
        ),
      ),
      body: Container(
        width: 600,
        height: 600,
        child: Column(
          children: [
            Container(
              width: 550,
              height: 40,
              child: Column(
                children: [
                  Container(
                    height: 35,
                    margin: EdgeInsets.only(left: 300),
                    child: DropdownButton<String>(
                      dropdownColor: Color.fromRGBO(153, 153, 153, 1),
                      value: _selectedSearchType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSearchType = newValue;
                        });
                      },
                      items: ['search by', 'Name', 'Genre']
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 260,
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final currentItem = _searchResults[index];
                        return ListTile(
                          style: ListTileStyle.list,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Row(
                            children: [
                              Text(currentItem.scientificName),
                              SizedBox(
                                width: 50,
                              ),
                              Text(currentItem.category),
                            ],
                          ),
                          tileColor: Colors.purple,
                          onTap: () {
                            setState(() {
                              ImportantLists.RecentList.add(currentItem);
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Color.fromRGBO(153, 153, 153, 1.0),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Medicine Info'),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.close)),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'Scientefic Name : ${currentItem.scientificName}'),
                                        Text(
                                            'Commercial Name : ${currentItem.commercialName}'),
                                        Text(
                                            'Category : ${currentItem.category}'),
                                        Text(
                                            'Company : ${currentItem.company}'),
                                        Text(
                                            'Amount : ${currentItem.availableAmount}'),
                                        Text('Price : ${currentItem.price}'),
                                        Text(
                                            'Expiration Date : ${DateFormat('dd/MM/yyyy').format(currentItem.expirationDate).toString()}'),
                                      ],
                                    ),
                                  );
                                });
                          },
                        );
                      },
                    )
                  : _isLoading
                      ? SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            'No Results',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  _getMedicines() async {
    _switchLoading(true);
    http.Response response = await http
        .get(Uri.parse('http://${usedIP}:8000/api/getmedicine'), headers: {
      'Authorization': "Bearer ${userInfoPharmacist["api_token"]}"
    });
    _switchLoading(false);
    if (jsonDecode(response.body)["statusNumber"] == 200) {
      setState(() {
        Map<String, dynamic> responseMap =
            jsonDecode(response.body)["categories"];
        _tempList.clear();
        for (var key in responseMap.keys) {
          _tempList.add(Medicine(
              id: responseMap[key][0]["id"],
              scientificName: responseMap[key]![0]["s_name"],
              commercialName: responseMap[key]![0]["t_name"],
              category: responseMap[key]![0]["category"],
              company: responseMap[key]![0]["s_name"],
              expirationDate: DateTime.parse(responseMap[key]![0]["end_date"]),
              price: responseMap[key]![0]["price"] is double
                  ? responseMap[key]![0]["price"]
                  : double.parse('${responseMap[key]![0]["price"]}.0'),
              availableAmount: responseMap[key]![0]["id"]));
        }
        _tempList.sort((a, b) => a.scientificName.compareTo(b.scientificName));
        allItems = _tempList;
      });
      print(jsonDecode(response.body)["message"]);
    } else if (jsonDecode(response.body)["statusNumber"] == 403) {
      print(jsonDecode(response.body)["message"]);
    }
  }
}

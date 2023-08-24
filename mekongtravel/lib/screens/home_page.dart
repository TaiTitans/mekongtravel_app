import 'package:flutter/material.dart';
import 'package:mekongtravel/core/constants/color_constants.dart';
import 'package:mekongtravel/core/constants/dataitems_constants.dart';
import 'package:mekongtravel/screens/bonus/categories_widget.dart';
import 'package:mekongtravel/screens/bonus/popular_height_list.dart';
import 'package:mekongtravel/screens/bonus/popular_width_list.dart';
import 'package:mekongtravel/screens/bonus/bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      FocusScope.of(context).unfocus(); // Hide the keyboard
    });
  }

  int _selectedIndex = 0; // Khai báo và khởi tạo mặc định
  PageController _pageController = PageController(); // Khai báo PageController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.share_location,
                        color: ColorPalette.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Ninh Kieu, Can Tho",
                        style: TextStyle(
                          color: ColorPalette.text,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.expand_more,
                        color: ColorPalette.primaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Let's Travel",
                  style: TextStyle(
                    color: ColorPalette.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14),
                Container(
                  height: 50, // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFF263238),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.search,
                        size: 30,
                        color: ColorPalette.primaryColor, // Change icon color
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                              color: Colors.black), // Change text color
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm ...',
                            hintStyle: TextStyle(
                                color: ColorPalette
                                    .subColorText), // Change hint text color
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch, // Use the clear function
                        color: ColorPalette.subColorText, // Change icon color
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                CategoriesWidget(),
                SizedBox(height: 30),
                Text(
                  "Địa điểm nổi bật",
                  style: TextStyle(
                    color: ColorPalette.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18),
                PopularWList(),
                SizedBox(height: 24),
                Text(
                  "Được yêu thích",
                  style: TextStyle(
                    color: ColorPalette.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: PopularHList(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavyBar(
            backgroundColor: Color(0xFF263238),
            selectedIndex: _selectedIndex,
            showElevation: false,
            containerHeight: 72,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Trang chủ'),
                activeColor: ColorPalette.text,
                inactiveColor: ColorPalette.primaryColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.gps_fixed),
                title: Text('Vị trí'),
                activeColor: ColorPalette.text,
                inactiveColor: ColorPalette.primaryColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.restaurant),
                title: Text('Ẩm thực'),
                activeColor: ColorPalette.text,
                inactiveColor: ColorPalette.primaryColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Cài đặt'),
                activeColor: ColorPalette.text,
                inactiveColor: ColorPalette.primaryColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}

void main() {
  runApp(MaterialApp(home: HomePage()));
}
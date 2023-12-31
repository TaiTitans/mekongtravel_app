import 'package:flutter/material.dart';
import 'package:mekongtravel/core/constants/color_constants.dart';
import 'package:mekongtravel/core/constants/dataitems_constants.dart';
import 'package:mekongtravel/screens/bonus/categories_widget.dart';
import 'package:mekongtravel/screens/bonus/popular_height_list.dart';
import 'package:mekongtravel/screens/bonus/popular_width_list.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:mekongtravel/screens/foods_item.dart';
import 'package:mekongtravel/screens/foods_page.dart';
import 'package:mekongtravel/screens/locations_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:mekongtravel/screens/settings.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart';
import '../core/constants/diadiem.dart';
import 'package:mekongtravel/core/constants/remote_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<DiaDiemEach> searchResults = [];
  RemoteService _remoteService = RemoteService();
  List<TinhThanh> tinhThanhList = [];
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      FocusScope.of(context).unfocus(); // Hide the keyboard
    });
  }

  int _selectedIndex = 0; // Khai báo và khởi tạo mặc định
  PageController _pageController = PageController(); // Khai báo PageController

//Lay thong tin vi tri hien tai
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchTinhThanhList();
  }
  Future<void> _fetchTinhThanhList() async {
    List<TinhThanh> tinhThanhList = await _remoteService.getTinhThanhList();
    // Now you have tinhThanhList, you can use it for search
  }
  Future<void> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service Disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = position;
      });

      if (_currentLocation != null) {
        _getAddressFromCoordinates();
      }
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.name}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }
  void _onSearch(String query) {
    if (query.isNotEmpty) {
      List<DiaDiemEach> results = _remoteService.searchDiaDiem(query, tinhThanhList);
      setState(() {
        searchResults = results;
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.share_location,
                        color: ColorPalette.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "${_currentAddress}",
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
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm ...',
                            hintStyle: TextStyle(color: ColorPalette.subColorText),
                            border: InputBorder.none,
                          ),
                          onChanged: _onSearch, // Gọi hàm tìm kiếm khi có thay đổi
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
                // CategoriesWidget(),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageSlideshow(
                    /// Width of the [ImageSlideshow].
                    width: double.infinity,

                    /// Height of the [ImageSlideshow].
                    height: 130,

                    /// The page to show when first creating the [ImageSlideshow].
                    initialPage: 0,

                    /// The color to paint the indicator.
                    indicatorColor: Colors.blue,

                    /// The color to paint behind the indicator.
                    indicatorBackgroundColor: Colors.grey,

                    /// The widgets to display in the [ImageSlideshow].
                    /// Add the sample image file into the images folder
                    children: [
                      Image.asset(
                        'assets/images/homepageimg/1.png', // Update the asset path
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/images/homepageimg/2.png', // Update the asset path
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/images/homepageimg/3.png', // Update the asset path
                        fit: BoxFit.cover,
                      ),
                    ],

                    /// Called whenever the page in the center of the viewport changes.
                    onPageChanged: (value) {
                    },

                    /// Auto scroll interval.
                    /// Do not auto scroll with null or 0.
                    autoPlayInterval: 3000,

                    /// Loops back to the first slide.
                    isLoop: true,
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  "Địa điểm nổi bật",
                  style: TextStyle(
                    color: ColorPalette.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                PopularWList(),
                SizedBox(height: 20),
                Text(
                  "Được yêu thích",
                  style: TextStyle(
                    color: ColorPalette.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 14),
                Expanded(
                  child: ListView(
                    children: [
                    PopularHList(),
                    ],
                  ),
                ),
                // Expanded(
                //   child: ListView(
                //     children: [
                //       // Hiển thị kết quả tìm kiếm
                //       if (searchResults.isNotEmpty)
                //         Column(
                //           children: searchResults
                //               .map((result) => ListTile(
                //             title: Text(result.tenDiaDiem),
                //             // Hiển thị các thông tin khác của result tùy ý
                //             // Ví dụ: subtitle: Text(result.moTa),
                //           ))
                //               .toList(),
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),

          )
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
              if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationsPage(),
                    ));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodsPage(),
                    ));
              } else if (index == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ));
              }
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
      ),

    );
  }
}

void main() {
  runApp(MaterialApp(home: HomePage()));
}

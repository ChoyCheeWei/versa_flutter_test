import 'package:flutter/material.dart';
import 'package:versa_flutter_test/api/api_service.dart';
import 'package:versa_flutter_test/database/database.dart';
import 'package:versa_flutter_test/screens/brewery_details_screen.dart';
import 'package:versa_flutter_test/screens/favorite_brewery_screen.dart';

import '../models/brewery_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController controller;
  List<BreweryModel>? breweryModelList = [];
  List<BreweryModel>? favoriteBreweryList = [];
  int page = 1;
  bool loadMoreData = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    _fetchData();
  }

  void _fetchData() async {
    showLoading();
    await _fetchDataFromDataBase();
    await _fetchScreenData(isFirstLoad: true);
    hideLoading();
  }

  Future<void> _fetchDataFromDataBase() async {
    favoriteBreweryList = await BreweryDatabase.instance.getAllBreweries();
  }

  Future<void> _fetchScreenData({required bool isFirstLoad}) async {
    List<BreweryModel>? _breweryModelList = await ApiService().getBreweryList(page: page);
    if (_breweryModelList != null) {
      breweryModelList?.addAll(_breweryModelList);
      if (!isFirstLoad) {
        loadMoreData = !loadMoreData;
      }
    }
    setState(() {});
  }

  void _scrollListener() async {
    if (!loadMoreData) {
      if (controller.position.extentAfter < 500) {
        loadMoreData = true;
        page++;
        await _fetchScreenData(isFirstLoad: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBarWidget(context),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView.separated(
                itemCount: breweryModelList!.length,
                controller: controller,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  BreweryModel item = breweryModelList![index];
                  return _getBreweryListItemsWidget(context, item);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8);
                },
              ),
      ),
    );
  }

  Widget _getBreweryListItemsWidget(BuildContext context, BreweryModel item) {
    bool isFavorite = favoriteBreweryList?.any((element) => element.id == item.id) ?? false;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BreweryDetailsScreen(item: item)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      item.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Type: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.type ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'City: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.city ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (await BreweryDatabase.instance.createOrDelete(item, isFavorite)) {
                    isFavorite ? favoriteBreweryList?.removeWhere((element) => element.id == item.id) : favoriteBreweryList?.add(item);
                    setState(() {});
                  }
                },
                child: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 32,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _getAppBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffFFBB00),
      title: const Text('Brewery List'),
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteBreweryScreen(
                  items: favoriteBreweryList ?? [],
                  onCallBack: (String id) {
                    favoriteBreweryList?.removeWhere((element) => element.id == id);
                    setState(() {});
                  },
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Center(
              child: Text(
                'Fav List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  hideLoading() {
    isLoading = false;
    setState(() {});
  }

  showLoading() {
    isLoading = true;
    setState(() {});
  }
}

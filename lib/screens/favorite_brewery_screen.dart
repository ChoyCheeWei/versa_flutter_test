import 'package:flutter/material.dart';
import 'package:versa_flutter_test/database/database.dart';
import 'package:versa_flutter_test/models/brewery_model.dart';

import 'brewery_details_screen.dart';

class FavoriteBreweryScreen extends StatefulWidget {
  final List<BreweryModel> items;
  final Function(String index) onCallBack;

  const FavoriteBreweryScreen({
    Key? key,
    required this.items,
    required this.onCallBack,
  }) : super(key: key);

  @override
  _FavoriteBreweryScreenState createState() => _FavoriteBreweryScreenState();
}

class _FavoriteBreweryScreenState extends State<FavoriteBreweryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFBB00),
        title: const Text('Favorite List'),
      ),
      body: widget.items.isEmpty
          ? const Center(
              child: Text(
                'no items',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.separated(
            itemCount: widget.items.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              BreweryModel item = widget.items[index];
              return _getBreweryListItemsWidget(context, item);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
          ),
    );
  }

  Widget _getBreweryListItemsWidget(BuildContext context, BreweryModel item) {
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
                  if (await BreweryDatabase.instance.createOrDelete(item, true)) {
                    widget.items.removeWhere((element) => element.id == item.id);
                    widget.onCallBack.call(item.id!);
                  }
                  setState(() {});
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 32,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

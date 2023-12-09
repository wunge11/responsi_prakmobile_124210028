import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_prakmobile_124210028/detail_meal.dart';
import 'models/detail_model.dart';
import 'network/data_source.dart';

class Meal extends StatefulWidget {
  final category;
  const Meal({Key? key, required this.category}) : super(key: key);

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  late TextEditingController _searchController;
  late List<Meals> charactersList;
  late List<Meals> searchResult;
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    charactersList = [];
    searchResult = [];
    _data = ApiDataSource.instance.loadMeal(widget.category);
  }


  void filterCharacters(String query) {
    List<Meals> result = charactersList
        .where((character) =>
    character.strMeal!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meals',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterCharacters(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Meals...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child:
            FutureBuilder<Map<String, dynamic>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!['meals'];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: ()  {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMeal(
                                id: data[index]['idMeal'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(8.0),
                          color: Colors.brown[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    data[index]['strMealThumb'],
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data[index]['strMeal'] ?? 'Unknown',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

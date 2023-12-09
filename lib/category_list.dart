import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_prakmobile_124210028/models/category_model.dart';
import 'dart:convert';
import 'meal_list.dart';
import 'network/data_source.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late TextEditingController _searchController;
  late List<Categories> charactersList;
  late List<Categories> searchResult;
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    charactersList = [];
    searchResult = [];
    _data = ApiDataSource.instance.loadCategory();
  }

  void filterCharacters(String query) {
    List<Categories> result = charactersList
        .where((character) => character.strCategory!.toLowerCase().contains(query.toLowerCase()))
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
          'Category',
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
                hintText: 'Search Category...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!['categories'];
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Meal(
                                category: data[index]['strCategory'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.brown[100]),
                          child: Column(
                            children: [
                              Image.network(data[index]['strCategoryThumb']),
                              SizedBox(height: 10),
                              Text(
                                data[index]['strCategory'],
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(data[index]['strCategoryDescription'])
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

// class CharacterSearchDelegate extends SearchDelegate<Categories> {
//   final Future<Map<String, dynamic>> data;
//
//   CharacterSearchDelegate(this.data);
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         // Handle the back button press if needed
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//         future: data,
//         builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         List<Categories> charactersList =
//         (snapshot.data!['categories'] as List<dynamic>)
//             .map((json) => Categories.fromJson(json))
//             .toList();
//
//         List<Categories> result = charactersList
//             .where((character) =>
//             character.strCategory!.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//
//     return _buildSearchResults(result);
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Categories> result = charactersList
//         .where((character) => character.strCategory!.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//
//     return _buildSearchResults(result);
//   }
//
//   Widget _buildSearchResults(List<Categories> results) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         Categories character = results[index];
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Meal(category: data[index]['strCategory']),
//               ),
//             );
//           },
//           child: Card(
//             elevation: 5.0,
//             margin: EdgeInsets.all(8.0),
//             color: Colors.blueGrey[100],
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: character.strCategoryThumb != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.network(
//                       character.strCategoryThumb!,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                       : Container(),
//                 ),
//                 SizedBox(height: 8.0),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     character.strCategory ?? 'Unknown',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'network/data_source.dart';

class DetailMeal extends StatefulWidget {
  final id;
  const DetailMeal({Key? key, required this.id}) : super(key: key);

  @override
  _DetailMealState createState() => _DetailMealState();
}

class _DetailMealState extends State<DetailMeal> {
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _data = ApiDataSource.instance.loadDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!['meals'][0];
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  data['strMeal'],
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.brown[300]),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildMealImage(data['strMealThumb']),
                  SizedBox(height: 10),
                  _buildMealTitle(data['strMeal']),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Category : " + data['strCategory']),
                      SizedBox(width: 75),
                      Text("Area : " + data['strArea']),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Ingredients",
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      if (data['strIngredient' + (index + 1).toString()] !=
                          "") {
                        return Row(
                          children: [
                            Text(
                              data['strIngredient' + (index + 1).toString()] +
                                  " : ",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              data['strMeasure' + (index + 1).toString()],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  // Instructions
                  Text(
                    "Instructions",
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['strInstructions'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  // Launch Url
              FloatingActionButton.extended(
                onPressed: () {
                  _launchURL(data['strYoutube'] ?? '');
                },
                icon: Icon(Icons.play_arrow_outlined),
                //backgroundColor: Colors.amber,
                label: Text(
                  "Watch Tutorial",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMealImage(String? imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUrl != null
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
        )
            : Placeholder(), // Placeholder jika imageUrl null
      ),
    );
  }

  Widget _buildMealTitle(String? title) {
    return Text(
      title ?? '',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

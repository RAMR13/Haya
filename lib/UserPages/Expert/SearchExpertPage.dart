import 'package:flutter/material.dart';
import 'package:hayaproject/UserPages/Expert/ExpertViewPage.dart';
import 'package:page_transition/page_transition.dart';

class MySearchDelgate extends SearchDelegate {
  List<String> searchResult = [
    'Barraa Mehdawi',
    'Malik Mansour',
    'John Doe',
    'Jane Smith',
    'Alex Johnson',
    'Sarah Lee',
    'Michael Brown',
    'Emily Wilson',
    'David Clark',
    'Olivia Turner',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null); //close the search bar
        } else {
          query = "";
        }
      },
    );
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
    return null;
  }

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> Suggestions = searchResult.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: Suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = Suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2C2C2C),
            size: 30,
          ),
          onPressed: () {
            /////// CHANGE IT
            Navigator.pop(context); // This will navigate back to the last page
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: width * 0.9,
              height: height * 0.8,
              color: Colors.white,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: height * 0.03, left: 4),
                      width: width * 0.8,
                      child: Text(
                        "Select the type of expert you need",
                        style: TextStyle(
                          color: Color(0xFF2C2C2C),
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: TrainerPage(),
                              type: PageTransitionType.rightToLeftWithFade));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 4,
                            offset: Offset(
                                0, 2), // Shadow position (from left, bottom)
                          ),
                        ],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            child: Image.asset(
                              "Images/Trainer.png",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: NutritionistPage(),
                              type: PageTransitionType.rightToLeftWithFade));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 4,
                            offset: Offset(
                                0, 2), // Shadow position (from left, bottom)
                          ),
                        ],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            child: Image.asset(
                              "Images/Nutritionist.png",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

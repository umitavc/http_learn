import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final url = Uri.parse("https://reqres.in/api/users?page=2");
  int? counter;
  var personalResult;

  Future callPerson() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var result = personalFromJson(response.body);
        if (mounted) {
          setState(() {
            counter = result.data.length;
            personalResult = result;
          });
          return result;
        }
      } else {
        // ignore: avoid_print
        print(response.statusCode);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    callPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Listesi"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: counter != null
                ? ListView.builder(
                    itemCount: counter,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(personalResult.data[index].firstName + ' ' + personalResult.data[index].lastName),
                        subtitle: Text(personalResult.data[index].email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(personalResult.data[index].avatar),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator())),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          callPerson();
        },
      ),
    );
  }
}

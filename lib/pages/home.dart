import 'package:flutter/material.dart';

import 'package:guillama/shared/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? models;

  @override
  void initState() {
    super.initState();
    API.listModels().then((value) {
      setState(() {
        models = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GUILlama'),
      ),
      body: models == null
          ? const Center(child: CircularProgressIndicator())
          : _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          models = null;
        });
        API.listModels().then((value) {
          setState(() {
            models = value;
          });
        });
      },
      child: ListView.builder(
        itemCount: models!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(models![index]),
          );
        },
      ),
    );
  }
}

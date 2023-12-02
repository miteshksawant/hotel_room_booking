import 'package:flutter/material.dart';

class DisplayStoreData extends StatefulWidget {
  final List<String> data;
  const DisplayStoreData({Key? key,required this.data}) : super(key: key);

  @override
  State<DisplayStoreData> createState() => _DisplayStoreDataState();
}

class _DisplayStoreDataState extends State<DisplayStoreData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Data'),
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Room ${index + 1}'),
            subtitle: Text(widget.data[index]),
          );
        },
      ),
    );
  }
}

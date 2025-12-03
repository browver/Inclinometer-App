import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class Datapage extends StatefulWidget {
  Datapage({super.key});

  @override
  State<Datapage> createState() => _DatapageState();
}

class _DatapageState extends State<Datapage> {
  var box = Hive.box("inclinometer_data");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Page"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,),
      body: ListView.builder(
        itemCount: box.keys.length,
        itemBuilder: (context, index) {
          String key = box.keys.elementAt(index);
          return ListTile(
            title: Text(key),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text("Delete Data"),
                      content: Text("Are you sure want to delete this?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          }, 
                          child: Text("Cancel")),

                        TextButton(
                          onPressed: () {
                            box.delete(key);
                            Navigator.of(dialogContext).pop();
                            setState(() {});
                          }, 
                          child: Text("Yes")),
                      ],
                    );
                  });
              }, 
              icon: Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}

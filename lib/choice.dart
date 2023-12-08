import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TagSelectionScreen extends StatefulWidget {
  @override
  _TagSelectionScreenState createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  final TextEditingController _tagController = TextEditingController();
  List<String> selectedTags = [];

  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveTags() {
    // Store selectedTags in Firebase Firestore
    _firestore.collection('tags').add({'tags': selectedTags});
  }

 int tag = 3;

  // multiple choice value
  List<String> tags = ['Education'];

  // list of string options
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Selection'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTags,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
         Container(
          height: 200,
width: 500,                   
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceCheckmark: true,
                      choiceStyle: C2ChipStyle.outlined(),
                    ),
                  ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _tagController,
          //     decoration: InputDecoration(labelText: 'Add Tag'),
          //     onSubmitted: (tag) {
          //       setState(() {
          //         if (tag.isNotEmpty) {
          //           selectedTags.add(tag);
          //           _tagController.clear();
          //         }
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

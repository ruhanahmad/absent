import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class TaskList extends StatelessWidget {
  Stream<List<Map<String, dynamic>>> getTasksByDate() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('InitialTime', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      Map<DateTime, List<Map<String, dynamic>>> groupedTasks = {};

      snapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> task = document.data() as Map<String, dynamic>;

        // Extract date without time
        DateTime date = DateTime(
          task['InitialTime'].toDate().year,
          task['InitialTime'].toDate().month,
          task['InitialTime'].toDate().day,
         
        ).toLocal();

        // Group tasks by date
        if (groupedTasks.containsKey(date)) {
          groupedTasks[date]!.add(task);
        } else {
          groupedTasks[date] = [task];
        }
      });

      // Convert the map to a list
      List<Map<String, dynamic>> result = [];
      groupedTasks.forEach((date, tasks) {
        result.add({'date': date, 'tasks': tasks});
      });

      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getTasksByDate(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> taskData = snapshot.data![index];
            DateTime date = taskData['date'] as DateTime;
            List<Map<String, dynamic>> tasks = taskData['tasks'] as List<Map<String, dynamic>>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display date as heading
                Text(
                  '${date.year}-${date.month}-${date.day}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Display tasks for that date
                for (var task in tasks)
                  ListTile(
                    title: Text(task['task'].toString()), // Replace with your actual field name
                    subtitle: Text(task['deadLine'].toString()), // Replace with your actual field name
                    trailing: Text(task["user"].toString()),
                  ),
                Divider(), // Add a divider between each date
              ],
            );
          },
        );
      },
    );
  }
}

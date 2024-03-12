import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DateTime selectedDay;

  @override
  void initState() {
    final now = DateTime.now();
    selectedDay = DateTime(
      now.year,
      now.month,
      now.day,
    );
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(color: Color.fromARGB(255, 225, 152, 152)),
        ),
        backgroundColor: Color.fromARGB(255, 38, 29, 63),
      ),
      backgroundColor: Color.fromARGB(255, 38, 29, 63),
      body: SubjectsGrid(controller: _controller),
    );
  }
}

class SubjectsGrid extends StatelessWidget {
  final Future<List<Subject>> _subjectListFuture =
      TasksService.getSubjectList();
  final AnimationController controller;

  SubjectsGrid({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _subjectListFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Subject> subjectList = snapshot.data!;
            return ListView.builder(
              itemCount: subjectList.length,
              itemBuilder: (context, index) =>
                  _buildSubject(context, subjectList[index]),
            );
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.none:
            return Center(
              child: Text("Error: Could not get subjects from storage"),
            );
        }
      },
    );
  }

  Widget _buildSubject(BuildContext context, Subject subject) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: subject.color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        color: subject.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(controller),
              child: Image.asset(
                subject.iconAssetPath,
                width: 5,
                height: 5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subject.name,
              style: const TextStyle(
                fontSize: 7,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 16, 42),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                _buildTaskStatus(
                  subject.color.withOpacity(1.0),
                  '${subject.numTasksLeft} left',
                  Color.fromARGB(255, 31, 42, 76),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatus(
    Color bgColor,
    String text,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

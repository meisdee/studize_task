import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studize_interview/widgets/date_picker.dart';

import 'package:studize_interview/widgets/task_timeline.dart';
import 'package:studize_interview/widgets/task_title.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_service.dart';

class SinglePageScreen extends StatefulWidget {
  const SinglePageScreen({Key? key}) : super(key: key);

  @override
  _SinglePageScreenState createState() => _SinglePageScreenState();
}

class _SinglePageScreenState extends State<SinglePageScreen>
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 17, 35, 90),
      ),
      backgroundColor: Color.fromARGB(255, 17, 35, 90),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePicker(
              callback: (selectedDay) =>
                  setState(() => this.selectedDay = selectedDay),
            ),
            TaskTitle(),
            SizedBox(height: 20),
            _buildSinglePage(),
            HomePage(controller: _controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSinglePage() {
    return FutureBuilder(
      future: TasksService.getAllTasks(),
      builder: (context, snapshot) {
        final List<Task> taskList = snapshot.data!;
        return CustomScrollView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => TaskTimeline(
                  task: taskList[index],
                  subjectColor: taskList[index].color,
                  isFirst: index == 0,
                  isLast: index == taskList.length - 1,
                  refreshCallback: () {
                    setState(() {});
                  },
                ),
                childCount: taskList.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final AnimationController controller;

  const HomePage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TasksService.getSubjectList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          final List<Subject> subjectList = snapshot.data as List<Subject>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 24,
                              color: Color.fromARGB(255, 246, 236, 169),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'New Task',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 246, 236, 169)),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 89, 111, 183),
                          padding: EdgeInsets.symmetric(
                              vertical: 17, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: const Text(
                  'SUBJECTS:',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 246, 236, 169),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildSubjectList(context, subjectList),
            ],
          );
        } else {
          return Center(
            child: Text("No data available"),
          );
        }
      },
    );
  }

  Widget _buildSubjectList(BuildContext context, List<Subject> subjectList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subjectList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {},
        child: Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 11,
          shadowColor: Color.fromARGB(255, 63, 29, 56),
          color: subjectList[index].color,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(controller),
                  child: Image.asset(
                    subjectList[index].iconAssetPath,
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 40), // Add some space between the icon and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectList[index].name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 57, 54, 54),
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildTaskStatus(
                      subjectList[index].color.withOpacity(1.0),
                      '${subjectList[index].numTasksLeft} left',
                      Colors.black38,
                    ),
                  ],
                ),
              ],
            ),
          ),
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

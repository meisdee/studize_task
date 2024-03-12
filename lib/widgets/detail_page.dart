import 'package:flutter/material.dart';
import 'package:studize_interview/widgets/date_picker.dart';
import 'package:studize_interview/widgets/task_timeline.dart';
import 'package:studize_interview/widgets/task_title.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TasksService.getAllTasks(),
      builder: (context, snapshot) {
        final List<Task> taskList = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Tasks',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 38, 29, 63),
          ),
          backgroundColor: Color.fromARGB(255, 38, 29, 63),
          floatingActionButton: const FloatingActionButton.extended(
            onPressed: null,
            label: Text('New Task', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 75, 67, 97),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DatePicker(
                        callback: (selectedDay) =>
                            setState(() => this.selectedDay = selectedDay),
                      ),
                      TaskTitle(),
                    ],
                  ),
                ),
              ),
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
          ),
        );
      },
    );
  }
}

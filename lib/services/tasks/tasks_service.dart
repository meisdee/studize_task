import 'package:flutter/material.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_exceptions.dart';

class TasksService {
  static Future<List<String>> getSubjectNameList() async {
    return ['Physics', 'Chemistry', 'Mathematics'];
  }

  static Future<List<Subject>> getSubjectList() async {
    return <Subject>[
      Subject(
          name: 'Physics',
          color: Color.fromARGB(255, 198, 207, 115),
          iconAssetPath: 'assets/icons/physics.png'),
      Subject(
          name: 'Chemistry',
          color: Color.fromARGB(255, 254, 199, 180),
          iconAssetPath: 'assets/icons/chemistry.png'),
      Subject(
          name: 'Mathematics',
          color: Color.fromARGB(255, 152, 187, 225),
          iconAssetPath: 'assets/icons/maths.png'),
    ];
  }

  static Future<List<Task>> getAllTasks() async {
    final DateTime now = DateTime.now();
    List<Task> taskList = <Task>[
      Task(
        id: 0,
        title: 'Mathematics',
        description: 'Complex Numbers Quiz',
        timeStart: now.add(const Duration(hours: 1)),
        timeEnd: now.add(const Duration(hours: 2)),
        color: Color.fromARGB(255, 152, 187, 225),
      ),
      Task(
        id: 1,
        title: 'Physics',
        description: 'Projectile Motion Revision',
        timeStart: now.add(const Duration(hours: 6)),
        timeEnd: now.add(const Duration(hours: 8)),
        color: Color.fromARGB(255, 198, 207, 115),
      ),
      Task(
        id: 2,
        title: 'Chemistry',
        description: 'Isomerism - Prepare Notes',
        timeStart: now.add(const Duration(hours: 16)),
        timeEnd: now.add(const Duration(hours: 18)),
        color: Color.fromARGB(255, 254, 199, 180),
      ),
    ];
    return taskList;
  }

  /// Returns task object that corresponds to the specified [taskId] inside the
  /// specified [subjectName].
  ///
  /// Throws exception `TaskNotFoundException` if specified `taskId` is not found
  /// and `SubjectNotFoundException` if specified `subjectName` is not found.
  static Future<Task> getTask({required int taskId}) async {
    List<Task> taskList = await getAllTasks();
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].id == taskId) {
        return taskList[i];
      }
    }

    // If the loop completes without finding the specified id, then throw
    // exception
    throw TaskNotFoundException();
  }
}

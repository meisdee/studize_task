import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  const TaskTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tasks for today:',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 246, 236, 169),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 70, 37, 120).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'Timeline',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Color.fromARGB(255, 246, 236, 199),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

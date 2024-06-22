import 'package:app/domain/models/task.dart';

final tasks = [
  Task(
    text: 'Купить что-то',
    priority: Priority.low,
    deadline: null,
    isDone: false,
  ),
  Task(
    text: 'Купить что-то, где-то, зачем-то, но зачем не очень понятно',
    priority: Priority.low,
    deadline: null,
    isDone: true,
  ),
  Task(
    text:
        'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст в этом поле',
    priority: Priority.high,
    deadline: DateTime(2024, 07, 30),
    isDone: false,
  ),
  Task(
    text: 'Купить что-то ещё',
    priority: Priority.no,
    deadline: DateTime(2024, 08, 21),
    isDone: false,
  ),
  Task(
    text: 'Купить что-то, где-то, зачем-то, но зачем не очень понятно',
    priority: Priority.no,
    deadline: null,
    isDone: false,
  ),
  Task(
    text:
        'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст в этом поле',
    priority: Priority.low,
    deadline: null,
    isDone: false,
  ),
  Task(
    text: 'Купить что-то не то',
    priority: Priority.no,
    deadline: null,
    isDone: true,
  ),
  Task(
    text:
        'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст в этом поле',
    priority: Priority.high,
    deadline: DateTime(2024, 09, 23),
    isDone: true,
  ),
  Task(
    text: 'Купить что-то, где-то, зачем-то, но зачем не очень понятно',
    priority: Priority.low,
    deadline: null,
    isDone: false,
  ),
  Task(
    text: 'Купить что-то ещё',
    priority: Priority.no,
    deadline: DateTime(2024, 10, 07),
    isDone: false,
  ),
  Task(
    text:
        'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст в этом поле',
    priority: Priority.low,
    deadline: DateTime(2024, 08, 18),
    isDone: false,
  ),
];

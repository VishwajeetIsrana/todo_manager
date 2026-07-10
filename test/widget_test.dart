import 'package:flutter_test/flutter_test.dart';
import 'package:todo_manager/models/todo_model.dart';

void main() {
  group('TodoModel', () {
    test('fromJson creates model correctly', () {
      final json = {
        'userId': 1,
        'id': 1,
        'title': 'test todo',
        'completed': false,
      };
      final todo = TodoModel.fromJson(json);
      expect(todo.userId, 1);
      expect(todo.id, 1);
      expect(todo.title, 'test todo');
      expect(todo.completed, false);
    });

    test('toJson produces correct map', () {
      final todo = TodoModel(
        userId: 1,
        id: 1,
        title: 'test',
        completed: true,
      );
      final json = todo.toJson();
      expect(json['userId'], 1);
      expect(json['title'], 'test');
      expect(json['completed'], true);
    });

    test('copyWith updates fields', () {
      final todo = TodoModel(
        userId: 1,
        id: 1,
        title: 'original',
        completed: false,
      );
      final updated = todo.copyWith(title: 'updated', completed: true);
      expect(updated.title, 'updated');
      expect(updated.completed, true);
      expect(updated.id, 1);
    });
  });
}

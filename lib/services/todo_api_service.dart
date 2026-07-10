import 'package:dio/dio.dart';
import '../models/todo_model.dart';
import '../core/constants/app_constants.dart';

class TodoApiService {
  final Dio _dio;

  TodoApiService(this._dio);

  Future<List<TodoModel>> fetchTodos() async {
    final response = await _dio.get('${AppConstants.baseUrl}/todos');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

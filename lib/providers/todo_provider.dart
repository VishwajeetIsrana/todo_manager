import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../services/todo_api_service.dart';
import '../core/utils/debouncer.dart';
import '../core/constants/app_constants.dart';

class TodoProvider extends ChangeNotifier {
  final TodoApiService _apiService;
  final Debouncer _debouncer = Debouncer(delay: AppConstants.searchDebounce);

  List<TodoModel> _allTodos = [];
  List<TodoModel> _filteredTodos = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';
  bool _showCompletedOnly = false;
  int _nextId = 100001;

  List<TodoModel> get todos => _filteredTodos;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get showCompletedOnly => _showCompletedOnly;

  TodoProvider(this._apiService);

  Future<void> fetchTodos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTodos = await _apiService.fetchTodos();
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load todos. Check your connection and try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchTodos(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    _debouncer.run(() {
      _applyFilters();
      notifyListeners();
    });
  }

  void toggleShowCompletedOnly() {
    _showCompletedOnly = !_showCompletedOnly;
    _applyFilters();
    notifyListeners();
  }

  void addTodo(String title) {
    final todo = TodoModel(
      userId: 1,
      id: _nextId++,
      title: title,
      completed: false,
    );
    _allTodos.insert(0, todo);
    _applyFilters();
    notifyListeners();
  }

  void editTodo(int id, String newTitle) {
    final index = _allTodos.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _allTodos[index] = _allTodos[index].copyWith(title: newTitle);
    _applyFilters();
    notifyListeners();
  }

  void deleteTodo(int id) {
    _allTodos.removeWhere((t) => t.id == id);
    _applyFilters();
    notifyListeners();
  }

  void toggleTodo(int id) {
    final index = _allTodos.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _allTodos[index] = _allTodos[index].copyWith(
      completed: !_allTodos[index].completed,
    );
    _applyFilters();
    notifyListeners();
  }

  Future<void> refreshTodos() async {
    await fetchTodos();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<TodoModel>.from(_allTodos);

    if (_showCompletedOnly) {
      result = result.where((t) => t.completed).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((t) => t.title.toLowerCase().contains(query))
          .toList();
    }

    _filteredTodos = result;
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

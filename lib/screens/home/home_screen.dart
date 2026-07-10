import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/local_storage_service.dart';
import '../../providers/theme_provider.dart';
import '../../providers/todo_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_retry_widget.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().fetchTodos();
    });
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isSearchFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _logout() async {
    final storage = context.read<LocalStorageService>();
    await storage.clearLogin();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _onSearchChanged(String value) {
    context.read<TodoProvider>().searchTodos(value);
  }

  Future<bool> _onWillPop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final greeting = _getGreeting();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) navigator.pop();
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildAppBar(theme, isDark, greeting),
            _buildSearchBar(theme, isDark),
            _buildFilterChips(),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading && provider.todos.isEmpty) {
                    return const ShimmerLoading();
                  }
                  if (provider.errorMessage != null &&
                      provider.todos.isEmpty) {
                    return ErrorRetryWidget(
                      message: provider.errorMessage!,
                      onRetry: provider.fetchTodos,
                    );
                  }
                  if (provider.todos.isEmpty) {
                    return const EmptyStateWidget();
                  }
                  return RefreshIndicator(
                    onRefresh: provider.refreshTodos,
                    displacement: 20,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.todos.length,
                      itemBuilder: (_, i) =>
                          TodoCard(todo: provider.todos[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'addTodo',
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result =
                await Navigator.pushNamed(context, AppRoutes.addEdit);
            if (result == true && mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Task added successfully',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isDark, String greeting) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 24,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primary.withValues(alpha: 0.15), AppColors.secondary.withValues(alpha: 0.05)]
              : [AppColors.primary.withValues(alpha: 0.06), AppColors.secondary.withValues(alpha: 0.03)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting 👋',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (_, tp, __) => IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  tp.themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(tp.themeMode),
                ),
              ),
              onPressed: tp.toggleTheme,
              tooltip: 'Toggle theme',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: _isSearchFocused ? AppShadows.card : AppShadows.soft,
          border: Border.all(
            color: _isSearchFocused
                ? AppColors.primary.withValues(alpha: 0.3)
                : (isDark ? AppColors.borderDark : AppColors.borderLight)
                    .withValues(alpha: 0.5),
            width: _isSearchFocused ? 1.5 : 1,
          ),
        ),
        child: TextField(
          controller: _searchCtrl,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: GoogleFonts.plusJakartaSans(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            prefixIcon: const Icon(Icons.search_rounded, size: 22),
            suffixIcon: Consumer<TodoProvider>(
              builder: (_, p, __) {
                if (p.searchQuery.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    p.clearSearch();
                    _focusNode.unfocus();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(Icons.close_rounded, size: 20),
                  ),
                );
              },
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<TodoProvider>(
      builder: (_, provider, __) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final filterType =
            provider.showCompletedOnly ? _FilterType.completed : _FilterType.all;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                selected: filterType == _FilterType.all,
                count: provider.todos.length + (provider.showCompletedOnly ? 0 : 0),
                isDark: isDark,
                onTap: () {
                  if (provider.showCompletedOnly) {
                    provider.toggleShowCompletedOnly();
                  }
                },
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'Completed',
                selected: filterType == _FilterType.completed,
                count: provider.todos.where((t) => t.completed).length,
                isDark: isDark,
                onTap: () {
                  if (!provider.showCompletedOnly) {
                    provider.toggleShowCompletedOnly();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _FilterType { all, completed }

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.count,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          boxShadow: selected ? AppShadows.soft : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

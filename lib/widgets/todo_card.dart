import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../routes/app_routes.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.read<TodoProvider>();

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        provider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Task deleted', AppColors.error),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.error.withValues(alpha: 0.8), AppColors.error],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.card,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            onTap: () => provider.toggleTodo(todo.id),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
              child: Row(
                children: [
                  _AnimatedCheckbox(
                    value: todo.completed,
                    onChanged: (_) {
                      provider.toggleTodo(todo.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildSnackBar(
                          todo.completed
                              ? 'Task marked incomplete'
                              : 'Task completed',
                          AppColors.success,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: todo.completed
                                ? AppColors.textSecondary
                                : (isDark ? Colors.white : AppColors.textPrimary),
                          ),
                          child: Text(
                            todo.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: todo.completed
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            todo.completed ? 'Completed' : 'Pending',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: todo.completed
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _IconButton(
                    icon: Icons.edit_outlined,
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.addEdit,
                        arguments: todo,
                      );
                    },
                  ),
                  _IconButton(
                    icon: Icons.delete_outline,
                    onPressed: () async {
                      final confirmed = await _confirmDelete(context);
                      if (confirmed == true && context.mounted) {
                        provider.deleteTodo(todo.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSnackBar('Task deleted', AppColors.error),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(
      content: Row(
        children: [
          Icon(
            color == AppColors.error
                ? Icons.delete_outline_rounded
                : Icons.check_circle_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Delete Task',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: GoogleFonts.plusJakartaSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AnimatedCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: value ? AppColors.primary : AppColors.borderLight,
            width: 2,
          ),
        ),
        child: value
            ? const Center(
                child: Icon(Icons.check_rounded, color: Colors.white, size: 18),
              )
            : null,
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(36, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}

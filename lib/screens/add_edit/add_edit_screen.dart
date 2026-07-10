import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/todo_model.dart';
import '../../providers/todo_provider.dart';

class AddEditScreen extends StatefulWidget {
  final TodoModel? todo;

  const AddEditScreen({super.key, this.todo});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  bool get _isEditing => widget.todo != null;

  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.todo?.title ?? '');
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<TodoProvider>();
    final title = _titleCtrl.text.trim();
    if (_isEditing) {
      provider.editTodo(widget.todo!.id, title);
    } else {
      provider.addTodo(title);
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = _isEditing ? 'Edit Task' : 'New Task';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkBackground]
                : [AppColors.background, Colors.white],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animCtrl,
                curve: Curves.easeOutCubic,
              )),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.surfaceDark
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'addEditForm',
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleCtrl,
                              autofocus: true,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 5,
                              minLines: 3,
                              style: GoogleFonts.plusJakartaSans(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: 'Task title',
                                hintText: 'What needs to be done?',
                                alignLabelWithHint: true,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Consumer<TodoProvider>(
                                builder: (_, p, __) {
                                  return Text(
                                    '${_titleCtrl.text.length}/500',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: _titleCtrl.text.length > 450
                                          ? AppColors.error
                                          : AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _save,
                                icon: Icon(
                                  _isEditing
                                      ? Icons.save_rounded
                                      : Icons.add_rounded,
                                ),
                                label: Text(_isEditing ? 'Update Task' : 'Add Task'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

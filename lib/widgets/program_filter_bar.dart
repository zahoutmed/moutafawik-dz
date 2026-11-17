import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/curriculum_repository.dart';
import 'package:i_love_philosophy/models/education_models.dart';

/// شريط تصفية واختيار الطور والمادة لتمكين التنقل السلس في الدروس والاختبارات والمكتبة والفيديوهات
class ProgramFilterBar extends StatelessWidget {
  final SubjectProgram selectedProgram;
  final ValueChanged<SubjectProgram> onProgramChanged;

  const ProgramFilterBar({
    super.key,
    required this.selectedProgram,
    required this.onProgramChanged,
  });

  @override
  Widget build(BuildContext context) {
    final stages = CurriculumRepository.stages.where((s) => s != 'الكل').toList();
    final stagePrograms = CurriculumRepository.programsForStage(selectedProgram.stage);
    final effectiveStagePrograms =
        stagePrograms.isNotEmpty ? stagePrograms : CurriculumRepository.allPrograms;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(235),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: stages.map((stage) {
                final isSelected = selectedProgram.stage == stage;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text(
                      stage,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (_) {
                      final progs = CurriculumRepository.programsForStage(stage);
                      if (progs.isNotEmpty) {
                        onProgramChanged(progs.first);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: effectiveStagePrograms.map((prog) {
                final isSelected = prog.title == selectedProgram.title &&
                    prog.stage == selectedProgram.stage;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    avatar: CircleAvatar(
                      backgroundColor: prog.color.withAlpha(35),
                      child: Image.asset(
                        prog.iconPath,
                        height: 18,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.book, size: 14, color: prog.color),
                      ),
                    ),
                    label: Text(
                      prog.title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: prog.color,
                    backgroundColor: Colors.grey.shade100,
                    onSelected: (_) => onProgramChanged(prog),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

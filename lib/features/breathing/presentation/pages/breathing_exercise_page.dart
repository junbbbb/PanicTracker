import 'package:flutter/material.dart';
import '../../../../shared/widgets/breathing_animation_widget.dart';

class BreathingExercisePage extends StatelessWidget {
  final String exerciseType;
  final String title;
  final String description;

  const BreathingExercisePage({
    super.key,
    required this.exerciseType,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BreathingAnimationWidget(
            exerciseType: exerciseType,
            showControls: true,
            initialTimeMinutes: 5,
          ),
        ),
      ),
    );
  }
}
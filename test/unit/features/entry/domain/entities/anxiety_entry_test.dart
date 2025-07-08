import 'package:flutter_test/flutter_test.dart';
import 'package:claudeapp/features/entry/domain/entities/anxiety_entry.dart';

void main() {
  group('AnxietyEntry', () {
    final testEntry = AnxietyEntry(
      id: '1',
      timestamp: DateTime(2023, 1, 1, 10, 0),
      trigger: 'Work presentation',
      symptoms: ['Rapid heartbeat', 'Sweating', 'Trembling'],
      negativeThoughts: 'I will embarrass myself',
      copingStrategy: 'Deep breathing exercises',
      durationInMinutes: 30,
    );

    test('should create an instance with all required properties', () {
      expect(testEntry.id, '1');
      expect(testEntry.timestamp, DateTime(2023, 1, 1, 10, 0));
      expect(testEntry.trigger, 'Work presentation');
      expect(testEntry.symptoms, ['Rapid heartbeat', 'Sweating', 'Trembling']);
      expect(testEntry.negativeThoughts, 'I will embarrass myself');
      expect(testEntry.copingStrategy, 'Deep breathing exercises');
      expect(testEntry.durationInMinutes, 30);
    });

    test('should be equal when all properties are the same', () {
      final entry1 = AnxietyEntry(
        id: '1',
        timestamp: DateTime(2023, 1, 1, 10, 0),
        trigger: 'Work presentation',
        symptoms: ['Rapid heartbeat', 'Sweating'],
        negativeThoughts: 'I will embarrass myself',
        copingStrategy: 'Deep breathing exercises',
        durationInMinutes: 30,
      );

      final entry2 = AnxietyEntry(
        id: '1',
        timestamp: DateTime(2023, 1, 1, 10, 0),
        trigger: 'Work presentation',
        symptoms: ['Rapid heartbeat', 'Sweating'],
        negativeThoughts: 'I will embarrass myself',
        copingStrategy: 'Deep breathing exercises',
        durationInMinutes: 30,
      );

      expect(entry1, equals(entry2));
    });

    test('should not be equal when properties are different', () {
      final entry1 = AnxietyEntry(
        id: '1',
        timestamp: DateTime(2023, 1, 1, 10, 0),
        trigger: 'Work presentation',
        symptoms: ['Rapid heartbeat'],
        negativeThoughts: 'I will embarrass myself',
        copingStrategy: 'Deep breathing exercises',
        durationInMinutes: 30,
      );

      final entry2 = AnxietyEntry(
        id: '2',
        timestamp: DateTime(2023, 1, 1, 10, 0),
        trigger: 'Work presentation',
        symptoms: ['Rapid heartbeat'],
        negativeThoughts: 'I will embarrass myself',
        copingStrategy: 'Deep breathing exercises',
        durationInMinutes: 30,
      );

      expect(entry1, isNot(equals(entry2)));
    });

    test('should create a copy with updated properties', () {
      final updatedEntry = testEntry.copyWith(
        trigger: 'Public speaking',
        durationInMinutes: 45,
      );

      expect(updatedEntry.id, testEntry.id);
      expect(updatedEntry.timestamp, testEntry.timestamp);
      expect(updatedEntry.trigger, 'Public speaking');
      expect(updatedEntry.symptoms, testEntry.symptoms);
      expect(updatedEntry.negativeThoughts, testEntry.negativeThoughts);
      expect(updatedEntry.copingStrategy, testEntry.copingStrategy);
      expect(updatedEntry.durationInMinutes, 45);
    });

    test('should create a copy with no changes when no parameters are provided', () {
      final copiedEntry = testEntry.copyWith();

      expect(copiedEntry, equals(testEntry));
    });

    test('should allow null id for new entries', () {
      final newEntry = AnxietyEntry(
        timestamp: DateTime(2023, 1, 1, 10, 0),
        trigger: 'Work presentation',
        symptoms: ['Rapid heartbeat'],
        negativeThoughts: 'I will embarrass myself',
        copingStrategy: 'Deep breathing exercises',
        durationInMinutes: 30,
      );

      expect(newEntry.id, isNull);
    });
  });
}
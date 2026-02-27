import 'parsi_date.dart';

/// Represents a range between two [ParsiDate]s.
class ParsiDateRange {
  const ParsiDateRange({required this.start, required this.end});

  final ParsiDate start;
  final ParsiDate end;

  /// Duration in days (inclusive).
  int get duration => end.difference(start).abs() + 1;

  bool contains(ParsiDate date) => date >= start && date <= end;

  @override
  bool operator ==(Object other) =>
      other is ParsiDateRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start — $end';
}

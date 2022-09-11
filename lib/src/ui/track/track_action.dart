import 'package:bebe/src/data/events/event.dart';
import 'package:equatable/equatable.dart';

class TrackAction extends Equatable {
  final EventType type;
  final Event? latestEvent;

  const TrackAction({
    required this.type,
    required this.latestEvent,
  });

  @override
  List<Object?> get props => [type, latestEvent];
}

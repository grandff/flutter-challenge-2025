import '../models/event_model.dart';

class EventRepo {
  // Mock data for the UI clone
  List<EventModel> getEvents() {
    return [
      EventModel(
        id: "1",
        title: "DESIGN\nMEETING",
        startHour: 11,
        startMinute: 30,
        endHour: 12,
        endMinute: 20,
        participants: ["ALEX", "HELENA", "NANA"],
        color: "yellow",
      ),
      EventModel(
        id: "2",
        title: "DAILY\nPROJECT",
        startHour: 12,
        startMinute: 35,
        endHour: 14,
        endMinute: 10,
        participants: ["ME", "RICHARD", "CIRY", "+4"],
        color: "purple",
      ),
      EventModel(
        id: "3",
        title: "WEEKLY\nPLANNING",
        startHour: 15,
        startMinute: 0,
        endHour: 16,
        endMinute: 30,
        participants: ["DEN", "NANA", "MARK"],
        color: "green",
      ),
    ];
  }

  List<String> getDates() {
    return ["TODAY", "17", "18", "19", "20"];
  }
}

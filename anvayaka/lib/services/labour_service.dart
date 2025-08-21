import '../models/labour.dart';

class LabourService {
  static final List<Labour> _labours = [
    Labour(
      id: 'f7aba074-6e65-4eb7-95d2-ff172555caf1',
      name: 'Shlok Sharma',
      age: 27,
      expertise: 'Machine Operation',
    ),
    Labour(
      id: '8dd8e2dc-48c5-4471-b390-a95eb86d87b6',
      name: 'Ramesh Kumar',
      age: 45,
      expertise: 'Machine Operation',
    ),
    Labour(
      id: '32e75dde-e8b4-4549-8f2c-d29c531e8500',
      name: 'shyam prakash',
      age: 43,
      expertise: 'shoe making',
    ),
    Labour(
      id: '091a5aad-0956-4d03-b90c-812f9619b81d',
      name: 'ram prakash',
      age: 34,
      expertise: 'shoe making',
    ),
  ];

  static List<Labour> getAllLabours() {
    return _labours;
  }

  static Labour? getLabourById(String id) {
    try {
      return _labours.firstWhere((labour) => labour.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Labour> getLaboursByExpertise(String expertise) {
    return _labours.where((labour) => 
      labour.expertise.toLowerCase().contains(expertise.toLowerCase())
    ).toList();
  }

  static List<String> getLabourNames() {
    return _labours.map((labour) => '${labour.name} (${labour.expertise})').toList();
  }

  static List<String> getLabourIds() {
    return _labours.map((labour) => labour.id).toList();
  }
}



import '../models/labour.dart';

class LabourService {
  static final List<Labour> _labours = [
    Labour(
      id: 'f7aba074-6e65-4eb7-95d2-ff172555caf1',
      name: 'Shlok Sharma',
      age: 27,
      expertise: 'Loom Operation',
    ),
    Labour(
      id: '99d41232-cc37-476b-9512-ac1f2f12c451',
      name: 'Vijay Verma',
      age: 36,
      expertise: 'Dyeing and Finishing',
    ),
    Labour(
      id: '8dd8e2dc-48c5-4471-b390-a95eb86d87b6',
      name: 'Ramesh Kumar',
      age: 45,
      expertise: 'Loom Operation',
    ),
    Labour(
      id: '8d84c9cf-e5fd-4987-82ed-d5ebcda2b52d',
      name: 'Mohan Lal',
      age: 36,
      expertise: 'Garment Construction and Tailoring',
    ),
    Labour(
      id: '3ec8fb5a-9ca0-425f-9e6a-4311a33d297d',
      name: 'Monu Yadav',
      age: 29,
      expertise: 'Quality Control and Maintenance',
    ),
    Labour(
      id: '32e75dde-e8b4-4549-8f2c-d29c531e8500',
      name: 'Shyam Prakash',
      age: 43,
      expertise: 'Fabric and Weaving Operation',
    ),
    Labour(
      id: '223fc248-44b8-47ce-8e66-40fb12ffd179',
      name: 'Dhanush Singh',
      age: 37,
      expertise: 'Garment Construction and Tailoring',
    ),
    Labour(
      id: '18597029-46f6-4c7c-b3ad-63838a3ab7c3',
      name: 'Sonu Raj',
      age: 32,
      expertise: 'Quality Control and Maintenance',
    ),
    Labour(
      id: '0a2677d3-2eb8-470a-8aac-f1baed1af8ca',
      name: 'Ajay Kant',
      age: 45,
      expertise: 'Dyeing and Finishing',
    ),
    Labour(
      id: '091a5aad-0956-4d03-b90c-812f9619b81d',
      name: 'Ram Prakash',
      age: 34,
      expertise: 'Fabric and Weaving Operation',
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

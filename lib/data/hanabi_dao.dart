import 'package:firebase_database/firebase_database.dart';
import 'Hanabi.dart';

class HanabiDao {
  final DatabaseReference _HanabiRef =
  FirebaseDatabase.instance.reference().child('Event').orderByChild('Date').reference();

  void saveMessage(Hanabi hanabi) {
    _HanabiRef.push().set(hanabi.toJson());
  }

  Query getMessageQuery() {
    return _HanabiRef;
  }
  
}
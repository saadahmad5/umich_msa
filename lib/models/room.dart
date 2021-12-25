import 'package:umich_msa/models/coordinates.dart';

class Room {
  late Coordinates coordinates;
  late String description;
  late String imageUrl;
  late bool mCard;
  late String name;
  late String room;

  Room() {
    coordinates = Coordinates();
  }
}

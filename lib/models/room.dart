import 'package:umich_msa/models/coordinates.dart';

class Room {
  late String roomId;
  late Coordinates coordinates;
  late String description;
  late String imageUrl;
  late bool mCard;
  late String name;
  late String room;
  late String address;
  late String whereAt;

  Room.noparams() {
    coordinates = Coordinates();
  }

  Room.params(this.roomId, this.address, this.coordinates, this.description,
      this.imageUrl, this.mCard, this.name, this.room, this.whereAt);
}

class MsaEvent {
  late String id;
  late String title;
  late String? description;
  late DateTime dateTime;
  late String? roomInfo;
  late String? address;
  late String? socialMediaLink;
  late String? meetingLink;

  MsaEvent.params(this.id, this.title, this.description, this.dateTime,
      this.roomInfo, this.address, this.socialMediaLink, this.meetingLink);

  MsaEvent.noparams();

  @override
  String toString() {
    return "$id ${title.toString()} at ${dateTime.toString()}";
  }
}

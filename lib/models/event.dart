class Event {
  late String title;
  late String description;
  late DateTime dateTime;
  late String? roomInfo;
  late String? address;
  late String? socialMediaLink;
  late String? meetingLink;

  Event.params(this.title, this.description, this.dateTime, this.roomInfo,
      this.address, this.socialMediaLink, this.meetingLink);

  Event.noparams();
}

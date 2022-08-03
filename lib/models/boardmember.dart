class BoardMember {
  late String id;
  late String name;
  late String position;
  late String emailAddress;
  late String details;
  late int order;

  BoardMember.params(this.id, this.name, this.position, this.emailAddress,
      this.details, this.order);

  BoardMember.noparams();
}

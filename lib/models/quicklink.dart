class QuickLink {
  late String id;
  late String icon;
  late String linkUrl;
  late String title;
  late int order;
  String? description;

  QuickLink.params(this.id, this.icon, this.linkUrl, this.title, this.order,
      this.description);
  QuickLink.noparams();
}

class CollectionEvent {
  final String widgetName;
  final String router;
  final bool isRemove;

  // token uid...
  CollectionEvent(this.widgetName, this.router, this.isRemove);
}

class RefreshEvent {
  RefreshEvent();
}

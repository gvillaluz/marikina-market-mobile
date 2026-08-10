class PageResult<T> {
  final List<T> tickets;
  final bool hasMore;

  const PageResult({
    required this.tickets,
    required this.hasMore,
  });
}
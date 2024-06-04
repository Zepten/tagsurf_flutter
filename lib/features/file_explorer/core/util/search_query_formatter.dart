class SearchQueryFormatter {
  static String format(String query) {
    return query.replaceAll('%', '\\%').replaceAll('_', '\\_').toLowerCase();
  }

  static String formatForSql(String query) {
    return '%${format(query)}%';
  }
}

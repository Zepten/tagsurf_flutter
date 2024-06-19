import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';

void main() {
  test('Format OK query', () {
    const query = 'Test Query';
    final result = SearchQueryFormatter.format(query);
    expect(result, equals('test query'));
  });

  test('Format OK query for SQL', () {
    const query = 'Test Query';
    final result = SearchQueryFormatter.formatForSql(query);
    expect(result, equals('%test query%'));
  });

  test('Format query with special characters', () {
    const query = '_%Test Query%_';
    final result = SearchQueryFormatter.format(query);
    expect(result, equals('\\_\\%test query\\%\\_'));
  });

  test('Format query with special characters for SQL', () {
    const query = '_%Test Query%_';
    final result = SearchQueryFormatter.formatForSql(query);
    expect(result, equals('%\\_\\%test query\\%\\_%'));
  });
}

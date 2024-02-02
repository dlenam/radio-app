import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio_app/features/widgets/favorite_icon.dart';
import 'package:radio_app/infra/dependency_injection.dart';
import 'package:radio_app/main.dart';

import '../test_utils/fake_http_client.dart';
import '../test_utils/in_memory_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Favorite and unfavorite a radio', (tester) async {
    await tester.runAsync(() async {
      await dependencyInjection(
        customHttpClient: FakeHttpClient(),
        customSharedPreferences: InMemoryStorageService(),
      );
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final finder = find.byType(ListTile, skipOffstage: false);
    final allRadioStationsCount = tester.widgetList(finder).length;
    expect(
      allRadioStationsCount,
      9,
      reason: 'Should list all the radio stations returned by the API',
    );

    // Favorite the first radio
    await tester.tap(find.byType(FavoriteIcon).first);
    // Move to favorites tab
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    final favoritesCount = tester.widgetList(finder).length;

    expect(favoritesCount, 1, reason: 'Should list the only radio favorited');
    // Unfavorites the radio
    await tester.tap(find.byType(FavoriteIcon).first);
    await tester.pumpAndSettle();

    final favoritesAfterUnfavoriteCount = tester.widgetList(finder).length;
    expect(favoritesAfterUnfavoriteCount, 0,
        reason: 'There should be no radio favorited');
  });
}

import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsLocalDataSourceImpl', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('canGenerateOnlineDeckToday returns true initially and false after recording', () async {
      final prefs = await SharedPreferences.getInstance();
      final dataSource = SettingsLocalDataSourceImpl(prefs);

      // Initially should be allowed
      expect(await dataSource.canGenerateOnlineDeckToday(), isTrue);

      // Record generation
      await dataSource.recordOnlineDeckGeneration();

      // Same day should now be false
      expect(await dataSource.canGenerateOnlineDeckToday(), isFalse);
    });

    test('saves and retrieves aiModelPreference', () async {
      final prefs = await SharedPreferences.getInstance();
      final dataSource = SettingsLocalDataSourceImpl(prefs);

      expect(
        await dataSource.getAiModelPreference(),
        equals(AiModelType.online),
      );

      await dataSource.saveAiModelPreference(AiModelType.local);
      expect(
        await dataSource.getAiModelPreference(),
        equals(AiModelType.local),
      );
    });
  });
}

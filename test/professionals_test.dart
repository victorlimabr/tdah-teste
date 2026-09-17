import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tdah_teste/data/services/url_launcher_service.dart';
import 'package:tdah_teste/ui/professionals/professionals_screen.dart';
import 'package:tdah_teste/ui/professionals/professionals_view_model.dart';

/// Launcher falso que registra a última URI aberta.
class _FakeLauncher implements UrlLauncherService {
  Uri? lastUri;
  bool result = true;

  @override
  Future<bool> open(Uri uri) async {
    lastUri = uri;
    return result;
  }
}

void main() {
  group('ProfessionalsViewModel', () {
    late _FakeLauncher launcher;
    late ProfessionalsViewModel viewModel;

    setUp(() {
      launcher = _FakeLauncher();
      viewModel = ProfessionalsViewModel(launcher);
    });

    test('searchNearby abre o mapa com a especialidade', () async {
      await viewModel.searchNearby('Psiquiatra');

      final uri = launcher.lastUri!;
      expect(uri.host, contains('google.com'));
      expect(uri.toString(), contains('maps'));
      expect(uri.toString(), contains('Psiquiatra'));
    });

    test('openDirectory abre a URL informada', () async {
      await viewModel.openDirectory('https://cadastro.cfp.org.br/');

      expect(launcher.lastUri.toString(), 'https://cadastro.cfp.org.br/');
    });

    test('callSupport disca para o CVV (188)', () async {
      await viewModel.callSupport();

      expect(launcher.lastUri!.scheme, 'tel');
      expect(launcher.lastUri!.path, '188');
    });

    test('propaga falha quando a abertura não funciona', () async {
      launcher.result = false;
      expect(await viewModel.openDirectory('https://x.test'), isFalse);
    });
  });

  testWidgets('tela mostra as opções e aciona a busca no mapa',
      (WidgetTester tester) async {
    final launcher = _FakeLauncher();

    await tester.pumpWidget(
      Provider<UrlLauncherService>.value(
        value: launcher,
        child: const MaterialApp(home: ProfessionalsScreen()),
      ),
    );

    expect(find.text('Encontrar profissionais'), findsOneWidget);
    expect(find.text('Psiquiatra'), findsOneWidget);
    expect(find.text('Apoio emocional · CVV 188'), findsOneWidget);

    await tester.tap(find.text('Psiquiatra'));
    await tester.pump();

    expect(launcher.lastUri.toString(), contains('google.com/maps'));
    expect(launcher.lastUri.toString(), contains('Psiquiatra'));
  });
}

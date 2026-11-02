// Run: flutter test tool/capture_preview.dart
// Produces previews from the real widgets with the same five seeded records.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:examina/app.dart';
import 'package:examina/data/providers.dart';
import 'package:examina/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/support/fakes.dart';

void main() {
  testWidgets('capture the three assignment screens', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final font = File('C:/Windows/Fonts/segoeui.ttf');
    if (await font.exists()) {
      final loader = FontLoader('Roboto')
        ..addFont(
          font.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      await loader.load();
    }
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(
            MemoryExpenseRepository(),
          ),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemoryPreferences({})),
          ),
        ],
        child: RepaintBoundary(key: boundaryKey, child: const ExaminaApp()),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.runAsync(() async {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final directory = Directory('docs/screenshots');
        await directory.create(recursive: true);
        await File('${directory.path}/$name.png')
            .writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('expenses');
    await tester.tap(find.byKey(const ValueKey('edit-1')));
    await tester.pumpAndSettle();
    await capture('edit-expense');
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings')));
    await tester.pumpAndSettle();
    await capture('currency-settings');
    expect(tester.takeException(), isNull);
  });
}

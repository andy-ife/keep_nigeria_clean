import 'package:keep_nigeria_clean/models/gas.dart';

class GasConstants {
  static const methane = Gas(
    name: 'Methane',
    description: 'Toxic & flammable',
    assetPath: 'assets/methane.svg',
  );

  static const butane = Gas(
    name: 'Butane',
    description: 'Explosive vapor',
    assetPath: 'assets/butane.svg',
  );

  static const alcohol = Gas(
    name: 'Alcohol',
    description: 'Strong fumes',
    assetPath: 'assets/alcohol.svg',
  );

  static const smoke = Gas(
    name: 'Smoke',
    description: 'Could mean fire',
    assetPath: 'assets/smoke.svg',
  );
}

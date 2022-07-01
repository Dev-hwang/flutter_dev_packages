import 'package:flutter/material.dart';

enum ButtonSize {
  appleSmall,      // 30px
  appleMedium,     // 44px
  appleLarge,      // 50px
  appleXLarge,     // 57px

  materialSmall,   // 28px
  materialMedium,  // 36px
  materialLarge,   // 48px
  materialXLarge,  // 56px

  facebookSmall,   // 32px
  facebookMedium,  // 40px
  facebookLarge,   // 48px

  polarisSmall,    // 30px
  polarisMedium,   // 36px
  polarisLarge,    // 44px
}

extension ButtonSizeExtension on ButtonSize {
  double get minWidth {
    switch (this) {
      case ButtonSize.appleSmall: return 0.0;
      case ButtonSize.appleMedium: return 0.0;
      case ButtonSize.appleLarge: return 0.0;
      case ButtonSize.appleXLarge: return 0.0;
      case ButtonSize.materialSmall: return 0.0;
      case ButtonSize.materialMedium: return 0.0;
      case ButtonSize.materialLarge: return 0.0;
      case ButtonSize.materialXLarge: return 0.0;
      case ButtonSize.facebookSmall: return 0.0;
      case ButtonSize.facebookMedium: return 0.0;
      case ButtonSize.facebookLarge: return 0.0;
      case ButtonSize.polarisSmall: return 0.0;
      case ButtonSize.polarisMedium: return 0.0;
      case ButtonSize.polarisLarge: return 0.0;
    }
  }

  double get minHeight {
    switch (this) {
      case ButtonSize.appleSmall: return 30.0;
      case ButtonSize.appleMedium: return 44.0;
      case ButtonSize.appleLarge: return 50.0;
      case ButtonSize.appleXLarge: return 57.0;
      case ButtonSize.materialSmall: return 28.0;
      case ButtonSize.materialMedium: return 36.0;
      case ButtonSize.materialLarge: return 48.0;
      case ButtonSize.materialXLarge: return 56.0;
      case ButtonSize.facebookSmall: return 32.0;
      case ButtonSize.facebookMedium: return 40.0;
      case ButtonSize.facebookLarge: return 48.0;
      case ButtonSize.polarisSmall: return 30.0;
      case ButtonSize.polarisMedium: return 36.0;
      case ButtonSize.polarisLarge: return 44.0;
    }
  }

  EdgeInsetsGeometry get padding {
    switch (this) {
      case ButtonSize.appleSmall:
      case ButtonSize.materialSmall:
      case ButtonSize.facebookSmall:
      case ButtonSize.polarisSmall:
        return const EdgeInsets.symmetric(horizontal: 14.0);
      case ButtonSize.materialMedium:
      case ButtonSize.facebookMedium:
      case ButtonSize.polarisMedium:
        return const EdgeInsets.symmetric(horizontal: 18.0);
      case ButtonSize.appleMedium:
      case ButtonSize.appleLarge:
      case ButtonSize.materialLarge:
      case ButtonSize.facebookLarge:
      case ButtonSize.polarisLarge:
        return const EdgeInsets.symmetric(horizontal: 24.0);
      case ButtonSize.appleXLarge:
      case ButtonSize.materialXLarge:
        return const EdgeInsets.symmetric(horizontal: 32.0);
    }
  }
}

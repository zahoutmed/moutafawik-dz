import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// إعدادات Firebase المولدة لمشروع Moutafawik DZ (moutafawik-dz-app)
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4LC2z8su8oRz0ZLHf7jGx-79RWYFtA94',
    appId: '1:144518051294:web:40181d811d017ec161994f',
    messagingSenderId: '144518051294',
    projectId: 'moutafawik-dz-app',
    authDomain: 'moutafawik-dz-app.firebaseapp.com',
    storageBucket: 'moutafawik-dz-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4jVRrbvphrdAy6zd5KtrqtHPiPiOnySQ',
    appId: '1:144518051294:android:9622f8fd0b4fbd9361994f',
    messagingSenderId: '144518051294',
    projectId: 'moutafawik-dz-app',
    storageBucket: 'moutafawik-dz-app.firebasestorage.app',
  );
}

# دليل إعداد Firebase 🔥

هذا الدليل سيساعدك في إعداد Firebase للتطبيق خطوة بخطوة.

## 📋 المتطلبات الأساسية

- حساب Google
- Flutter SDK مثبت
- Android Studio أو VS Code

## 🚀 خطوات الإعداد

### 1. إنشاء مشروع Firebase

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "إنشاء مشروع" (Create a project)
3. أدخل اسم المشروع: `instagram-clone-app`
4. اختر إعدادات Google Analytics (اختياري)
5. انقر على "إنشاء المشروع"

### 2. إعداد Authentication

1. في لوحة تحكم Firebase، اذهب إلى **Authentication**
2. انقر على **Get started**
3. اذهب إلى تبويب **Sign-in method**
4. فعّل الطرق التالية:
   - ✅ **Email/Password**
   - ✅ **Anonymous** (للدخول كضيف)

### 3. إعداد Firestore Database

1. اذهب إلى **Firestore Database**
2. انقر على **Create database**
3. اختر **Start in test mode** (للتطوير)
4. اختر موقع قاعدة البيانات (أقرب منطقة لك)

#### قواعد Firestore الأمنية

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // قواعد للمستخدمين
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null;
    }
    
    // قواعد للمنشورات
    match /posts/{postId} {
      allow read, write: if request.auth != null;
    }
    
    // قواعد للتعليقات
    match /posts/{postId}/comments/{commentId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. إعداد Firebase Storage

1. اذهب إلى **Storage**
2. انقر على **Get started**
3. اختر **Start in test mode**
4. اختر موقع التخزين

#### قواعد Storage الأمنية

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 5. إضافة التطبيقات

#### للأندرويد:

1. انقر على أيقونة Android في نظرة عامة للمشروع
2. أدخل package name: `com.example.instagram_clone_flutter`
3. أدخل اسم التطبيق: `Instagram Clone`
4. حمّل ملف `google-services.json`
5. ضع الملف في `android/app/`

#### لـ iOS:

1. انقر على أيقونة iOS
2. أدخل Bundle ID: `com.example.instagramCloneFlutter`
3. أدخل اسم التطبيق: `Instagram Clone`
4. حمّل ملف `GoogleService-Info.plist`
5. ضع الملف في `ios/Runner/`

#### للويب:

1. انقر على أيقونة Web
2. أدخل اسم التطبيق: `Instagram Clone Web`
3. انسخ إعدادات Firebase Config

### 6. تحديث إعدادات Flutter

#### في ملف `lib/main.dart`:

```dart
// استبدل هذه الإعدادات بإعداداتك
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    appId: "YOUR_APP_ID", 
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET"
  ),
);
```

#### في ملف `android/app/build.gradle`:

```gradle
// أضف في نهاية الملف
apply plugin: 'com.google.gms.google-services'
```

#### في ملف `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### 7. تثبيت التبعيات

```bash
flutter pub get
```

### 8. اختبار الاتصال

1. شغّل التطبيق:
```bash
flutter run
```

2. جرب إنشاء حساب جديد
3. جرب تسجيل الدخول
4. جرب الدخول كضيف

## 🔒 إعدادات الأمان المتقدمة

### قواعد Firestore المحسنة

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // دالة للتحقق من المالك
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }
    
    // دالة للتحقق من المصادقة
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // قواعد المستخدمين
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    // قواعد المنشورات
    match /posts/{postId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && isOwner(resource.data.uid);
      allow update, delete: if isAuthenticated() && isOwner(resource.data.uid);
    }
    
    // قواعد التعليقات
    match /posts/{postId}/comments/{commentId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if isAuthenticated() && isOwner(resource.data.uid);
    }
  }
}
```

### قواعد Storage المحسنة

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // صور الملفات الشخصية
    match /profilePics/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // صور المنشورات
    match /posts/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🚨 نصائح مهمة

1. **لا تشارك مفاتيح API**: احتفظ بإعدادات Firebase آمنة
2. **استخدم قواعد أمان صارمة**: في الإنتاج
3. **راقب الاستخدام**: تحقق من استهلاك Firebase بانتظام
4. **نسخ احتياطية**: اعمل نسخ احتياطية من قاعدة البيانات

## 🔧 استكشاف الأخطاء

### خطأ في الاتصال بـ Firebase

```
[ERROR:flutter/lib/ui/ui_dart_state.cc] Unhandled Exception: [firebase_auth/network-request-failed]
```

**الحل**: تحقق من اتصال الإنترنت وإعدادات Firebase

### خطأ في المصادقة

```
[ERROR:flutter/lib/ui/ui_dart_state.cc] Unhandled Exception: [firebase_auth/invalid-api-key]
```

**الحل**: تحقق من صحة مفاتيح API في `main.dart`

### خطأ في قواعد Firestore

```
[ERROR:flutter/lib/ui/ui_dart_state.cc] Unhandled Exception: [cloud_firestore/permission-denied]
```

**الحل**: تحقق من قواعد الأمان في Firestore

## 📞 الدعم

إذا واجهت أي مشاكل في الإعداد:

1. راجع [وثائق Firebase الرسمية](https://firebase.google.com/docs)
2. تحقق من [مجتمع Flutter](https://flutter.dev/community)
3. ابحث في [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase+flutter)

---

**نصيحة**: احتفظ بنسخة من هذا الدليل للرجوع إليه لاحقاً! 📚
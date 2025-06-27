# دليل المطور 👨‍💻

دليل شامل للمطورين الذين يريدون فهم وتطوير هذا المشروع.

## 🏗️ هيكل المشروع

```
lib/
├── main.dart                 # نقطة البداية
├── models/                   # نماذج البيانات
│   └── user.dart            # نموذج المستخدم
├── providers/               # إدارة الحالة
│   └── user_provider.dart   # موفر بيانات المستخدم
├── resources/               # خدمات البيانات
│   ├── auth_methods.dart    # خدمات المصادقة
│   ├── firestore_methods.dart # خدمات قاعدة البيانات
│   └── storage_methods.dart # خدمات التخزين
├── responsive/              # التصميم المتجاوب
│   ├── mobile_screen_layout.dart
│   ├── web_screen_layout.dart
│   └── responsive_layout.dart
├── screens/                 # شاشات التطبيق
│   ├── login_screen.dart    # شاشة تسجيل الدخول
│   ├── signup_screen.dart   # شاشة التسجيل
│   ├── feed_screen.dart     # الخلاصة الرئيسية
│   ├── add_post_screen.dart # إضافة منشور
│   ├── profile_screen.dart  # الملف الشخصي
│   ├── search_screen.dart   # البحث
│   └── comments_screen.dart # التعليقات
├── utils/                   # أدوات مساعدة
│   ├── colors.dart          # نظام الألوان
│   ├── utils.dart           # دوال مساعدة
│   └── global_variable.dart # متغيرات عامة
└── widgets/                 # مكونات قابلة للإعادة
    ├── text_field_input.dart # حقل الإدخال
    ├── post_card.dart       # بطاقة المنشور
    └── follow_button.dart   # زر المتابعة
```

## 🎨 نظام الألوان

### الألوان الأساسية

```dart
// ألوان الخلفية
const mobileBackgroundColor = Color.fromRGBO(15, 15, 15, 1);
const webBackgroundColor = Color.fromRGBO(25, 25, 25, 1);
const cardColor = Color.fromRGBO(28, 28, 30, 1);

// ألوان النص
const primaryColor = Color.fromRGBO(245, 245, 245, 1);
const textSecondaryColor = Color.fromRGBO(174, 174, 178, 1);

// ألوان التفاعل
const blueColor = Color.fromRGBO(24, 119, 242, 1);
const accentColor = Color.fromRGBO(255, 45, 85, 1);

// ألوان الحالة
const successColor = Color.fromRGBO(52, 199, 89, 1);
const warningColor = Color.fromRGBO(255, 149, 0, 1);
const errorColor = Color.fromRGBO(255, 59, 48, 1);
```

### استخدام الألوان

```dart
// في الويدجت
Container(
  color: cardColor,
  child: Text(
    'مرحباً',
    style: TextStyle(color: primaryColor),
  ),
)
```

## 🔧 إدارة الحالة

### استخدام Provider

```dart
// في main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ],
  child: MyApp(),
)

// في الويدجت
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Text(userProvider.getUser.username);
  }
}
```

### إضافة موفر جديد

```dart
// 1. إنشاء الكلاس
class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  
  List<Post> get posts => _posts;
  
  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }
}

// 2. إضافته في main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => PostProvider()), // جديد
  ],
  child: MyApp(),
)
```

## 🔥 التعامل مع Firebase

### المصادقة

```dart
// تسجيل دخول
Future<String> loginUser({
  required String email,
  required String password,
}) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return "success";
  } catch (err) {
    return err.toString();
  }
}

// تسجيل خروج
Future<void> signOut() async {
  await _auth.signOut();
}
```

### Firestore

```dart
// إضافة بيانات
Future<void> addPost({
  required String description,
  required Uint8List file,
  required String uid,
  required String username,
  required String profImage,
}) async {
  try {
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('posts', file, true);
    
    String postId = const Uuid().v1();
    
    Post post = Post(
      description: description,
      uid: uid,
      username: username,
      postId: postId,
      datePublished: DateTime.now(),
      postUrl: photoUrl,
      profImage: profImage,
      likes: [],
    );

    _firestore.collection('posts').doc(postId).set(post.toJson());
  } catch (err) {
    throw err;
  }
}

// قراءة البيانات
Stream<QuerySnapshot> getPosts() {
  return _firestore
      .collection('posts')
      .orderBy('datePublished', descending: true)
      .snapshots();
}
```

## 📱 إنشاء شاشة جديدة

### 1. إنشاء ملف الشاشة

```dart
// lib/screens/new_screen.dart
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'شاشة جديدة',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: const Center(
        child: Text(
          'محتوى الشاشة',
          style: TextStyle(color: primaryColor),
        ),
      ),
    );
  }
}
```

### 2. إضافة التنقل

```dart
// للانتقال إلى الشاشة
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const NewScreen(),
  ),
);

// للاستبدال
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => const NewScreen(),
  ),
);
```

## 🧩 إنشاء ويدجت جديد

### ويدجت بسيط

```dart
// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [gradientStart, gradientEnd],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: primaryColor)
            : Text(
                text,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
```

### استخدام الويدجت

```dart
CustomButton(
  text: 'اضغط هنا',
  onPressed: () {
    print('تم الضغط!');
  },
  isLoading: false,
)
```

## 🔍 معالجة الأخطاء

### نمط معالجة الأخطاء

```dart
Future<String> performAction() async {
  try {
    // العملية المطلوبة
    await someAsyncOperation();
    return "success";
  } on FirebaseAuthException catch (e) {
    // أخطاء المصادقة
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      default:
        return e.message ?? 'خطأ في المصادقة';
    }
  } on FirebaseException catch (e) {
    // أخطاء Firebase عامة
    return e.message ?? 'خطأ في الخدمة';
  } catch (e) {
    // أخطاء عامة
    return 'حدث خطأ غير متوقع';
  }
}
```

### عرض الأخطاء للمستخدم

```dart
void handleResult(String result) {
  if (result == "success") {
    showSuccessSnackBar(context, 'تمت العملية بنجاح');
  } else {
    showErrorSnackBar(context, result);
  }
}
```

## 🧪 الاختبار

### اختبار الوحدة

```dart
// test/auth_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';

void main() {
  group('Auth Tests', () {
    test('should validate email format', () {
      // ترتيب
      const email = 'test@example.com';
      
      // تنفيذ
      bool isValid = isValidEmail(email);
      
      // تحقق
      expect(isValid, true);
    });
  });
}
```

### اختبار الويدجت

```dart
// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_clone_flutter/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton should display text', (WidgetTester tester) async {
    // ترتيب
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'اختبار',
            onPressed: () {},
          ),
        ),
      ),
    );

    // تحقق
    expect(find.text('اختبار'), findsOneWidget);
  });
}
```

## 📊 الأداء

### نصائح لتحسين الأداء

1. **استخدم const للويدجت الثابتة**
```dart
const Text('نص ثابت') // بدلاً من Text('نص ثابت')
```

2. **استخدم ListView.builder للقوائم الطويلة**
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

3. **تجنب إعادة البناء غير الضرورية**
```dart
// استخدم Consumer بدلاً من Provider.of
Consumer<UserProvider>(
  builder: (context, userProvider, child) {
    return Text(userProvider.username);
  },
)
```

## 🔒 الأمان

### نصائح الأمان

1. **لا تضع مفاتيح API في الكود**
2. **استخدم قواعد Firebase الأمنية**
3. **تحقق من المدخلات دائماً**
4. **استخدم HTTPS فقط**

### مثال على التحقق من المدخلات

```dart
bool isValidInput(String input) {
  if (input.isEmpty) return false;
  if (input.length < 3) return false;
  if (input.contains(RegExp(r'[<>]'))) return false; // منع XSS
  return true;
}
```

## 📚 موارد إضافية

- [وثائق Flutter](https://flutter.dev/docs)
- [وثائق Firebase](https://firebase.google.com/docs)
- [دليل Provider](https://pub.dev/packages/provider)
- [أفضل الممارسات في Flutter](https://flutter.dev/docs/development/best-practices)

## 🤝 المساهمة

### قبل المساهمة

1. اقرأ هذا الدليل كاملاً
2. تأكد من فهم هيكل المشروع
3. اتبع نمط الكود الموجود
4. اكتب اختبارات للكود الجديد
5. حدث التوثيق إذا لزم الأمر

### نمط الكود

```dart
// استخدم أسماء واضحة
String getUserName() // جيد
String getUsrNm() // سيء

// اكتب تعليقات مفيدة
// تحقق من صحة البريد الإلكتروني قبل الإرسال
if (isValidEmail(email)) {
  // ...
}

// استخدم const عند الإمكان
const SizedBox(height: 16)

// نظم الاستيرادات
import 'package:flutter/material.dart'; // Flutter
import 'package:provider/provider.dart'; // External packages
import 'package:instagram_clone_flutter/utils/colors.dart'; // Internal
```

---

**نصيحة**: احتفظ بهذا الدليل مفتوحاً أثناء التطوير! 📖
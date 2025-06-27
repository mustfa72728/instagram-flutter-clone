import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // التحقق من صحة البيانات
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _bioController.text.trim().isEmpty) {
      showErrorSnackBar(context, 'يرجى ملء جميع الحقول');
      return;
    }

    if (_image == null) {
      showErrorSnackBar(context, 'يرجى اختيار صورة الملف الشخصي');
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      showErrorSnackBar(context, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      file: _image!,
    );

    if (res == "success") {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, _getArabicErrorMessage(res));
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  String _getArabicErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'البريد الإلكتروني مستخدم بالفعل';
    } else if (error.contains('invalid-email')) {
      return 'البريد الإلكتروني غير صحيح';
    } else if (error.contains('weak-password')) {
      return 'كلمة المرور ضعيفة';
    } else if (error.contains('network-request-failed')) {
      return 'خطأ في الاتصال بالإنترنت';
    }
    return error;
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mobileBackgroundColor,
              webBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                
                // شعار Instagram
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                ),
                const SizedBox(height: 30),
                
                // عنوان
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'انضم إلى مجتمعنا اليوم',
                  style: TextStyle(
                    fontSize: 16,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                
                // صورة الملف الشخصي
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: cardColor,
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundColor: cardColor,
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: textSecondaryColor,
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: blueColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                
                // حقول الإدخال
                TextFieldInput(
                  hintText: 'اسم المستخدم',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'البريد الإلكتروني',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'كلمة المرور',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'نبذة عنك',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  prefixIcon: Icons.info_outline,
                ),
                const SizedBox(height: 30),
                
                // زر التسجيل
                InkWell(
                  onTap: _isLoading ? null : signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [gradientStart, gradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: blueColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'إنشاء الحساب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                
                // رابط تسجيل الدخول
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟ ',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
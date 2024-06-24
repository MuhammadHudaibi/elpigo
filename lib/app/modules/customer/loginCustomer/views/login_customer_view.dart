import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_customer_controller.dart';

class LoginCustomerView extends GetView<LoginCustomerController> {
  const LoginCustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, right: 310),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 35,
                  onPressed: () {
                    Get.toNamed('/confirm');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                child: Center(
                  child: Text(
                    "LOGIN\nCUSTOMER",
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 82, 140, 75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                child: Container(
                  width: 340,
                  height: 420,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 82, 140, 75),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: controller.emailNikController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Masukkan NIK/Email Anda",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 300,
                          child: Obx(() => TextFormField(
                                controller: controller.passwordController,
                                cursorColor: Colors.white,
                                obscureText: controller.isObscured.value,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.toggleObscure();
                                    },
                                    icon: Icon(
                                      controller.isObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text(
                                "Lupa Password?",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(180, 50),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            controller.login(
                              controller.emailNikController.text,
                              controller.passwordController.text,
                            ); // Panggil fungsi login
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 82, 140, 75),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register-customer');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Belum memiliki akun? ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Buat akun',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

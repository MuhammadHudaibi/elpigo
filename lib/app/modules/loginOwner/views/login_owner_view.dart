import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_owner_controller.dart';

class LoginOwnerView extends GetView<LoginOwnerController> {
  LoginOwnerView({Key? key}) : super(key: key);

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
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                child: Container(
                  width: 340,
                  height: 420,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          child: TextFormField(
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
                              hintText: "ID Pangkalan",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 300,
                          child: Obx(() => TextFormField(
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
                              onPressed: () {},
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
                          onPressed: () {},
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum memiliki akun?",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Buat akun",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/register_customer_controller.dart';

class RegisterCustomerView extends GetView<RegisterCustomerController> {
  const RegisterCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 310),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
                    child: Text(
                      "REGISTRASI",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 82, 140, 75),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    child: Container(
                      width: 340,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 82, 140, 75),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: controller.nameController,
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
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "Nama Sesuai KTP",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                errorText: controller.nameError.value.isNotEmpty
                                    ? controller.nameError.value
                                    : null,
                                errorStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: controller.nikController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.number,
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
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "NIK Anda",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                errorText: controller.nikError.value.isNotEmpty
                                    ? controller.nikError.value
                                    : null,
                                errorStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: controller.addressController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.streetAddress,
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
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "Alamat Anda",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                errorText:
                                    controller.addressError.value.isNotEmpty
                                        ? controller.addressError.value
                                        : null,
                                errorStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: controller.emailController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
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
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "Email Anda",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                errorText:
                                    controller.emailError.value.isNotEmpty
                                        ? controller.emailError.value
                                        : null,
                                errorStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: controller.phoneController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.phone,
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
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "Nomor HP Anda",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                errorText:
                                    controller.phoneError.value.isNotEmpty
                                        ? controller.phoneError.value
                                        : null,
                                errorStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => DropdownButtonFormField<String>(
                                value: controller
                                        .selectedCustomerType.value.isEmpty
                                    ? null
                                    : controller.selectedCustomerType.value,
                                hint: Text(
                                  'Pilih Tipe Pelanggan',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
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
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorText: controller
                                          .customerTypeError.value.isNotEmpty
                                      ? controller.customerTypeError.value
                                      : null,
                                  errorStyle:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                                dropdownColor: Color.fromARGB(255, 58, 100, 53),
                                items: controller.customerTypes.map((type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedCustomerType.value =
                                      value!;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                cursorColor: Colors.white,
                                obscureText:
                                    controller.isObscuredPassword.value,
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
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "Kata Sandi",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  errorText:
                                      controller.passwordError.value.isNotEmpty
                                          ? controller.passwordError.value
                                          : null,
                                  errorStyle:
                                      GoogleFonts.poppins(color: Colors.white),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.toggleObscurePassword();
                                    },
                                    icon: Icon(
                                      controller.isObscuredPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => TextFormField(
                                controller:
                                    controller.confirmPasswordController,
                                cursorColor: Colors.white,
                                obscureText:
                                    controller.isObscuredConfirmPassword.value,
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
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "Konfirmasi Kata Sandi",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  errorText: controller
                                          .confirmPasswordError.value.isNotEmpty
                                      ? controller.confirmPasswordError.value
                                      : null,
                                  errorStyle:
                                      GoogleFonts.poppins(color: Colors.white),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.toggleObscureConfirmPassword();
                                    },
                                    icon: Icon(
                                      controller.isObscuredConfirmPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 23),
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
                                controller.register();
                              },
                              child: Text(
                                "Registrasi",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 82, 140, 75),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/login-customer');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Sudah memiliki akun? ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Login',
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
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

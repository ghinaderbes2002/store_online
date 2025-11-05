import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/constant/App_link.dart';
class ChangeServerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ipController = TextEditingController(
      text: ServerConfig().serverLink
          .replaceAll("http://", "")
          .split(":")
          .first,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: ipController,
          decoration: const InputDecoration(
            labelText: "IP السيرفر",
            hintText: "مثال: 192.168.1.10",
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            await ServerConfig().updateServerLink(ipController.text.trim());
            Get.back();
            Get.snackbar("تم الحفظ", "تم تحديث عنوان السيرفر");
          },
          child: const Text("حفظ"),
        ),
      ],
    );
  }
}

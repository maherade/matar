import 'package:flutter/material.dart';
import 'package:mattar/component/component.dart';

class NotificationSettings extends StatefulWidget {
  NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool switchOne = false;

  bool switchTwo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "التنبيهات",
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('ايفاق استقبال اشعارات من قسم التوقعات'),
                  Spacer(),
                  Switch(
                      value: switchOne,
                      onChanged: (value) {
                        setState(() {
                          switchOne = value;
                          if (value == true) {
                            buildToast(
                                text: "تم ايقاف التنبيهات",
                                color: Colors.black);
                          }
                        });
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('ايفاق ظهور اشعارات منشور جديد'),
                  Spacer(),
                  Switch(
                      value: switchTwo,
                      onChanged: (value2) {
                        setState(() {
                          switchTwo = value2;
                          if (value2 == true) {
                            buildToast(
                                text: "تم ايقاف التنبيهات",
                                color: Colors.black);
                          }
                        });
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

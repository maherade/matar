// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mattar/component/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed("main layout"),
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.black,
                    )),
                Text(
                  "عن التطبيق",
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: secondColor, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "رقم الاصدار",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "1.0.1",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            rowDesign("سياسة الخصوصية"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "matar has adopted this privacy policy (“Privacy Policy”) to explain how matar collects, stores, and uses the information collected in connection with matar ’s Services.BY INSTALLING, USING, REGISTERING TO OR OTHERWISE ACCESSING THE SERVICES, YOU AGREE TO THIS PRIVACY POLICY AND GIVE AN EXPLICIT AND INFORMED CONSENT TO THE PROCESSING OF YOUR PERSONAL DATA IN ACCORDANCE WITH THIS PRIVACY POLICY. IF YOU DO NOT AGREE TO THIS PRIVACY POLICY, PLEASE DO NOT INSTALL, USE, REGISTER TO OR OTHERWISE ACCESS THE SERVICES. matar reserves the right to modify this Privacy Policy at reasonable times, so please review it frequently. If matar makes material or significant changes to this Privacy Policy, matar may post a notice on matar website along with the updated Privacy Policy. Your continued use of Services will signify your acceptance of the changes to this Privacy Policy.Non-personal dataFor purposes of this Privacy Policy, “non-personal data” means information that does not directly identify you. The types of non-personal data matar may collect and use include, but are not limited to: application properties, including, but not limited to application name, package name and icon installed on your device. Your checkin (include like, recommendation) of a game will be disclosed to all matar users.matar may use and disclose to matar’s partners and contractors the collected non-personal data for purposes of analyzing usage of the Services, advertisement serving, managing and providing the Services and to further develop the Services and other matar services and products.You recognize and agree that the analytics companies utilized by matar may combine the information collected with other information they have independently collected from other services or products relating to your activities. These companies collect and use information under their own privacy policies."),
            ),
            rowDesign("المعلومات الشخصيه"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "For purposes of this Privacy Policy, “personal data” means personally identifiable information that specifically identifies you as an individual.Personal information collected by matar is information voluntarily provided to us by you when you create your account or change your account information. The information includes your facebook id, name, gender, location and your friends’id on facebook. matar also stores your game checkins, likes, dislikes, recommendations and messages.matar may use collected personal data for purposes of analyzing usage of the Services, providing customer and technical support, managing and providing Services (including managing advertisement serving) and to further develop the Services and other matar services and products. matar may combine non-personal data with personal data.Please note that certain features of the Services may be able to connect to your social networking sites to obtain additional information about you. In such cases, matar may be able to collect certain information from your social networking profile when your social networking site permits it, and when you consent to allow your social networking site to make that information available to matar. This information may include, but is not limited to, your name, profile picture, gender, user ID, email address, your country, your language, your time zone, the organizations and links on your profile page, the names and profile pictures of your social networking site “friends” and other information you have included in your social networking site profile. matar may associate and/or combine as well as use information collected by matar and/or obtained through such social networking sites in accordance with this Privacy Policy.Disclosure and Transfer of Personal Datamatar collects and processes personal data on a voluntary basis and it is not in the business of selling your personal data to third parties. Personal data may, however, occasionally be disclosed in accordance with applicable legislation and this Privacy Policy. Additionally, matar may disclose personal data to its parent companies and its subsidiaries in accordance with this Privacy Policy.matar may hire agents and contractors to collect and process personal data on matar’s behalf and in such cases such agents and contractors will be instructed to comply with our Privacy Policy and to use personal data only for the purposes for which the third party has been engaged by matar. These agents and contractors may not use your personal data for their own marketing purposes. matar may use third party service providers such as credit card processors, e-mail service providers, shipping agents, data analyzers and business intelligence providers. matar has the right to share your personal data as necessary for the aforementioned third parties to provide their services for matar. matar is not liable for the acts and omissions of these third parties, except as provided by mandatory law.matar may disclose your personal data to third parties as required by law enforcement or other government officials in connection with an investigation of fraud, intellectual property infringements, or other activity that is illegal or may expose you or matar to legal liability. matar may also disclose your personal data to third parties when matar has a reason to believe that a disclosure is necessary to address potential or actual injury or interference with matar’s rights, property, operations, users or others who may be harmed or may suffer loss or damage, or matar believes that such disclosure is necessary to protect matar ’s rights, combat fraud and/or comply with a judicial proceeding, court order, or legal process served on matar. To the extent permitted by applicable law, matar will make reasonable efforts to notify you of such disclosure through matar’s website or in another reasonable manner."),
            ),
            rowDesign("الضمانات"),
            Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                    textDirection: TextDirection.ltr,
                    "matar follows generally accepted industry standards and maintains reasonable safeguards to attempt to ensure the security, integrity and privacy of the information in matar’s possession. Only those persons with a need to process your personal data in connection with the fulfillment of their tasks in accordance with the purposes of this Privacy Policy and for the purposes of performing technical maintenance, have access to your personal data in matar’s possession. Personal data collected by matar is stored in secure operating environments that are not available to the public. To prevent unauthorized on-line access to personal data, matar maintains personal data behind a firewall-protected server. However, no system can be 100% secure and there is the possibility that despite matar’s reasonable efforts, there could be unauthorized access to your personal data. By using the Services, you assume this risk.")),
            rowDesign("اخري"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "Please be aware of the open nature of certain social networking and other open features of the Services matar may make available to you. You may choose to disclose data about yourself in the course of contributing user generated content to the Services. Any data that you disclose in any of these forums, blogs, chats or the like is public information, and there is no expectation of privacy or confidentiality. matar is not responsible for any personal data you choose to make public in any of these forums.If you are under 15 years of age or a minor in your country of residence, please ask your legal guardian’s permission to use or access the Services. matar takes children’s privacy seriously, and encourages parents and/or guardians to play an active role in their children's online experience at all times. matar does not knowingly collect any personal information from children below the aforementioned age and if matar learns that matar has inadvertently gathered personal data from children under the aforementioned age, matar will take reasonable measures to promptly erase such personal data from matar’s records.matar may store and/or transfer your personal data to its affiliates and partners in and outside of EU/EEA member states and the United States in accordance with mandatory legislation and this Privacy Policy. matar may disclose your personal data to third parties in connection with a corporate merger, consolidation, restructuring, the sale of substantially all of matar’s stock and/or assets or other corporate change, including, without limitation, during the course of any due diligence process provided, however, that this Privacy Policy shall continue to govern such personal data.matar regularly reviews its compliance with this Privacy Policy. If matar receives a formal written complaint from you, it is matar’s policy to attempt to contact you directly to address any of your concerns. matar will cooperate with the appropriate governmental authorities, including data protection authorities, to resolve any complaints regarding the collection, use, transfer or disclosure of personal data that cannot be amicably resolved between you and matar.3rd party servicesWe use 3rd party services in our apps. These services collect usage data in compliance with their Privacy Policies. The services are described below."),
            ),
            rowDesign("دعاية"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "3rd party ad serving systems allow user data to be utilized for advertising communication purposes displayed in the form of banners and other advertisements on matar apps, possibly based on user interests."),
            ),
            rowDesign("ادموب"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "We use Admob by Google as the main ad server. Please see Admob Privacy Policy – https://www.google.com/intl/en/policies/privacy/"),
            ),
            rowDesign("تحليلات"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "3rd party analytics services allow us to monitor and analyze app usage, better understand our audience and user behavior."),
            ),
            rowDesign("Flurry"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  "We use Flurry Analytics to collect, monitor and analyze log data, including frequency of use, length of time spent in the app, in order to improve functionality and user-friendliness of our apps. Please see Flurry Privacy Policy – http://www.flurry.com/privacy-policy.html"),
            ),
            rowDesign("Google Analytics"),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                  textDirection: TextDirection.ltr,
                  " Google Analytics is an analysis service provided by Google Inc. Google utilizes the collected data to track and examine the use of matar Apps, to prepare reports on user activities and share them with other Google services. Google may use the data to contextualize and personalize the ads of its own advertising network. (http://www.google.com/intl/en/policies/privacy/) Children’s Online Privacy Protection Act Compliance We are in compliance with the requirements of COPPA, we do not collect any personal information from anyone under 13 years of age. Our products and services are all directed to people who are at least 13 years old or older."),
            ),
            rowDesign("تواصل معنا"),
            Container(
                padding: const EdgeInsets.all(15),
                child: Text("mail: twtlmy@gmail.com")),
          ],
        ),
      ),
    );
  }
}

Widget rowDesign(String text) {
  return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: secondColor, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                color: whiteColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                size: 30,
              ))
        ],
      ));
}

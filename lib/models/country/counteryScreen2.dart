import 'package:flutter/material.dart';
import 'package:mattar/component/constants.dart';

import '../../component/component.dart';
import '../../data/country data.dart';
import '../../network/local/shared_pref.dart';

class CountryScreen2 extends StatelessWidget {
  const CountryScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "ما هي دولتك؟",
              style: Theme.of(context).textTheme.headline1,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(countryData.length, (index) {
                    return InkWell(
                      onTap: () {
                        // CacheHelper.saveData(key: "countryId", value: model.id);
                        CacheHelper.saveData(
                            key: "Noticountry",
                            value: countryData[index].country);
                        Navigator.of(context)
                            .pushReplacementNamed("country page");
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: whiteColor,
                            boxShadow: [shadow()]),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/${countryData[index].icon}",
                              height: 50,
                            ),
                            Expanded(
                                child: Text(
                              "${countryData[index].country}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/constants.dart';

import '../../component/component.dart';
import 'cubit/cubit/country_cubit.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountryCubit()..getCountry(),
      child: BlocConsumer<CountryCubit, CountryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
            ),
            body: Center(
              child: state is GetCountryLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          "اختيار قسم المنشورات",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: List.generate(
                                  CountryCubit.caller(context).countries.length,
                                  (index) => countryContainer(
                                      context: context,
                                      model: CountryCubit.caller(context)
                                          .countries[index])),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

//  Expanded(
//                 child: Container(
//                     margin: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: whiteColor,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [shadow()],
//                     ),
//                     child: ListView.builder(
//                         itemCount: 6,
//                         itemBuilder: (ctx, index) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               countryContainer(
//                                   context: context, index: a[index]),
//                               countryContainer(
//                                   context: context, index: b[index]),
//                               countryContainer(
//                                   context: context, index: c[index]),
//                             ],
//                           );
//                         })))

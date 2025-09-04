import 'package:dental_clinic/style/style_repo.dart';
import 'package:flutter/material.dart';


class PayItems extends StatelessWidget {
  final List<Map> dates;

  const PayItems({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    if (dates.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final payment = dates[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  payment['medicalCondition'] ?? 'N/A',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${payment['payment']}   S.P' ,
                                style: const TextStyle(fontSize: 18,color: StyleRepo.grey),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                payment['dateOfPayment'] ?? 'N/A',
                                style: const TextStyle(fontSize: 18,color: StyleRepo.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    } else {return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.teal[400],
              size: 180,
            ),
            Text(
              'No Payments Found...',
              style: TextStyle(
                  color: Colors.teal[400],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    }
  }
}





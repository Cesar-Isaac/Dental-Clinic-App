
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/pay_items.dart';
import '../layout/pay_book.dart';
import '../statemanagement/cubit.dart';
import '../statemanagement/state.dart';


// class NewPayment extends StatelessWidget {
//   const NewPayment({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppCubit, AppState>(
//       builder: (context, state) {
//         final patientId = (context.findAncestorWidgetOfExactType<PayBook>()?.patientId).toString();
//         var dates = AppCubit.get(context).addDateAndTimeVisit;
//         return PayItems(dates : dates);
//       },
//     );
//   }
// }

class NewPayment extends StatelessWidget {
  const NewPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final patientId =
        (context.findAncestorWidgetOfExactType<PayBook>()?.patientId)
            .toString();

        var allPayments = AppCubit.get(context).addDateAndTimeVisit;

        var filteredPayments = allPayments
            .where((element) => element['patientId'] == patientId)
            .toList();

        return PayItems(dates: filteredPayments);
      },
    );
  }
}
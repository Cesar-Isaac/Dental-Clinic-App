import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/dates_items.dart';
import '../statemanagement/cubit.dart';
import '../statemanagement/state.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var dates = AppCubit.get(context).archiveDates;
        return DatesItems(dates : dates);
      },
    );
  }
}

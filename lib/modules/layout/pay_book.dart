import 'package:dental_clinic/style/style_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../patient_information/newPayment.dart';
import '../statemanagement/cubit.dart';
import '../statemanagement/state.dart';

class PayBook extends StatefulWidget {
  final int patientId;

  PayBook({Key? key, required this.patientId}) : super(key: key);

  @override
  State<PayBook> createState() => _PayBookState();
}

class _PayBookState extends State<PayBook> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late TextEditingController paymentController;
  late TextEditingController dateOfPaymentController;
  late TextEditingController medicalConditionController;

  @override
  void initState() {
    super.initState();
    paymentController = TextEditingController();
    dateOfPaymentController = TextEditingController();
    medicalConditionController = TextEditingController();
  }

  @override
  void dispose() {
    paymentController.dispose();
    dateOfPaymentController.dispose();
    medicalConditionController.dispose();
    super.dispose();
  }

  void _showAddPaymentDialog(BuildContext context, AppCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Payment'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: medicalConditionController,
                  decoration: const InputDecoration(
                    hintText: 'Medical Condition',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null|| value.isEmpty) {
                      return 'Please enter medical condition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: paymentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Payment Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter payment amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dateOfPaymentController,
                  decoration: const InputDecoration(
                    hintText: 'Date of Payment',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3100),
                    );
                    if (pickedDate != null) {
                      dateOfPaymentController.text =DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date of payment';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  cubit.insertPayment(
                    payment: paymentController.text,
                    dateOfPayment: dateOfPaymentController.text,
                    medicalCondition: medicalConditionController.text,
                    patientId: widget.patientId.toString(), // تمرير patientId هنا
                  );
                  Navigator.of(context).pop();
                  paymentController.clear();
                  dateOfPaymentController.clear();
                  medicalConditionController.clear();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: StyleRepo.teal,
          appBar: AppBar(
            backgroundColor: StyleRepo.teal,
            title: const Text(
              'Pay Book',
              style:
              TextStyle(color: StyleRepo.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: StyleRepo.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child:  const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  NewPayment()

                ],

              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddPaymentDialog(context,cubit);
            },
            backgroundColor: StyleRepo.teal,
            child: const Icon(
              Icons.add,
              color: StyleRepo.white,
            ),
          ),
        );
      },
    );
  }
}
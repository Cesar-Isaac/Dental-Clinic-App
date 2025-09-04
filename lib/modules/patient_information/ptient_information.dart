import 'package:dental_clinic/modules/layout/pay_book.dart';
import 'package:dental_clinic/style/style_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../statemanagement/cubit.dart';
import '../statemanagement/state.dart';



class PatientInformation extends StatefulWidget {

  final String nameOfPatient;
  final String nameOfDoctor;
  final String numberOfPatient;
  final String ageOfPatient;
  final String timeOfVisit;
  final String dateOfVisit;
  final String currentlyDiseases;
  final int id;

  PatientInformation({
    super.key,
    required this.nameOfPatient,
    required this.nameOfDoctor,
    required this.numberOfPatient,
    required this.ageOfPatient,
    required this.timeOfVisit,
    required this.dateOfVisit,
    required this.currentlyDiseases,
    required this.id,
  });


  @override
  _PatientInformationState createState() => _PatientInformationState();
}

class _PatientInformationState extends State<PatientInformation> {
  late ValueNotifier<String> nameOfDoctorNotifier;
  late ValueNotifier<String> dateOfVisitNotifier;
  late ValueNotifier<String> timeOfVisitNotifier;
  late ValueNotifier<String> ageOfPatientNotifier;
  late ValueNotifier<String> numberOfPatientNotifier;
  late ValueNotifier<String> currentlyDiseasesNotifier;
  late TextEditingController nameOfDoctorController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController ageController;
  late TextEditingController numberController;
  late TextEditingController currentlyDiseasesController;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var paymentController = TextEditingController();
  var dateOfPaymentController = TextEditingController();
  var medicalConditionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    nameOfDoctorNotifier = ValueNotifier<String>(widget.nameOfDoctor);
    dateOfVisitNotifier = ValueNotifier<String>(widget.dateOfVisit);
    timeOfVisitNotifier = ValueNotifier<String>(widget.timeOfVisit);
    ageOfPatientNotifier = ValueNotifier<String>(widget.ageOfPatient);
    numberOfPatientNotifier = ValueNotifier<String>(widget.numberOfPatient);
    currentlyDiseasesNotifier = ValueNotifier<String>(widget.currentlyDiseases);

    nameOfDoctorController = TextEditingController(text: widget.nameOfDoctor);
    dateController = TextEditingController(text: widget.dateOfVisit);
    timeController = TextEditingController(text: widget.timeOfVisit);
    ageController = TextEditingController(text: widget.ageOfPatient);
    numberController = TextEditingController(text: widget.numberOfPatient);
    currentlyDiseasesController = TextEditingController(text: widget.currentlyDiseases);

    nameOfDoctorNotifier.addListener(() {
      nameOfDoctorController.text = nameOfDoctorNotifier.value;
    });
    dateOfVisitNotifier.addListener(() {
      dateController.text = dateOfVisitNotifier.value;
    });
    timeOfVisitNotifier.addListener(() {
      timeController.text = timeOfVisitNotifier.value;
    });
    ageOfPatientNotifier.addListener(() {
      ageController.text = ageOfPatientNotifier.value;
    });
    numberOfPatientNotifier.addListener(() {
      numberController.text = numberOfPatientNotifier.value;
    });
    currentlyDiseasesNotifier.addListener(() {
      currentlyDiseasesController.text = currentlyDiseasesNotifier.value;
    });
  }

  @override
  void dispose() {
    nameOfDoctorNotifier.dispose();
    dateOfVisitNotifier.dispose();
    timeOfVisitNotifier.dispose();
    ageOfPatientNotifier.dispose();
    numberOfPatientNotifier.dispose();
    currentlyDiseasesNotifier.dispose();

    nameOfDoctorController.dispose();
    dateController.dispose();
    timeController.dispose();
    ageController.dispose();
    numberController.dispose();
    currentlyDiseasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, state) => Scaffold(
        backgroundColor: StyleRepo.teal,
        appBar: AppBar(
          backgroundColor: StyleRepo.teal,
          title: const Text(
            'Patient Information',
            style: TextStyle(color: StyleRepo.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: StyleRepo.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.person,
                  color: StyleRepo.teal,
                  size: 150,
                ),
              ),
              _buildInfoRow('Name:', widget.nameOfPatient),
              _buildNameOfDoctorRow(context, nameOfDoctorNotifier, nameOfDoctorController),
              _buildPhoneRow(context, numberOfPatientNotifier, numberController),
              _buildAgeRow(context, ageOfPatientNotifier, ageController),
              _buildDateOfVisitRow(context, dateOfVisitNotifier, dateController),
              _buildTimeOfVisitRow(context, timeOfVisitNotifier, timeController),
              _buildCurrentlyDiseasesRow(context, currentlyDiseasesNotifier, currentlyDiseasesController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                _buildSaveButton(
                    context,
                    nameOfDoctorNotifier,
                    dateOfVisitNotifier,
                    timeOfVisitNotifier,
                    ageOfPatientNotifier,
                    numberOfPatientNotifier,
                    currentlyDiseasesNotifier,
                    cubit),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all(StyleRepo.teal),
                    side: const WidgetStatePropertyAll(
                        BorderSide(color: StyleRepo.teal)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                               PayBook(patientId: widget.id,)
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Payments',
                      style: TextStyle(color: StyleRepo.white),
                    ),
                  ),
                ),

              ],

              ),

            ],
          ),
        ),

      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: Text(value,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfVisitRow(
      BuildContext context,
      ValueNotifier<String> dateOfVisitNotifier,
      TextEditingController dateController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Text(
            'Date of Visit:',
            style: TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(3000),
                );
                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  dateOfVisitNotifier.value = formattedDate;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfVisitRow(
      BuildContext context, ValueNotifier<String> timeOfVisitNotifier, TextEditingController timeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Text(
            'Time of Visit:',
            style: TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: TextFormField(
              controller: timeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  timeOfVisitNotifier.value = pickedTime.format(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(
      BuildContext context,
      ValueNotifier<String> numberOfPatientNotifier,
      TextEditingController numberController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Text(
            'Phone:',
            style: TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: numberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                numberOfPatientNotifier.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAgeRow(
      BuildContext context,
      ValueNotifier<String> ageOfPatientNotifier,TextEditingController ageController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:Row(
          children: [
            const Text(
              'Age:',
              style: TextStyle(color: StyleRepo.teal, fontSize: 18),
            ),
            const SizedBox(width: 70),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: ageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ageOfPatientNotifier.value = value;
                },
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildNameOfDoctorRow(
      BuildContext context,
      ValueNotifier<String> nameOfDoctorNotifier,TextEditingController nameOfDoctorController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:Row(
        children: [
          const Text(
            'Doctor:',
            style: TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: nameOfDoctorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                nameOfDoctorNotifier.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCurrentlyDiseasesRow(
      BuildContext context,
      ValueNotifier<String> currentlyDiseasesNotifier,TextEditingController currentlyDiseasesController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:Row(
        children: [
          const Text(
            'Currently Diseases:',
            style: TextStyle(color: StyleRepo.teal, fontSize: 18),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: currentlyDiseasesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                currentlyDiseasesNotifier.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSaveButton(
      BuildContext context,
      ValueNotifier<String> nameOfDoctorNotifier,
      ValueNotifier<String> dateOfVisitNotifier,
      ValueNotifier<String> timeOfVisitNotifier,
      ValueNotifier<String> ageOfPatientNotifier,
      ValueNotifier<String> numberOfPatientNotifier,
      ValueNotifier<String> currentlyDiseasesNotifier,
      AppCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            cubit.updateDate(
                id: widget.id,
                nameOfDoctor: nameOfDoctorNotifier.value,
                dateOfVisit: dateOfVisitNotifier.value,
                timeOfVisit: timeOfVisitNotifier.value,
                ageOfPatient: ageOfPatientNotifier.value,
                numberOfPatient: numberOfPatientNotifier.value,
                currentlyDiseases: currentlyDiseasesNotifier.value,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data Updated Successfully'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: StyleRepo.teal,
          ),
          child: const Text(
            'Save',
            style: TextStyle(color: StyleRepo.white),
          ),
        ),
      ),
    );
  }
}

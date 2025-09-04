import 'package:dental_clinic/modules/archive_dates/archive.dart';
import 'package:dental_clinic/modules/new_dates/new.dart';
import 'package:dental_clinic/modules/statemanagement/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../shared/dates_items.dart';


class AppCubit extends Cubit<AppState>{
  AppCubit(): super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<String> title = ['Dates','Archive',];
  List<Widget> screen = [
    const NewDates(),
    const ArchiveScreen(),

  ];

  int currentIndex = 0;
  late Database database;
  List<Map<String, dynamic>> dates = [];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppCurrentState());
  }

  List<Map> newDates = [];
  List<Map> archiveDates = [];
  List<Map> doneDates = [];
  List<Map> returnDate = [];
  List<Map> addDateAndTimeVisit = [];
  List<Map> payments = [];





  void createDataBase() {
    openDatabase('clinic.db', version: 1, onCreate: (database, version) {debugPrint('dataBase Created');
    database
        .execute(
        'CREATE TABLE dates(id INTEGER PRIMARY KEY, patientId TEXT, nameOfPatient TEXT,'
            'nameOfDoctor TEXT,ageOfPatient TEXT,numberOfPatient TEXT,dateOfVisit TEXT,timeOfVisit TEXT,'
            'medicalCondition TEXT,currentlyDiseases TEXT,payment TEXT,dateOfPayment TEXT,status TEXT )')
        .then((value) {
      debugPrint('Table Created');
    }).catchError((error) {
      debugPrint('Error When Creating ${error.toString()}');
    });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      debugPrint('dataBase Opened');
    }).then((value) {
      database = value;
      emit(AppCreatedDataBase());
    });
  }






  void getDataFromDataBase(database){
    newDates = [];
    doneDates = [];
    archiveDates = [];
    returnDate = [];
    addDateAndTimeVisit = [];
    database.rawQuery('SELECT * FROM dates').then((value){
      for(var element in value){
        if(element['status'] == 'new'){
          newDates.add(element);
        }else if(element['status'] == 'archive'){
          archiveDates.add(element);
        }else if(element['status'] == 'done'){
          doneDates.add(element);
        }else if(element['status'] == 'returnDate'){
          newDates.add(element);
        }else if(element['status'] == 'newTimeAndDate'){
          addDateAndTimeVisit.add(element);
        }
      }
      emit(AppGetDataBase());
    });
  }



  void insertDataBase({
    required String nameOfPatient,
    required String nameOfDoctor,
    required String ageOfPatient,
    required String numberOfPatient,
    required String timeOfVisit,
    required String dateOfVisit,
    required String currentlyDiseases,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO dates (nameOfPatient, nameOfDoctor, ageOfPatient, numberOfPatient,timeOfVisit,dateOfVisit,currentlyDiseases, status) VALUES (?, ?, ?, ?, ?, ?, ? ,?)',
        [
          nameOfPatient,
          nameOfDoctor,
          ageOfPatient,
          numberOfPatient,
          timeOfVisit,
          dateOfVisit,
          currentlyDiseases,
          "new"
        ],
      ).then((value) {
        debugPrint('$value Insert Done');
        emit(AppInsertDataBase());
        getDataFromDataBase(database);
      }).catchError((error) {
        debugPrint('Error When Insert New Date ${error.toString()}');
      });
    });
  }

  void insertPayment({
    required String payment,
    required String dateOfPayment,
    required String medicalCondition,
    required String patientId,
  }) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO dates(payment,dateOfPayment,medicalCondition,patientId,status) VALUES(?,?,?,?,?)',
        [payment, dateOfPayment, medicalCondition, patientId, 'newTimeAndDate'], 
      ).then((value) {
        debugPrint('$value Insert Payment Done');
        emit(AppInsertPayment());
        getDataFromDataBase(database);
      }).catchError((error) {
        debugPrint('Error When Insert New Payment ${error.toString()}');
      });
    });
  }






  bool isBottomSheet = false;
  void changeBottomSheetState ({required bool isShow}){
    isBottomSheet = isShow ;
    emit(AppChangeBottomSheet());
  }

  bool isBottomSheet1 = false;

  void changeBottomSheetState1 ({required bool isShow1}){
    isBottomSheet1 = isShow1 ;
    emit(AppChangeBottomSheet1());
  }



  void updateData({required int id, required String status}) {
    database.rawUpdate('UPDATE dates SET status = ? WHERE id = ? ',
        [status, id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataBase());
    });
  }

  void deleteData({required id}) {
    database.rawDelete('DELETE FROM dates WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(DeleteDataBase());
    });
  }

  void updateDate({
    required int id,
    required String nameOfDoctor,
    required String dateOfVisit,
    required String timeOfVisit,
    required String ageOfPatient,
    required String numberOfPatient,
    required String currentlyDiseases,

  }) {
    database.rawUpdate(
        'UPDATE dates SET nameOfDoctor = ?, dateOfVisit = ?, timeOfVisit = ?, ageOfPatient = ?,numberOfPatient = ?, currentlyDiseases = ? WHERE id = ?',
        [nameOfDoctor,dateOfVisit, timeOfVisit, ageOfPatient, numberOfPatient , currentlyDiseases , id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataBase());
    });
  }
  void updatePayment({
    required int id,
    required String payment,
    required String dateOfPayment,
    required String medicalCondition,
  }) async {
    try {
      await database.rawUpdate(
        'UPDATE dates SET payment = ?, dateOfPayment = ?, medicalCondition = ?WHERE id = ?',
        [payment, dateOfPayment, medicalCondition, id],
      );
      getDataFromDataBase(database);
      emit(AppUpdateDataBase());
      debugPrint('Payment updated successfully for id: $id');
    } catch (e) {
      debugPrint('Error updating payment: $e');
      emit(AppUpdateDataBaseError());
    }
  }


Future<List<Map>> getDataByPatientName(String nameOfPatient) async {
  try {
    final List<Map> result = await database.rawQuery(
      'SELECT * FROM dates WHERE nameOfPatient = ?',
      [nameOfPatient],
    );

    if (result.isNotEmpty) {
      debugPrint('Data fetched successfully: $result');
    } else {
      debugPrint('No data found for patient: $nameOfPatient');
    }

    return result;
  } catch (error) {
    debugPrint('Error fetching data for patient $nameOfPatient: ${error.toString()}');
    return [];
  }
}


FutureBuilder<List<Map>> buildPatientCard(String patientName) {
  return FutureBuilder<List<Map>>(
    future: getDataByPatientName(patientName),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data found for the given patient.'));
      } else {
        return DatesItems(dates: snapshot.data!);
      }
    },
  );
}


}
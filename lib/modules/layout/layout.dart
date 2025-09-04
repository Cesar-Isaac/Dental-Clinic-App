import 'package:dental_clinic/modules/statemanagement/state.dart';
import 'package:dental_clinic/style/style_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../search/Search.dart';
import '../statemanagement/cubit.dart';


class LayoutScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameOfPatientController = TextEditingController();
  var nameOfDoctorController = TextEditingController();
  var numberOfPatientController = TextEditingController();
  var ageOfPatientController = TextEditingController();
  var dateOfVisitController = TextEditingController();
  var timeOfVisitController = TextEditingController();
  var currentlyDiseasesController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => Scaffold(
        key: scaffoldKey,
        backgroundColor: StyleRepo.teal,
        appBar: AppBar(
          backgroundColor: StyleRepo.teal,
          title: Text(
            cubit.title[cubit.currentIndex],
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: StyleRepo.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchData(cubit.database), // تمرير البيانات إلى SearchData
                );
              },
              icon: const Icon(Icons.search, color: StyleRepo.white),
            ),
          ],


        ),
        body: Container(
          decoration: const BoxDecoration(
            color: StyleRepo.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
          ),
          child: Column(
            children: [
              cubit.screen[cubit.currentIndex],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 20,
          backgroundColor: StyleRepo.teal,
          onPressed: () {
            if(cubit.isBottomSheet)
            {
              if(formKey.currentState!.validate()){
                cubit.insertDataBase(
                  nameOfPatient: nameOfPatientController.text,
                  nameOfDoctor: nameOfDoctorController.text,
                  numberOfPatient: numberOfPatientController.text,
                  currentlyDiseases: currentlyDiseasesController.text,
                  ageOfPatient: ageOfPatientController.text,
                  timeOfVisit: timeOfVisitController.text,
                  dateOfVisit: dateOfVisitController.text,

                );
                Navigator.pop(context);
                nameOfPatientController.clear();
                nameOfDoctorController.clear();
                numberOfPatientController.clear();
                currentlyDiseasesController.clear();
                ageOfPatientController.clear();
                timeOfVisitController.clear();
                dateOfVisitController.clear();
              }
            }
            else{
              scaffoldKey.currentState!.showBottomSheet((context) => Container(
                color: StyleRepo.white,
                height: 800,
                padding: const EdgeInsets.all(20),
                child:
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Name of Patient must not be Empty ";
                          }
                          return null;
                        },
                        cursorColor:Colors.teal[400],
                        controller:nameOfPatientController ,
                        decoration: const InputDecoration(
                          hintText: 'Name of Patient',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Name of Doctor must not be Empty ";
                          }
                          return null;
                        },
                        cursorColor:Colors.teal[400],
                        controller:nameOfDoctorController ,
                        decoration: const InputDecoration(
                          hintText: 'Name of Doctor',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Number of Patient must not be Empty ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        cursorColor:Colors.teal[400],
                        controller:numberOfPatientController ,
                        decoration: const InputDecoration(
                          hintText: 'Number of Patient',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Age of Patient must not be Empty ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        cursorColor:Colors.teal[400],
                        controller:ageOfPatientController ,
                        decoration: const InputDecoration(
                          hintText: 'Age of Patient',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        onTap: (){
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                            timeOfVisitController.text = value!.format(context).toString();
                          });
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return "Time of Visit must not be Empty ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor:Colors.teal[400],
                        controller:timeOfVisitController ,
                        decoration: const InputDecoration(
                          hintText: 'Time of Visit',
                          hintStyle: TextStyle(color: Colors.grey),

                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        onTap: (){
                          showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(3000)).then((value){
                            dateOfVisitController.text = DateFormat.yMMMd().format(value!);
                          });

                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return "Date of Visit must not be Empty ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor:Colors.teal[400],
                        controller:dateOfVisitController ,
                        decoration: const InputDecoration(
                          hintText: 'Date of Visit',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10,),

                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Currently Diseases must not be Empty ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor:Colors.teal[400],
                        controller:currentlyDiseasesController ,
                        decoration: const InputDecoration(
                          hintText: 'Currently Diseases',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),

                    ],
                  ),
                ),
              )).closed.then((value){
                cubit.changeBottomSheetState(isShow: false);
              });
            }
            cubit.changeBottomSheetState(isShow: true);
          },

          child:cubit.isBottomSheet?const Icon(Icons.check,color:Colors.white) :const Icon(Icons.add,color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.teal[400],
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items:   const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archive"),
            ]
        ),
      ),
    );
  }
}


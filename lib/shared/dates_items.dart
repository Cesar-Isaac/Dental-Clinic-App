import 'package:flutter/material.dart';

import '../modules/patient_information/ptient_information.dart';
import '../modules/statemanagement/cubit.dart';
import '../style/style_repo.dart';



class DatesItems extends StatelessWidget {
  final List<Map> dates;
   DatesItems({super.key,required this.dates}){
     showAction = ValueNotifier(List.generate(dates.length, (index) => false));
   }
  late final ValueNotifier<List<bool>> showAction;
  @override
  Widget build(BuildContext context) {
    if(dates.isNotEmpty){
      return  Expanded(
        child: ListView.builder(
          itemCount: dates.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding:  const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ValueListenableBuilder<List<bool>>(
                          valueListenable: showAction,
                          builder: (context, value, child) => ListTile(
                            onLongPress: () {
                              value[index] = !value[index];
                              showAction.value = List.from(value);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => PatientInformation(
                                    nameOfPatient: dates[index]['nameOfPatient'],
                                    nameOfDoctor: dates[index]['nameOfDoctor'],
                                    numberOfPatient: dates[index]['numberOfPatient'],
                                    ageOfPatient: dates[index]['ageOfPatient'],
                                    currentlyDiseases: dates[index]['currentlyDiseases'],
                                    timeOfVisit: dates[index]['timeOfVisit'],
                                    dateOfVisit: dates[index]['dateOfVisit'],
                                    id: dates[index]['id'],
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.teal[400],
                              child: const Icon(Icons.person, color: Colors.white, size: 50),
                            ),
                            title:  Text(
                              dates[index]['nameOfPatient'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle:  Text(dates[index]['nameOfDoctor']),
                          ),
                        ),
                        // ValueListenableBuilder<List<bool>>(
                        //   valueListenable: showAction,
                        //   builder: (context, value, child) {
                        //     return value[index]
                        //         ? Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         IconButton(
                        //           onPressed: () {
                        //             AppCubit.get(context).deleteData(id: dates[index]['id']);
                        //           },
                        //           icon: const Icon(Icons.delete_outline, color: StyleRepo.redAccent),
                        //         ),
                        //         IconButton(
                        //           onPressed: () {
                        //             showDialog(
                        //                 context: context,
                        //                 builder: (context) => AlertDialog(
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius: BorderRadius.circular(20)
                        //                   ),
                        //                   title: const Text('Warning'),
                        //                   titleTextStyle: const TextStyle(color: StyleRepo.redAccent),
                        //                   content: const Text('Are you sure you want to Delete this Date ?'),
                        //                  actions: [
                        //                    TextButton(
                        //                        onPressed: (){
                        //                          AppCubit.get(context).updateData(id: dates[index]['id'], status: 'archive');
                        //                        },
                        //                        child: const Text('ok')),
                        //                    TextButton(
                        //                        onPressed: (){
                        //                          Navigator.pop(context);
                        //                        },
                        //                        child: const Text('Cancel'))
                        //                  ],
                        //                 ));
                        //
                        //           },
                        //           icon: const Icon(Icons.archive,color: StyleRepo.black,),
                        //         ),
                        //         IconButton(
                        //           onPressed: () {
                        //             AppCubit.get(context).updateData(id: dates[index]['id'], status: 'returnDate');
                        //           },
                        //           icon: const Icon(Icons.keyboard_return_outlined,color: StyleRepo.deepPurpleAccent,),
                        //         ),
                        //       ],
                        //     )
                        //         : const SizedBox.shrink();
                        //   },
                        // ),
                        ValueListenableBuilder<List<bool>>(
                          valueListenable: showAction,
                          builder: (context, value, child) {
                            // Get the current page index from the AppCubit
                            int currentIndex = AppCubit.get(context).currentIndex;

                            return value[index]
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: const Text('Warning'),
                                        titleTextStyle: const TextStyle(color: StyleRepo.redAccent),
                                        content: const Text('Are you sure you want to Delete this Date ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              AppCubit.get(context).deleteData(id: dates[index]['id']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    );

                                  },
                                  icon: const Icon(Icons.delete_outline, color: StyleRepo.redAccent),
                                ),
                                // Show archive icon only if not in the Archive screen
                                if (currentIndex != 1)
                                  IconButton(
                                    onPressed: () {
                                      AppCubit.get(context).updateData(id: dates[index]['id'], status: 'archive');

                                    },
                                    icon: const Icon(Icons.archive, color: StyleRepo.black),
                                  ),
                                // Show return icon only if not in the main layout screen
                                if (currentIndex != 0)
                                  IconButton(
                                    onPressed: () {
                                      AppCubit.get(context).updateData(id: dates[index]['id'], status: 'returnDate');
                                    },
                                    icon: const Icon(Icons.keyboard_return_outlined, color: StyleRepo.deepPurpleAccent),
                                  ),
                              ],
                            )
                                : const SizedBox.shrink();
                          },
                        ),
                        const Divider(thickness: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16.00),
                          child:
                          Row(children: [
                            const Icon(Icons.call_outlined,color: StyleRepo.black,),
                            const SizedBox(width: 20,),
                            Text(dates[index]['numberOfPatient'])
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16.00),
                          child:
                          Row(children: [
                            const Icon(Icons.person_2_outlined,color: StyleRepo.teal,),
                            const SizedBox(width: 20,),
                            Text('${dates[index]['ageOfPatient']} years old'),
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16.00),
                          child:
                          Row(children: [
                            const Icon(Icons.calendar_today_outlined,color: StyleRepo.black,),
                            const SizedBox(width: 20,),
                            Text('${dates[index]['dateOfVisit']} , at'),
                            const SizedBox(width: 10,),
                            Text(dates[index]['timeOfVisit']),
                          ],),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }else {
      return Expanded(
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit,color: Colors.teal[400],size: 180,),
            Text('No Dates Found...',style: TextStyle(color: Colors.teal[400],fontSize: 20,fontWeight: FontWeight.bold),)
          ],)),
      );
    }
  }
}

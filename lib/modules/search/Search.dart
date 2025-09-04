import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../patient_information/ptient_information.dart';


class SearchData extends SearchDelegate {
  final Database database;

  SearchData(this.database);

  Future<List<Map>> getDataByPatientName(String nameOfPatient) async {
    try {
      final List<Map> result = await database.rawQuery(
        'SELECT * FROM dates WHERE nameOfPatient LIKE ?',
        ['%$nameOfPatient%'],
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

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map>>(
      future: getDataByPatientName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found for the given patient.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final patient = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal[400],
                    child: const Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  title: Text(
                    patient['nameOfPatient'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(patient['nameOfDoctor']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PatientInformation(
                          nameOfPatient: patient['nameOfPatient'],
                          nameOfDoctor: patient['nameOfDoctor'],
                          numberOfPatient: patient['numberOfPatient'],
                          ageOfPatient: patient['ageOfPatient'],
                          currentlyDiseases: patient['currentlyDiseases'],
                          timeOfVisit: patient['timeOfVisit'],
                          dateOfVisit: patient['dateOfVisit'],
                          id: patient['id'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map>>(
      future: getDataByPatientName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suggestions available.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final patient = snapshot.data![index];
              return ListTile(
                title: Text(patient['nameOfPatient']),
                onTap: () {
                  query = patient['nameOfPatient'];
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}

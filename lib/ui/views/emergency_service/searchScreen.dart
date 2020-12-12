// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:help/ui/views/emergency_service/emergency_model.dart';

// import 'emergency_controller.dart';

// class SearchEmergency extends SearchDelegate {
//   final List<Features> healthCentersList;

//   String selectedResult;

//   SearchEmergency({this.healthCentersList});
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.close),
//           onPressed: () {
//             query = '';
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pop(context);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text(selectedResult),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Features> suggestionList = [];
//     return ListView.builder(itemBuilder: (context, index) {
//       return ListTile(
//         leading: SvgPicture.asset(
//           'assets/svgs/hospitalization.svg',
//           width: 36,
//         ),
//         onTap: () {
//           selectedResult = suggestionList[index].toString();
//           showResults(context);
//         },
//         isThreeLine: true,
//         title: Text(suggestionList[index].properties.name),
//         subtitle: Text(
//           (suggestionList[index].properties.wardName ??
//               '' + suggestionList[index].properties.lgaName ??
//               '' + suggestionList[index].properties.stateName ??
//               ''),
//         ),
//         trailing: RaisedButton(
//             onPressed: () => EmergencyController.openMap(
//                 suggestionList[index].properties.latitude,
//                 suggestionList[index].properties.longitude),
//             child: Text('Open Location')),
//       );
//     });
//   }
// }

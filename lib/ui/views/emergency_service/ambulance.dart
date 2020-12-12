import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:help/ui/views/emergency_service/emergency_controller.dart';
import 'package:help/ui/views/emergency_service/emergency_model.dart';
import 'package:search_page/search_page.dart';

class EmergencysCenters extends StatefulWidget {
  @override
  _EmergencysCentersState createState() => _EmergencysCentersState();
}

class _EmergencysCentersState extends State<EmergencysCenters> {
  EmergencyController emergencyController = EmergencyController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kBgColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: kdarktGrey,
                ),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchPage<HealthCenters>(
                        items: emergencyController.healthCenterList,
                        itemEndsWith: true,
                        barTheme: ThemeData(
                          primaryColor: klightGrey,
                        ),
                        itemStartsWith: true,
                        searchLabel: 'Search By Location',
                        failure: Center(
                          child: Text('Couldnt Fetch Data for this Area'),
                        ),
                        builder: (centers) => ListTile(
                          leading: SvgPicture.asset(
                            'assets/svgs/hospitalization.svg',
                            width: 36,
                          ),
                          isThreeLine: true,
                          title: Text(centers.properties.name),
                          subtitle: Text(
                            (centers.properties.wardName ??
                                '' + centers.properties.lgaName ??
                                '' + centers.properties.stateName ??
                                ''),
                          ),
                          trailing: RaisedButton(
                              elevation: 0,
                              onPressed: () => EmergencyController.openMap(
                                  centers.properties.latitude,
                                  centers.properties.longitude),
                              child: Text('Open Location')),
                        ),
                        filter: (HealthCenters centers) => [
                          centers.properties.name.toString() ?? '',
                          centers.properties.lgaName.toString() ?? '',
                          centers.properties.stateName.toString() ?? '',
                        ],
                      ));
                })
          ],
          backgroundColor: kWhite,
          elevation: 3,
        ),
        backgroundColor: kWhite,
        body: GetBuilder<EmergencyController>(
          builder: (getController) {
            return FutureBuilder<List<HealthCenters>>(
                future: emergencyController.getHealthCenters(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('i tried accessing2');
                    return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data[index].properties;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                'assets/svgs/hospitalization.svg',
                                width: 36,
                              ),
                              isThreeLine: true,
                              title: Text(data.name),
                              subtitle: Text(
                                (data.wardName ??
                                    '' + data.lgaName ??
                                    '' + data.stateName ??
                                    ''),
                              ),
                              trailing: RaisedButton(
                                  elevation: 0,
                                  onPressed: () => EmergencyController.openMap(
                                      data.latitude, data.longitude),
                                  child: Text('Open Location')),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kBgColor),
                  ));
                });
          },
        ));
  }
}

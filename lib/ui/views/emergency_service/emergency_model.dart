import 'dart:convert';

List<HealthCenters> healthCentersFromJson(String str) => List<HealthCenters>.from(json.decode(str).map((x) => HealthCenters.fromJson(x)));

String healthCentersToJson(List<HealthCenters> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HealthCenters {
    HealthCenters({
        this.geometry,
        this.geometryName,
        this.id,
        this.properties,
        this.type,
    });

    Geometry geometry;
    String geometryName;
    String id;
    Properties properties;
    String type;

    factory HealthCenters.fromJson(Map<String, dynamic> json) => HealthCenters(
        geometry: Geometry.fromJson(json["geometry"]),
        geometryName: json["geometry_name"],
        id: json["id"],
        properties: Properties.fromJson(json["properties"]),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
        "geometry_name": geometryName,
        "id": id,
        "properties": properties.toJson(),
        "type": type,
    };
}

class Geometry {
    Geometry({
        this.coordinates,
        this.type,
    });

    List<double> coordinates;
    String type;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}

class Properties {
    Properties({
        this.category,
        this.cceAvailable,
        this.functionalStatus,
        this.globalId,
        this.latitude,
        this.lgaCode,
        this.lgaName,
        this.longitude,
        this.name,
        this.ownership,
        this.riServiceStatus,
        this.source,
        this.stateCode,
        this.stateName,
        this.timestamp,
        this.type,
        this.wardCode,
        this.wardName,
    });

    String category;
    String cceAvailable;
    String functionalStatus;
    String globalId;
    double latitude;
    String lgaCode;
    String lgaName;
    double longitude;
    String name;
    String ownership;
    String riServiceStatus;
    String source;
    String stateCode;
    String stateName;
    DateTime timestamp;
    String type;
    String wardCode;
    String wardName;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        category: json["category"],
        cceAvailable: json["cce_available"],
        functionalStatus: json["functional_status"],
        globalId: json["global_id"],
        latitude: json["latitude"].toDouble(),
        lgaCode: json["lga_code"],
        lgaName: json["lga_name"],
        longitude: json["longitude"].toDouble(),
        name: json["name"],
        ownership: json["ownership"],
        riServiceStatus: json["ri_service_status"],
        source: json["source"],
        stateCode: json["state_code"],
        stateName: json["state_name"],
        timestamp: DateTime.parse(json["timestamp"]),
        type: json["type"],
        wardCode: json["ward_code"],
        wardName: json["ward_name"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "cce_available": cceAvailable,
        "functional_status": functionalStatus,
        "global_id": globalId,
        "latitude": latitude,
        "lga_code": lgaCode,
        "lga_name": lgaName,
        "longitude": longitude,
        "name": name,
        "ownership": ownership,
        "ri_service_status": riServiceStatus,
        "source": source,
        "state_code": stateCode,
        "state_name": stateName,
        "timestamp": timestamp.toIso8601String(),
        "type": type,
        "ward_code": wardCode,
        "ward_name": wardName,
    };
}

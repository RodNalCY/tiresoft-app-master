// To parse this JSON data, do
//
//     final vehiculoData = vehiculoDataFromJson(jsonString);
import 'dart:convert';

VehiculoData vehiculoDataFromJson(String str) =>
    VehiculoData.fromJson(json.decode(str));

String vehiculoDataToJson(VehiculoData data) => json.encode(data.toJson());

class VehiculoData {
  VehiculoData({
    required this.success,
  });

  final Success success;

  factory VehiculoData.fromJson(Map<String, dynamic> json) => VehiculoData(
        success: Success.fromJson(json["success"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success.toJson(),
      };
}

class Success {
  Success({
    required this.currentPage,
    required this.totalRegistros,
    required this.lastPage,
    required this.datos,
  });

  final String currentPage;
  final int totalRegistros;
  final int lastPage;
  final List<Vehiculo> datos;

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        currentPage: json["current_page"],
        totalRegistros: json["total_registros"],
        lastPage: json["last_page"],
        datos:
            List<Vehiculo>.from(json["datos"].map((x) => Vehiculo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "total_registros": totalRegistros,
        "datos": List<dynamic>.from(datos.map((x) => x.toJson())),
      };
}

class Vehiculo {
  final String fechaInspeccion;
  final String kmInspeccion;
  final int idVehiculo;
  final String placa;
  final String marcavehiculo;
  final String tipovehiculo;
  final List<Detalle> detalle;

  Vehiculo({
    required this.fechaInspeccion,
    required this.kmInspeccion,
    required this.idVehiculo,
    required this.placa,
    required this.marcavehiculo,
    required this.tipovehiculo,
    required this.detalle,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
        fechaInspeccion: json["fecha_inspeccion"],
        kmInspeccion: json["km_inspeccion"],
        idVehiculo: json["id_vehiculo"],
        placa: json["placa"],
        marcavehiculo: json["marcavehiculo"],
        tipovehiculo: json["tipovehiculo"],
        detalle:
            List<Detalle>.from(json["detalle"].map((x) => Detalle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fecha_inspeccion": fechaInspeccion,
        "km_inspeccion": kmInspeccion,
        "id_vehiculo": idVehiculo,
        "placa": placa,
        "marcavehiculo": marcavehiculo,
        "tipovehiculo": tipovehiculo,
        "detalle": List<dynamic>.from(detalle.map((x) => x.toJson())),
      };
}

class Detalle {
  final String fechaInspeccion;
  final String kmInspeccion;
  final int idVehiculo;
  final String placa;
  final String marcavehiculo;
  final String tipovehiculo;
  final String posicion;
  final String marcaneumatico;
  final String medidaneumatico;
  final String modeloneumatico;
  final String disenioneumatico;
  final String razonSocial;
  final String numSerie;
  final String valvula;
  final String accesibilidad;
  final String malogrado;
  final String presionactual;
  final String presionRecomendada;
  final String remanenteOriginal;
  final String exterior;
  final String medio;
  final String interior;
  final String remReencauche;
  final String remProximo;
  final String estadoneumatico;
  final String nskMinimo;
  final String recomendacion;
  final String estadopresion;

  Detalle({
    required this.fechaInspeccion,
    required this.kmInspeccion,
    required this.idVehiculo,
    required this.placa,
    required this.marcavehiculo,
    required this.tipovehiculo,
    required this.posicion,
    required this.marcaneumatico,
    required this.medidaneumatico,
    required this.modeloneumatico,
    required this.disenioneumatico,
    required this.razonSocial,
    required this.numSerie,
    required this.valvula,
    required this.accesibilidad,
    required this.malogrado,
    required this.presionactual,
    required this.presionRecomendada,
    required this.remanenteOriginal,
    required this.exterior,
    required this.medio,
    required this.interior,
    required this.remReencauche,
    required this.remProximo,
    required this.estadoneumatico,
    required this.nskMinimo,
    required this.recomendacion,
    required this.estadopresion,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        fechaInspeccion: json["fecha_inspeccion"],
        kmInspeccion: json["km_inspeccion"],
        idVehiculo: json["id_vehiculo"],
        placa: json["placa"],
        marcavehiculo: json["marcavehiculo"],
        tipovehiculo: json["tipovehiculo"],
        posicion: json["posicion"].toString(),
        marcaneumatico: json["marcaneumatico"],
        medidaneumatico: json["medidaneumatico"],
        modeloneumatico: json["modeloneumatico"],
        disenioneumatico: json["disenioneumatico"],
        razonSocial: json["razon_social"],
        numSerie: json["num_serie"],
        valvula: json["valvula"],
        accesibilidad: json["accesibilidad"],
        malogrado: json["malogrado"],
        presionactual: json["presionactual"].toString(),
        presionRecomendada: json["presion_recomendada"].toString(),
        remanenteOriginal: json["remanente_original"].toString(),
        exterior: json["exterior"],
        medio: json["medio"],
        interior: json["interior"],
        remReencauche: json["rem_reencauche"],
        remProximo: json["rem_proximo"],
        estadoneumatico: json["estadoneumatico"],
        nskMinimo: json["nsk_minimo"],
        recomendacion: json["recomendacion"],
        estadopresion: json["estadopresion"],
      );

  Map<String, dynamic> toJson() => {
        "fecha_inspeccion": fechaInspeccion,
        "km_inspeccion": kmInspeccion,
        "id_vehiculo": idVehiculo,
        "placa": placa,
        "marcavehiculo": marcavehiculo,
        "tipovehiculo": tipovehiculo,
        "posicion": posicion,
        "marcaneumatico": marcaneumatico,
        "medidaneumatico": medidaneumatico,
        "modeloneumatico": modeloneumatico,
        "disenioneumatico": disenioneumatico,
        "razon_social": razonSocial,
        "num_serie": numSerie,
        "valvula": valvula,
        "accesibilidad": accesibilidad,
        "malogrado": malogrado,
        "presionactual": presionactual,
        "presion_recomendada": presionRecomendada,
        "remanente_original": remanenteOriginal,
        "exterior": exterior,
        "medio": medio,
        "interior": interior,
        "rem_reencauche": remReencauche,
        "rem_proximo": remProximo,
        "estadoneumatico": estadoneumatico,
        "nsk_minimo": nskMinimo,
        "recomendacion": recomendacion,
        "estadopresion": estadopresion,
      };
}

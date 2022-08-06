class Inspeccion {
  int i_id;
  String i_identificador;
  String i_placa;
  String i_km_inspeccion;
  String i_fecha_inspeccion;
  String i_cod_inspeccion;
  String i_cod_vehiculo;
  String i_vh_tipo;
  String i_vh_marca;
  String i_vh_modelo;
  String i_vh_configuracion;

  Inspeccion(
      this.i_id,
      this.i_identificador,
      this.i_placa,
      this.i_km_inspeccion,
      this.i_fecha_inspeccion,
      this.i_cod_inspeccion,
      this.i_cod_vehiculo,
      this.i_vh_tipo,
      this.i_vh_marca,
      this.i_vh_modelo,
      this.i_vh_configuracion) {
    this.i_id = i_id;
    this.i_identificador = i_identificador;
    this.i_placa = i_placa;
    this.i_km_inspeccion = i_km_inspeccion;
    this.i_fecha_inspeccion = i_fecha_inspeccion;
    this.i_cod_inspeccion = i_cod_inspeccion;
    this.i_cod_vehiculo = i_cod_vehiculo;
    this.i_vh_tipo = i_vh_tipo;
    this.i_vh_marca = i_vh_marca;
    this.i_vh_modelo = i_vh_modelo;
    this.i_vh_configuracion = i_vh_configuracion;
  }
}

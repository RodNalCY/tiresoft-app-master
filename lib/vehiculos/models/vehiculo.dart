class Vehiculo {
  int v_id;
  String v_placa;
  String v_codigo;
  String v_tipo;
  String v_marca;
  String v_modelo;
  String v_configuracion;
  String v_aplicacion;
  String v_planta;
  String v_estado;
  String v_f_registro;

  Vehiculo(
      this.v_id,
      this.v_placa,
      this.v_codigo,
      this.v_tipo,
      this.v_marca,
      this.v_modelo,
      this.v_configuracion,
      this.v_aplicacion,
      this.v_planta,
      this.v_estado,
      this.v_f_registro) {
    this.v_id = v_id;
    this.v_placa = v_placa;
    this.v_codigo = v_codigo;
    this.v_tipo = v_tipo;
    this.v_marca = v_marca;
    this.v_modelo = v_modelo;
    this.v_configuracion = v_configuracion;
    this.v_aplicacion = v_aplicacion;
    this.v_planta = v_planta;
    this.v_estado = v_estado;
    this.v_f_registro = v_f_registro;
  }
}

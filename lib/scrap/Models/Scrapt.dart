class Scrapt {
  int s_id;
  String s_serie;
  String s_marca;
  String s_modelo;
  String s_medida;
  String s_disenio;
  String s_motivo_scrap;
  String s_fecha_scrap;
  String s_remanente_final;
  String s_remanente_limite;
  String s_neumatico_ruta_1;
  String s_neumatico_ruta_2;

  Scrapt(
      this.s_id,
      this.s_serie,
      this.s_marca,
      this.s_modelo,
      this.s_medida,
      this.s_disenio,
      this.s_motivo_scrap,
      this.s_fecha_scrap,
      this.s_remanente_final,
      this.s_remanente_limite,
      this.s_neumatico_ruta_1,
      this.s_neumatico_ruta_2) {
    this.s_id = s_id;
    this.s_serie = s_serie;
    this.s_marca = s_marca;
    this.s_modelo = s_modelo;
    this.s_medida = s_medida;
    this.s_disenio = s_disenio;
    this.s_motivo_scrap = s_motivo_scrap;
    this.s_fecha_scrap = s_fecha_scrap;
    this.s_remanente_final = s_remanente_final;
    this.s_remanente_limite = s_remanente_limite;
    this.s_neumatico_ruta_1 = s_neumatico_ruta_1;
    this.s_neumatico_ruta_2 = s_neumatico_ruta_2;
  }
}

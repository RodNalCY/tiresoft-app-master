class NeumaticoMalEstado {
  int nme_id;
  String nme_disponibilidad;
  String nme_num_serie;
  String nme_marca;
  String nme_modelo;
  String nme_medida;
  String nme_fecha_retiro;
  String nme_remanente_original;
  String nme_remanente_final;
  String nme_remanente_limite;
  String nme_costo;
  String nme_costo_perdida;

  NeumaticoMalEstado(
      this.nme_id,
      this.nme_disponibilidad,
      this.nme_num_serie,
      this.nme_marca,
      this.nme_modelo,
      this.nme_medida,
      this.nme_fecha_retiro,
      this.nme_remanente_original,
      this.nme_remanente_final,
      this.nme_remanente_limite,
      this.nme_costo,
      this.nme_costo_perdida) {
    this.nme_id = nme_id;
    this.nme_disponibilidad = nme_disponibilidad;
    this.nme_num_serie = nme_num_serie;
    this.nme_marca = nme_marca;
    this.nme_modelo = nme_modelo;
    this.nme_medida = nme_medida;
    this.nme_fecha_retiro = nme_fecha_retiro;
    this.nme_remanente_original = nme_remanente_original;
    this.nme_remanente_final = nme_remanente_final;
    this.nme_remanente_limite = nme_remanente_limite;
    this.nme_costo = nme_costo;
    this.nme_costo_perdida = nme_costo_perdida;
  }
}

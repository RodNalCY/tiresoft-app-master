class User {
  int u_id;
  String u_name;
  String u_lastname;
  String u_email;
  String u_telefono;
  String u_role;
  String u_role_name;
  String u_img_logo;
  String u_firma;
  String u_created;

  User(
      this.u_id,
      this.u_name,
      this.u_lastname,
      this.u_email,
      this.u_telefono,
      this.u_role,
      this.u_role_name,
      this.u_img_logo,
      this.u_firma,
      this.u_created) {
    this.u_id = u_id;
    this.u_name = u_name;
    this.u_lastname = u_lastname;
    this.u_email = u_email;
    this.u_telefono = u_telefono;
    this.u_role = u_role;
    this.u_role_name = u_role_name;
    this.u_img_logo = u_img_logo;
    this.u_firma = u_firma;
    this.u_created = u_created;
  }
}

class UserController{
  String name = "";
  String password = "";
  String email = "";
  String number = "";

  UserController(this.name, this.password, this.email, this.number);

  UserController.fromJson(Map<String , dynamic> jsonObject){
    this.name=jsonObject["name"];
    this.password=jsonObject["password"];
    this.email =jsonObject["email"];
    this.number = jsonObject["number"];
  }
}
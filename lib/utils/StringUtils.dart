class StringUtils{

  static bool isNotEmpty(str){
    try{
      return str != null && str.toString() != "null" && str != "" && str != "null" && str.toString() != "" && str.toString().length > 0;
    }catch(e){
      print(e);
      return false;
    }
  }

}
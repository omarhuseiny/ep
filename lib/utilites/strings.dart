class RegularExp {
  static const String validationEmail =
      //r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$";

  static const String validationName = r'^[a-z A-Z]+$';
}

// String baseUrl = 'https://fakestoreapi.com';

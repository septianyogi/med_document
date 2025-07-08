class AppRequest {
  static Map<String, String> header([String? token]) {
    if (token == null) {
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    } else {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
  }

  static Map<String, String> headerFile([String? bearerToken]) {
    if (bearerToken == null) {
      return {
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Connection": "keep-alive",
      };
    } else {
      return {
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Connection": "keep-alive",
        "Authorization": "Bearer $bearerToken",
      };
    }
  }
}

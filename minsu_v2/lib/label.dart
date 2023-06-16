
class Label{
  Future<Map<String, String>> Labeling(int digit) async {
    String label = "";
    String message = "";

    switch (digit) {
      case 0 :
        label = "Drowsy driving \u{1F634}";
        message = "혹시 지금 피곤하신가요?"; // Speak "The digit is zero" for digit 0
        break;
      case 1 :
        label = "Drunk driving \u{1F608}";
        message = "혹시 지금 음주운전 중이신가요?"; // Speak "The digit is one" for digit 1
        break;
      case 2 :
        label = "Looking for somethings";
        message = "혹시 지금 전방을 주시하고 계신가요?"; // Speak "The digit is two" for digit 2
        break;
      case 3 :
        label = "Calling \u{1F627}";
        message = "혹시 지금 전방을 주시하고 계신가요?"; // Speak "The digit is three" for digit 3
        break;
      case 4 :
        label = "Using cell phone \u{1F4F5}";
        message = "혹시 지금 전방을 주시하고 계신가요?"; // Speak "The digit is four" for digit 4
        break;
      case 5 :
        label = "You're best driver \u{1F60E}";
        break;
      case 6 :
        label = "Assaulting driver \u{1F631}";
        message = "혹시 지금 위험한 상태이신가요?"; // Speak "The digit is six" for digit 6
        break;
      default:
        message = "예측이 불가합니다."; // Speak "Invalid Digit" for any other digit
        break;
    }
    return {'label': label, 'message': message};
  }
}
class UserData {
  static int kalanYildiz = 5;

  static bool harca() {
    if (kalanYildiz > 0) {
      kalanYildiz--;
      return true;
    }
    return false;
  }
}

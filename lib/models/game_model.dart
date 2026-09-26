class AlfabeOyun2Model {
  final String title;
  final String mainImage;
  final String correctLetter;
  final List<String> options;

  AlfabeOyun2Model({
    required this.title,
    required this.mainImage,
    required this.correctLetter,
    required this.options,
  });
}

class AlfabeOyun1Model {
  final String charImage;
  final String correctSound;
  List<String> soundOptions;

  AlfabeOyun1Model({
    required this.charImage,
    required this.correctSound,
    required this.soundOptions,
  });
}

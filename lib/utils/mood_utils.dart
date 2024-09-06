String getMoodSvg(String mood) {
  switch (mood) {
    case 'Normal':
      return 'assets/svgs/neutral.svg';
    case 'Feliz':
      return 'assets/svgs/happy.svg';
    case 'Triste':
      return 'assets/svgs/sad.svg';
    case 'Enojado':
      return 'assets/svgs/angry.svg';
    case 'Confundido':
      return 'assets/svgs/confused.svg';
    case 'Sorprendido':
      return 'assets/svgs/surprised.svg';
    case 'Cansado':
      return 'assets/svgs/tired.svg';
    case 'x':
      return 'assets/svgs/predetermined.svg';
    default:
      return 'assets/svgs/predetermined.svg';
  }
}

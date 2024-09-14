String getMoodSvg(String? mood) {
  switch (mood) {
    case 'Normal':
      return 'assets/svgs/predetermined.svg';
    case 'Feliz':
      return 'assets/svgs/happy.svg';
    case 'Triste':
      return 'assets/svgs/sad.svg';
    case 'Enojado':
      return 'assets/svgs/angry.svg';
    case 'Decepcionado':
      return 'assets/svgs/upset.svg';
    case 'Sorprendido':
      return 'assets/svgs/surprised.svg';
    case 'Cansado':
      return 'assets/svgs/tired.svg';
    case 'Aburrido':
      return 'assets/svgs/bored.svg';
    case 'Enamorado':
      return 'assets/svgs/love.svg';
    default:
      return 'assets/svgs/predetermined.svg';
  }
}

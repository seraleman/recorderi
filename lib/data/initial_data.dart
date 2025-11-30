class InitialCardSet {
  final String name;
  final int color;
  final List<InitialCard> cards;

  InitialCardSet({
    required this.name,
    required this.color,
    required this.cards,
  });
}

class InitialCard {
  final String question;
  final String answer;

  InitialCard({required this.question, required this.answer});
}

// Note: Colors match the cardColors array from constants.dart
// They will cycle through in order: Blue, Green, Orange, Purple, Pink
final List<InitialCardSet> initialCardSets = [
  // English Idioms (index 0 - Blue)
  InitialCardSet(
    name: 'English Idioms',
    color: 0xFF2196F3,
    cards: [
      InitialCard(
        question: 'Break the ice',
        answer: 'Romper el hielo (iniciar una conversación incómoda)',
      ),
      InitialCard(
        question: 'Piece of cake',
        answer: 'Pan comido (algo muy fácil)',
      ),
      InitialCard(
        question: 'Hit the nail on the head',
        answer: 'Dar en el clavo (acertar completamente)',
      ),
      InitialCard(
        question: 'Cost an arm and a leg',
        answer: 'Costar un ojo de la cara (ser muy caro)',
      ),
      InitialCard(
        question: 'Bite the bullet',
        answer: 'Apretar los dientes (afrontar algo desagradable)',
      ),
      InitialCard(
        question: 'Once in a blue moon',
        answer: 'De Pascuas a Ramos (muy raramente)',
      ),
      InitialCard(
        question: 'Let the cat out of the bag',
        answer: 'Revelar un secreto',
      ),
      InitialCard(
        question: 'Spill the beans',
        answer: 'Irse de la lengua (revelar un secreto)',
      ),
      InitialCard(
        question: 'The ball is in your court',
        answer: 'La pelota está en tu tejado (es tu turno de actuar)',
      ),
      InitialCard(
        question: 'Under the weather',
        answer: 'Estar pachuco/indispuesto (sentirse mal)',
      ),
    ],
  ),

  // Capitales del Mundo (index 1 - Green)
  InitialCardSet(
    name: 'Capitales del Mundo',
    color: 0xFF4CAF50,
    cards: [
      InitialCard(question: '¿Capital de Francia?', answer: 'París'),
      InitialCard(question: '¿Capital de Japón?', answer: 'Tokio'),
      InitialCard(question: '¿Capital de Brasil?', answer: 'Brasilia'),
      InitialCard(question: '¿Capital de Australia?', answer: 'Canberra'),
      InitialCard(question: '¿Capital de Canadá?', answer: 'Ottawa'),
      InitialCard(question: '¿Capital de Egipto?', answer: 'El Cairo'),
      InitialCard(question: '¿Capital de Argentina?', answer: 'Buenos Aires'),
      InitialCard(question: '¿Capital de India?', answer: 'Nueva Delhi'),
      InitialCard(question: '¿Capital de Alemania?', answer: 'Berlín'),
      InitialCard(question: '¿Capital de Italia?', answer: 'Roma'),
    ],
  ),

  // Matemáticas Básicas (index 2 - Orange)
  InitialCardSet(
    name: 'Matemáticas Básicas',
    color: 0xFFFF9800,
    cards: [
      InitialCard(question: 'H', answer: 'Hidrógeno'),
      InitialCard(question: 'O', answer: 'Oxígeno'),
      InitialCard(question: 'C', answer: 'Carbono'),
      InitialCard(question: 'N', answer: 'Nitrógeno'),
      InitialCard(question: 'Fe', answer: 'Hierro'),
      InitialCard(question: 'Au', answer: 'Oro'),
      InitialCard(question: 'Ag', answer: 'Plata'),
      InitialCard(question: 'Na', answer: 'Sodio'),
      InitialCard(question: 'K', answer: 'Potasio'),
      InitialCard(question: 'Ca', answer: 'Calcio'),
    ],
  ),

  // Elementos Químicos (index 3 - Purple)
  InitialCardSet(
    name: 'Elementos Químicos',
    color: 0xFF9C27B0,
    cards: [
      InitialCard(
        question: 'Fórmula del área de un círculo',
        answer: 'A = πr²',
      ),
      InitialCard(question: 'Teorema de Pitágoras', answer: 'a² + b² = c²'),
      InitialCard(
        question: 'Fórmula del área de un triángulo',
        answer: 'A = (base × altura) / 2',
      ),
      InitialCard(question: 'Perímetro de un círculo', answer: 'P = 2πr'),
      InitialCard(question: 'Volumen de un cubo', answer: 'V = lado³'),
      InitialCard(
        question: '¿Cuántos grados tiene un triángulo?',
        answer: '180°',
      ),
      InitialCard(
        question: 'Fórmula del área de un rectángulo',
        answer: 'A = base × altura',
      ),
      InitialCard(
        question: '¿Qué es un número primo?',
        answer: 'Un número divisible solo por 1 y por sí mismo',
      ),
    ],
  ),

  // Historia Universal (index 4 - Pink)
  InitialCardSet(
    name: 'Historia Universal',
    color: 0xFFE91E63,
    cards: [
      InitialCard(
        question: '¿En qué año comenzó la Segunda Guerra Mundial?',
        answer: '1939',
      ),
      InitialCard(
        question: '¿En qué año cayó el Muro de Berlín?',
        answer: '1989',
      ),
      InitialCard(
        question: '¿En qué año llegó el hombre a la Luna?',
        answer: '1969',
      ),
      InitialCard(
        question: '¿En qué año se descubrió América?',
        answer: '1492',
      ),
      InitialCard(
        question: '¿Cuándo inició la Revolución Francesa?',
        answer: '1789',
      ),
      InitialCard(
        question: '¿En qué año terminó la Primera Guerra Mundial?',
        answer: '1918',
      ),
      InitialCard(
        question: '¿Quién fue el primer presidente de Estados Unidos?',
        answer: 'George Washington',
      ),
      InitialCard(question: '¿En qué año se fundó Roma?', answer: '753 a.C.'),
    ],
  ),
];

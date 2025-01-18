import 'package:cards_against_humanity/model/dto/black_card_dto.dart';

class BlackCard {
  final int id;
  final String text; // "La meloni ha concesso il diritto al _ ."
  final int numberOfBlanks; // 1
  
  BlackCard(this.id, this.text, this.numberOfBlanks);
  BlackCard.fromDto(BlackCardDto dto) : 
    id = dto.id,
    text = dto.text,
    numberOfBlanks = dto.numberOfBlanks;
}

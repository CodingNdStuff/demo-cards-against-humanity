import 'package:cards_against_humanity/model/dto/white_card_dto.dart';

class WhiteCard {
  final int id;
  final String text;
  WhiteCard(this.id, this.text);
   WhiteCard.fromDto(WhiteCardDto dto) : 
    id = dto.id,
    text = dto.text;
}

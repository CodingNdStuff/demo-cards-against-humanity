import 'package:cards_against_humanity/helpers/api_service.dart';
import 'package:cards_against_humanity/helpers/firebase_service.dart';
import 'package:cards_against_humanity/model/custom_exception.dart';
import 'package:cards_against_humanity/model/dto/create_lobby_response.dart';
import 'package:cards_against_humanity/model/dto/join_lobby_response.dart';
import 'package:cards_against_humanity/model/lobby.dart';
import 'package:cards_against_humanity/model/player.dart';
import 'package:cards_against_humanity/model/round.dart';
import 'package:cards_against_humanity/model/white_card.dart';
import 'package:flutter/foundation.dart';

class LobbyViewModel extends ChangeNotifier {
  late String id;
  LobbyStatus status = LobbyStatus.initial;
  late int roundDuration;
  late int maxRoundNumber;
  late int currentRound;
  late Player user;
  late Round? round;
  late List<Player> playerList;
  List<WhiteCard> userHand = [];
  List<WhiteCard> placedCards = [];
  FirebaseService firebaseService = FirebaseService();
  String? error;
  bool isLoading = false;
  ApiService apiService = ApiService();

  Future<bool> createLobby(
      String nickname, int roundDuration, int maxRoundNumber) async {
    isLoading = true;
    CreateLobbyResponse response;
    try {
      response =
          await apiService.createLobby(nickname, roundDuration, maxRoundNumber);
    } on Customexception catch (e) {
      print(e.message);
      isLoading = false;
      return false;
    }
    isLoading = false;
    id = response.lobbyId;

    user = Player(response.playerId, nickname);
    _setupFirebaseListeners(response.lobbyId);
    return true;
  }

  Future<bool> joinLobby(String lobbyId, String nickname) async {
    isLoading = true;
    JoinLobbyResponse response;
    try {
      response = await apiService.joinLobby(lobbyId, nickname);
    } on Customexception catch (e) {
      print(e.message);
      isLoading = false;
      return false;
    }
    isLoading = false;
    id = lobbyId;

    user = Player(response.playerId, nickname);
    _setupFirebaseListeners(lobbyId);
    return true;
  }

  Future<void> setPlayerReady() async {
    isLoading = true;
    try {
      await apiService.setPlayerReady(id, user.id);
      if (status == LobbyStatus.prep) {
        placedCards = [];
      }
    } on Customexception catch (e) {
      print(e.message);
      isLoading = false;
    }
    isLoading = false;
  }

  Future<void> voteWinner(String nickname) async {
    if (!isLoading) {
      isLoading = true;
      try {
        await apiService.voteWinner(id, user.id, nickname);
      } on Customexception catch (e) {
        print(e.message);
        isLoading = false;
      }
    }
    isLoading = false;
  }

  void _setupFirebaseListeners(String lobbyId) {
    firebaseService.readLobbyData(id, (lobbyDto) {
      status = lobbyDto.status;
      roundDuration = lobbyDto.roundDuration;
      maxRoundNumber = lobbyDto.maxRoundNumber;
      currentRound = lobbyDto.currentRound;
      playerList = lobbyDto.playerList.map((p) => Player.fromDto(p)).toList();
      try {
        final updatedUserData =
            playerList.where((p) => p.nickname == user.nickname).first;
        user.isMyTurn = updatedUserData.isMyTurn;
        user.score = updatedUserData.score;
        user.isReady = updatedUserData.isReady;
      } catch (e) {
        error =
            "Something went deeply wrong: cannot find the user inside lobby";
        return false;
      }
      round = lobbyDto.round != null ? Round.fromDto(lobbyDto.round!) : null;
      notifyListeners();
    });

    firebaseService.readPlayerHandData(id, user.nickname, (handDto) {
      userHand = handDto
          .map(
            (e) => WhiteCard.fromDto(e),
          )
          .toList();
      notifyListeners();
    });
  }

  MapEntry<String, List<WhiteCard>> getWinningProposal() {
    Player winner = playerList.firstWhere((p) => p.isMyTurn);
    List<WhiteCard> winnerProposal =
        round?.getMyPlacedCards(winner.nickname) ?? [];
    return MapEntry(winner.nickname, winnerProposal);
  }

  void resetLobby() {
    firebaseService.resetSubscriptions();
  }

  void placeCard(WhiteCard card) async {
    placedCards.add(card);
    notifyListeners();
  }

  playCards() async {
    if (!isLoading) {
      isLoading = true;
      try {
        await apiService.playCard(
            id, user.id, placedCards.map((card) => card.id).toList());
      } on Customexception catch (e) {
        print(e.message);
        isLoading = false;
      }
    }
    isLoading = false;
  }

  void resetPlacedCards() {
    userHand.addAll(placedCards);
    placedCards = [];
    notifyListeners();
  }
}

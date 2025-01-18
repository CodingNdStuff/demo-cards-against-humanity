package com.touchgrass.cah.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}

/*
	LobbyController -> Entry point for all incoming requests, leveraging the LobbyService.
	LobbyService -> Contains the main game logic, it depends on:
		JsonService to retrieve the cards form the Json resources.
		PublisherService to reflect the lobby status to connected players //todo

	Constants -> Contains some static values that configure behaviors.
	Model -> Classes that map the data used by the app, some provide some utility methods like:
		Deck allows to draw cards, removing them from the deck.
		Lobby allows to change player "ready" status, play cards, make some checks, ...
	Dto -> Classes that map network request and response bodies

	LobbyStatus -> Defines the possible game phases
		open -> lobby is created, players can join
		initial -> possibly not used
		play -> the host (or the one who won last turn) draws a black card, which is shown. Other players can play their white card(s)
		voting(3) -> the host (...) chooses the funniest white card among the played one
		prep(4) -> winning card is shown, a new round is setup, players must set themselves ready. The next phase can either be "play" or "closed"
		closed(5) -> game over, lobby will be disposed (possibly in the future "play again with different cards" feature will be added
 */

/*
	Test cases to study:
		- prevent hackers from voting themselves by knowing the playerIds
*/

/*
	Known issues:
		- no ip checks: a user can spam "create lobby" and fill the lobby number size
		- payload is not protected, consider rsa
 */

/*
	TODO:
		- ip checks,
		- rate limiter, blacklist
		- reconnect api
		- better disconnection handling to prevent deadlocks (or votekick)
 */
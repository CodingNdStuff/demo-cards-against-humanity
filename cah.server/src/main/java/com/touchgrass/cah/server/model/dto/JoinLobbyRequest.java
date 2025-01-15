package com.touchgrass.cah.server.model.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class JoinLobbyRequest {
    @NotBlank
    @Size(min = 1, max = 32)
    private String playerId;

    @NotBlank
    @Size(min = 1, max = 16)
    private String nickname;
}

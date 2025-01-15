package com.touchgrass.cah.server.model.dto;

import com.touchgrass.cah.server.utils.Constants;
import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class VoteWinnerRequest {
    @NotBlank
    @Size(min = Constants.NICKNAME_MIN_LENGTH, max = Constants.NICKNAME_MAX_LENGTH)
    private String votedPlayerNickname;
}

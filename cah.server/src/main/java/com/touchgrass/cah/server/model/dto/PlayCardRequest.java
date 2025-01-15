package com.touchgrass.cah.server.model.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PlayCardRequest {
    @NotNull
    @Size(min = 1)
    private List<@NotNull Integer> cardIds;
}

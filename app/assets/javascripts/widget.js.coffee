kickboard.factory "Widget", (resource) ->
  resource "/kickboard/boards/:boardId/widgets/:id", { id: "@id", boardId: "@board_id"}

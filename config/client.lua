return {
    enableClient = true, -- disable to create your own client interface
    engineOn = true, -- If true, the engine will be on upon taking the vehicle out.
    debugPoly = GetConvar("environment", "development") ~= "production",

    --- called every frame when player is near the garage and there is a separate drop off marker
    ---@param coords vector3
    drawDropOffMarker = function(coords)
        DrawMarker(36, coords.x, coords.y, coords.z - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 200, true, false, 0, true, nil, nil, false)
    end,

    --- called every frame when player is near the garage to draw the garage marker
    ---@param coords vector3
    drawGarageMarker = function(coords)
        DrawMarker(23, coords.x, coords.y, coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 200, true, false, 0, false, nil, nil, false)
    end,
}
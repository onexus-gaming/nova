local Scene = Object:extend()

-- If set to true, loading this scene will store an instance in memory instead of the class itself (thus there will only ever be one instance of this scene).
-- A singleton scene is instanciated exactly once, immediately after it gets loaded.
-- A singleton scene's constructor cannot take any parameters (they are passed into .opened(...) instead)
Scene.isSingleton = false

-- Called exactly once after the scene is opened.
-- Usable for singleton and regular scenes, but generally of no use for regular scenes.
function Scene:opened(...) end
function Scene:update(dt) end
function Scene:draw() end

return Scene
---
title: Getting started with nova
---

# nova fundamentals

nova is designed with **[object-orientation](https://en.wikipedia.org/wiki/Object-oriented_programming)** in mind as it makes managing games much simpler, yet much more robust than with other approaches. We require the use of **[classic by rxi](https://github.com/rxi/classic)** as it is clean yet very usable.  
Everything in nova is based on **objects** and applications should take advantage of this as much as possible.

## Defining classes and objects with classic

We usuallly define 1 class per file, with the file bearing the same name as its class, to maintain a clean code structure. It is not required, but it is strongly recommended to do this. Here are the basics of implementing a class that does not inherit from any other class, assuming it is contained in its own lua file:

```lua
---Basic documentation about the class
---@class MyClass
---@field someField
local MyClass = Object:extend() -- extending the base object

function MyClass:new(someField) -- this is the cconstructor for the class
    self.someField = someField
    self._conventionallyPrivateField = "scary private field" -- "conventionally private" = not actually private (it is difficult to enforce this in lua unless you want to mess with local tables as keys) but accessing it is discouraged
end

---Getter for public field
---@return any
function MyClass:getSomeField()
    return self.someField
end

---Getter for private field
---@return string
function MyClass:conventionallyPrivateField()
    return self._conventionallyPrivateField
end

---Prints the public field
function MyClass:displaySomeField()
    print(self.someField)
end

return MyClass -- never forget to return the object at the end of the module, otherwise it is inacessible
```

## Scenes

**Scenes** are essentially game states that handle what the game does at a given moment. You can have many different scenes, e.g. for menus and gameplay. In nova, scenes are loaded by default as classes and switching to a scene will create an instance of that scene and set it as the current running instance; if a scene is marked as a **singleton** (`MyScene.isSingleton = true`), it is loaded as an instance and switching to it will set the current running instance to it.  
Here is the definition of a scene in the code:

```lua
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
```

You may notice that the signatures for `Scene:update(dt)` and `Scene:draw()` are eerily similar to `love.update(dt)` and `love.draw()` respectively.
This isn't without cause: nova forwards the major events ([callbacks](https://love2d.org/wiki/Category:Callbacks)) from LÖVE to the currently running scene exactly as they would be called in a regular game without the framework.

Technically, you are not obligated to define a function in your scene for every callback, as nova, for every callback, checks whether your scene defines that callback or not before passing it.

Note that the callbacks in your scene may occasionally not be called due to a feature called **capturing** (which will be explained in the **services** section).

## Services

TODO

### Capturing a callback

TODO

## Callback calling order

TODO (`capture = capture or service:_pre_<callback>` -> `if not capture: scene:<callback>` -> `service:_<callback>`)

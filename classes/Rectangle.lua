-- helper class to manage all sorts of rectangular things
local Rectangle = Object:extend()

function Rectangle:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:perimeter()
    return 2 * (self.width + self.height)
end

function Rectangle:diagonal()
    return math.sqrt(self.width^2 + self.height^2)
end

function Rectangle:intersects(other)
    if type(other) == "table" and other.is and other:is(Rectangle) then
        return self.x == other.x and self.y == other.y and self.width == other.width and self.height == other.height
    else
        error("attempt to check intersection between Rectangle and " .. type(other))
    end
end

return Rectangle
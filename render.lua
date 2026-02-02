
render={}

--z ordered rendering of elements
function render.zbuffer(z,action)
  table.insert(render,{z,action})
end
function render.paint()
  table.sort(render,function(a,b) return a[1]<b[1] end)
  for i=1,#render do render[i][2]() end
end
function render.clear()
  table.clear(render)
end
draw={}


-- draws a board of 20x20 tiles, on the coordinates -10,-10 to 10 10
-- takes the function for the tile images and the lighting mode
-- returns with the four projected corners of the board 
function render.board(image, light, x1, x2, y1, y2)
  -- optional extents: defaults keep previous behaviour (-10..10)
  x1 = x1 or -10; x2 = x2 or 10; y1 = y1 or -10; y2 = y2 or 10

  -- store extents for edgeboard and other helpers
  render.board_extents = {x1,x2,y1,y2}

  -- projects the corners of the tiles
  local points={}
  for x=x1,x2 do    
    local row={}
    for y=y1,y2 do  
      row[y]={view.project(x,y,0)}
    end
    points[x]=row
  end

  for x=x1,x2-1 do
    for y=y1,y2-1 do
      local a,b=points[x][y][1],points[x][y][2]
      local c,d=points[x+1][y][1],points[x+1][y][2]
      local e,f=points[x][y+1][1],points[x][y+1][2]
      local l=light(vector{x,y}, vector{0,0,1})
      love.graphics.setColor(255*l,255*l,255*l)
      love.graphics.push()
      love.graphics.transform(a,b,c,d,e,f)
      local image =love.graphics.getImage(image(x,y))
      love.graphics.draw(image,0,0,0,1/32,1/32)
      love.graphics.pop()
    end
  end
  return {points[x1][y1], points[x2][y1], points[x2][y2], points[x1][y2]}
end

-- Single quad board: renders the entire plane as ONE quad (no tile boundaries = no jitter!)
function render.board_single(texture, light, x1, x2, y1, y2)
  -- optional extents: defaults keep previous behaviour (-10..10)
  x1 = x1 or -10; x2 = x2 or 10; y1 = y1 or -10; y2 = y2 or 10
  
  -- store extents for edgeboard and other helpers
  render.board_extents = {x1,x2,y1,y2}
  
  -- project the 4 corners of the entire plane
  local c1 = {view.project(x1, y1, 0)}  -- bottom-left
  local c2 = {view.project(x2, y1, 0)}  -- bottom-right
  local c3 = {view.project(x2, y2, 0)}  -- top-right
  local c4 = {view.project(x1, y2, 0)}  -- top-left
  
  -- average lighting over the board
  local l = light(vector{(x1+x2)/2, (y1+y2)/2}, vector{0,0,1})
  love.graphics.setColor(255*l, 255*l, 255*l)
  
  -- draw single quad
  love.graphics.push()
  love.graphics.transform(c1[1], c1[2], c2[1], c2[2], c4[1], c4[2])
  local img = love.graphics.getImage(texture)
  love.graphics.draw(img, 0, 0, 0, 1/32, 1/32)
  love.graphics.pop()
  
  -- return corners for compatibility
  return {c1, c2, c3, c4}
end


--draws the lightbulb
function render.bulb(action)
  local x,y,z,s=view.project(unpack(light-{0,0,2}))
  action(z,function()
    love.graphics.setBlendMode("add")
    love.graphics.setColor(255,255,255)
    love.graphics.draw(love.graphics.getImage("default/bulb.png"),x,y,0,s/64,s/64)
    --[[    love.graphics.circle("fill",x,y,s/5,40)
    love.graphics.circle("line",x,y,s/5,40)
    ]]
    love.graphics.setBlendMode("alpha")
  end)
end

--draws a die complete with lighting and projection
function render.die(action, die, star)
  local cam={view.get()}
  local projected={}
  for i=1,#star do
    table.insert(projected, {view.project(unpack(star[i]+star.position))})
  end

  for i=1,#die.faces do
    --prepare face data
    local face=die.faces[i]
    local xy,z,c={},0,vector()
    for i=1,#face do
      c=c+star[face[i]]
      local p = projected[face[i]]
      table.insert(xy,p[1])
      table.insert(xy,p[2])
      z=z+p[3]
    end
    z=z/#face
    c=c/#face
    
    --light it up
    local strength=die.material(c+star.position, c:norm())
    local strength=die.material(c+star.position, c:norm())
    local color={ die.color[1]*strength, die.color[2]*strength, die.color[3]*strength, die.color[4] }
    local text={die.text[1]*strength,die.text[2]*strength,die.text[3]*strength}
    local front=c..(1*c+star.position-cam)<=0
    --if it is visible then render
    action(z, function()
      if front then 
        love.graphics.setColor(unpack(color))
        love.graphics.polygon("fill",unpack(xy))
        love.graphics.setColor(unpack(text))
        die.image(i,unpack(xy))
        -- outline removed (can cause rendering artifacts); material indicator will be drawn as a dot
      elseif color[4] and color[4]<255 then
        love.graphics.setColor(unpack(text))
        die.image(i,unpack(xy))
        love.graphics.setColor(unpack(color))
        love.graphics.polygon("fill",unpack(xy))
      end
    end) 
  end

  
end


--draws a shadow of a die
function render.shadow(action,die, star)
  
  local cast={}
  for i=1,#star do
    local x,y=light.cast(star[i]+star.position)
    if not x then return end --no shadow
    table.insert(cast,vector{x,y})
  end
    
  --convex hull, gift wrapping algorithm
  --find the leftmost point
  --thats in the hull for sure
  local hull={cast[1]}
  for i=1,#cast do if cast[i][1]<hull[1][1] then hull[1]=cast[i] end end
  
  --now wrap around the points to find the outermost
  --this algorithm has the additional niceity that it gives us the points clockwise
  --which is important for love.polygon
  repeat
    local point=hull[#hull]
    local endpoint=cast[1]
    if point==endpoint then endpoint=cast[2] end
    
    --see if cast[i] is to the left of our best guess so far
    for i=1,#cast do
      local left = endpoint-point
      left[1],left[2]=left[2],-left[1]
      local diff=cast[i]-endpoint
      if diff..left>0 then
        endpoint=cast[i]
      end
    end
    hull[#hull+1]=endpoint
    if #hull>#cast+1 then return end --we've done something wrong here
  until hull[1]==hull[#hull]
  if #hull<3 then return end --also something wrong or degenerate case
  
  action(0,function()
    love.graphics.setColor(unpack(die.shadow))
    love.graphics.polygon("fill",hull)
  end)
end  

  --draws around a board
  --draw the void with black to remove shadows extending from the board
function render.edgeboard()
  local x1,x2,y1,y2 = -10,10,-10,10
  if render.board_extents then x1,x2,y1,y2 = unpack(render.board_extents) end
  local corners={
    {view.project(x1,y1,0)},
    {view.project(x1,y2,0)},
    {view.project(x2,y2,0)},
    {view.project(x2,y1,0)}
  }
  love.graphics.setColor(0,0,0)
  
  local m=1 --m is the leftmost corner
  for i=2,4 do if corners[i][1]<corners[m][1] then m=i end end
  
  --n(ext), p(rev), o(ther),m(in) are the four corners
  local n,p,o= corners[math.cycle(m+1,4)], corners[math.cycle(m-1,4)], corners[math.cycle(m+2,4)]
  m=corners[m]
  
  --we ecpect n(ext) to be the clockwise next from m(in)
  if n[2]>p[2] then n,p=p,n end
  
  love.graphics.polygon("fill", -100,m[2], m[1],m[2], n[1],n[2], n[1],-100, -100,-100)
  love.graphics.polygon("fill", n[1],-100, n[1],n[2], o[1],o[2], 100,o[2], 100, -100)
  love.graphics.polygon("fill", 100,o[2], o[1],o[2], p[1],p[2], p[1],100, 100,100)
  love.graphics.polygon("fill", p[1],100, p[1],p[2], m[1],m[2], -100,m[2], -100,100)
  
end

-- Draws a 3D raised border around the board to simulate a dice tray
function render.tray_border(border_width, border_height, border_color)
  border_width = border_width or 0.8   -- width of the border rim
  border_height = border_height or 1.2 -- height of the border walls
  -- Colors in 0-255 format (dark wood brown)
  border_color = border_color or {90, 56, 31}  -- RGB: dark wood brown
  
  local x1, x2, y1, y2 = -10, 10, -10, 10
  if render.board_extents then x1, x2, y1, y2 = unpack(render.board_extents) end
  
  -- Outer edge coordinates (board + border width)
  local ox1, ox2, oy1, oy2 = x1 - border_width, x2 + border_width, y1 - border_width, y2 + border_width
  
  -- Helper: draw a quad given 4 corners (in screen coords)
  local function draw_quad(c1, c2, c3, c4, color, shade)
    local r, g, b = color[1] * shade, color[2] * shade, color[3] * shade
    love.graphics.setColor(r, g, b, 255)  -- explicit alpha=255 for full opacity
    love.graphics.polygon("fill", c1[1], c1[2], c2[1], c2[2], c3[1], c3[2], c4[1], c4[2])
  end
  
  -- Project all 16 key points (inner/outer at z=0 and z=border_height)
  local inner_bottom = {
    {view.project(x1, y1, 0)},
    {view.project(x2, y1, 0)},
    {view.project(x2, y2, 0)},
    {view.project(x1, y2, 0)}
  }
  local outer_bottom = {
    {view.project(ox1, oy1, 0)},
    {view.project(ox2, oy1, 0)},
    {view.project(ox2, oy2, 0)},
    {view.project(ox1, oy2, 0)}
  }
  local inner_top = {
    {view.project(x1, y1, border_height)},
    {view.project(x2, y1, border_height)},
    {view.project(x2, y2, border_height)},
    {view.project(x1, y2, border_height)}
  }
  local outer_top = {
    {view.project(ox1, oy1, border_height)},
    {view.project(ox2, oy1, border_height)},
    {view.project(ox2, oy2, border_height)},
    {view.project(ox1, oy2, border_height)}
  }
  
  -- Draw the 4 outer walls (vertical faces on outside)
  -- Front wall (y1 side - usually bottom of screen)
  draw_quad(outer_bottom[1], outer_bottom[2], outer_top[2], outer_top[1], border_color, 0.7)
  -- Right wall (x2 side)
  draw_quad(outer_bottom[2], outer_bottom[3], outer_top[3], outer_top[2], border_color, 0.85)
  -- Back wall (y2 side - usually top of screen)
  draw_quad(outer_bottom[3], outer_bottom[4], outer_top[4], outer_top[3], border_color, 1.0)
  -- Left wall (x1 side)
  draw_quad(outer_bottom[4], outer_bottom[1], outer_top[1], outer_top[4], border_color, 0.75)
  
  -- Draw the 4 inner walls (vertical faces on inside, facing the dice)
  -- These are slightly darker as they're in shadow
  draw_quad(inner_bottom[2], inner_bottom[1], inner_top[1], inner_top[2], border_color, 0.5)
  draw_quad(inner_bottom[3], inner_bottom[2], inner_top[2], inner_top[3], border_color, 0.55)
  draw_quad(inner_bottom[4], inner_bottom[3], inner_top[3], inner_top[4], border_color, 0.6)
  draw_quad(inner_bottom[1], inner_bottom[4], inner_top[4], inner_top[1], border_color, 0.5)
  
  -- Draw the top surface (horizontal rim)
  -- Front rim (y1 side)
  draw_quad(outer_top[1], outer_top[2], inner_top[2], inner_top[1], border_color, 0.9)
  -- Right rim (x2 side)  
  draw_quad(outer_top[2], outer_top[3], inner_top[3], inner_top[2], border_color, 0.95)
  -- Back rim (y2 side)
  draw_quad(outer_top[3], outer_top[4], inner_top[4], inner_top[3], border_color, 1.0)
  -- Left rim (x1 side)
  draw_quad(outer_top[4], outer_top[1], inner_top[1], inner_top[4], border_color, 0.88)
end


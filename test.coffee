window.requestAnimFrame = (->
  return  window.requestAnimationFrame       ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback) ->
  window.setTimeout callback, 1000 / 60
)()

#====
#----

# define Handlec class
class Handlec
  constructor : ( @x, @y, @rotation, @rad, @type, @rotationSpeed) ->

  run : ->
    @display()

  display: (context) ->
    context.fillStyle = "#ff0000"
    context.arc @x, @y, 1, 0, 2 * Math.PI, true
    context.fill()


  increase: ( step) ->
    @rotation += step + @rotationSpeed

  pos: ->
    @calculatePoint @x, @y, @rad, @rotation

  calculatePoint: (x, y, r, theta) ->
    px = x + Math.cos(theta) * r
    py = y + Math.sin(theta) * r

    point = { x: px, y: py}


# ---- ---- ---- ---- ----
# setting the variable
# ---- ---- ---- ---- ----

myText = "test"

speed = 0.08
handleRad = 6

particleDistance = 50

wd = 800
hg = 600
handles = []

canvas = null
context = null

mouseMoveMinDis =  160

init = ->
  canvas = document.getElementById 'myCanvas'
  canvas.width = wd
  canvas.height = hg

  context = canvas.getContext '2d'
  context.fillRect 0, 0, wd, hg

  context.font = 'bold 12px sans-serif'
  context.fillStyle = "#fff"
  context.fillText 'C A N', 3 ,14
  context.fillText 'V A S', 4 ,28



  tempWd = 38
  tempHg = 32

  imgData  = context.getImageData 0,0,tempWd,tempHg
  data = imgData.data


#  console.log output for output in data

  xpos = 0
  ypos = 0

  xDis = wd / tempWd
  hDis = hg / tempHg

  console.log xDis
  console.log hDis

  console.log xpos

  i = tempWd + 1
  j = tempHg + 1


  wordData = []

  while i -= 1
    while j -= 1
      if data[(xpos + ypos * tempWd) * 4] > 0
#        console.log(xpos)
        xVal = xpos * xDis
        yVal = ypos * hDis
        checknum = {x: xVal, y: yVal}
        wordData.push checknum
      ypos++

    j = tempHg + 1
    ypos = 0
    xpos++

  for wData in wordData
    handle = new Handlec wData.x, wData.y, Math.random() * Math.PI * 2, handleRad, Math.random(), 0
    handles.push(handle)

  canvas.addEventListener 'mousemove', onMouseMove

onMouseMove = (e) ->
  mx = e.offsetX || e.pageX
  my = e.offsetY || e.pageY

  for oneHandle in handles
    pt = oneHandle.pos()
    dx = pt.x - mx
    dy = pt.y - my
    dis = Math.sqrt dx * dx + dy * dy
    if dis < mouseMoveMinDis
      oneHandle.rad = 50 * (mouseMoveMinDis - dis) / mouseMoveMinDis + handleRad
      oneHandle.rotationSpeed = Math.PI / 2 * (mouseMoveMinDis - dis) / mouseMoveMinDis

    else
      oneHandle.rad = handleRad
      oneHandle.rotationSpeed = 0


animation = ->
  context.fillStyle = "#000000"
  context.fillRect 0, 0, wd, hg

#  context.font = 'bold 12px sans-serif'
#  context.fillStyle = "#fff"
#  context.fillText 'C A N', 5 ,16
#  context.fillText 'V A S', 6 ,30



  for oneHandle in handles
    if(oneHandle.type == 1)
      oneHandle.increase(speed)
    else
      oneHandle.increase(speed * -1)

    drawPt = oneHandle.pos()

    context.beginPath()
    context.fillStyle = "rgba(255, 255, 255, .1)"
    context.arc drawPt.x, drawPt.y, 3, 0, 2 * Math.PI, true
    context.fill()
    context.closePath()

#    console.log "(x, y): ( #{drawPt.x}, #{drawPt.y})"

    for otherHandle in handles
      otherPt = otherHandle.pos()
      distance = Math.sqrt( Math.pow(otherPt.x - drawPt.x, 2) + Math.pow(otherPt.y - drawPt.y, 2))
      if(distance < particleDistance)
        alphaVal =   (1- distance / particleDistance) * 0.5
        colorStr = "rgba( 0, 190, 255, " + alphaVal.toString() + ")"
        context.strokeStyle =  colorStr
        context.beginPath()
        context.moveTo( drawPt.x, drawPt.y)
        context.lineTo( otherPt.x, otherPt.y)
        context.stroke()
        context.closePath()


  requestAnimFrame animation



init()
animation()

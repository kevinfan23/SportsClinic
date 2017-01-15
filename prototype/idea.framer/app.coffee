# Import file "idea" (sizes and positions are scaled 1:2)
$ = Framer.Importer.load("imported/idea@2x")

{TextLayer} = require 'TextLayer'

dis = $.graphs.x


do graphAnimate = ->
	$.graphs.animate
		properties:
			x:  dis 
	curve: "linear"
	dis = dis + 25
	setTimeout graphAnimate, 1000
				
# Create new scroll component
scroll = ScrollComponent.wrap($.details)
scroll.scrollHorizontal = false
scroll.contentInset = 
	bottom: 275
# Set the default animation to spring
Framer.Defaults.Animation = 
  time: 0.3
  curve: 'spring'
  curveOptions:
    tension: 200
    friction: 20
    velocity: 10
	
# Create the button	
button = new Layer
	width:80
	height:80
	x: 2250
	y: 1620
	borderRadius:'8px'

# Set variables
lineWidth = 50
lineHeight = 6
buttonActive = false

# Create hamburger lines
middleLine = new Layer
	width: lineWidth, height: lineHeight, x:15, y:button.height/2 - lineHeight/2, backgroundColor: 'white', borderRadius:'3px'

topLine = new Layer
	width: lineWidth, height: lineHeight, x:15, y:middleLine.y - 15, backgroundColor:'white', borderRadius:'3px'
	
bottomLine = new Layer
	width: lineWidth, height: lineHeight, x:15, y:middleLine.y + 15, backgroundColor:'white', borderRadius:'3px'	
	
# Add lines as subLayers of button
button.addSubLayer(topLine)
button.addSubLayer(middleLine)
button.addSubLayer(bottomLine)
	
# Conditional for switching between open/close 
buttonOpen = false

button.on Events.Click, ->
	
	if !buttonOpen
		open()
		$.cover_contents.animate
			properties:
				y: -725
			time: 1.1
			curve: "bezier-curve(.8,0,.1,1)"
			
		$.background_image.animate
			properties:
				y: -1100
			time: 1.0
			curve: "bezier-curve(.9,0,.1,1)"
			
		this.animate
			properties: y: 560
			time: 1.1
			curve: "bezier-curve(.8,0,.1,1)"
		buttonOpen = true
		
	else
		close()
		$.cover_contents.animate
			properties:
				y: 345
			time: 1.1
			curve: "bezier-curve(.8,0,.1,1)"
			
		$.background_image.animate
			properties:
				y: 0
			time: 1.0
			curve: "bezier-curve(.9,0,.1,1)"
			
		this.animate
			properties: y: 1625
			time: 1.1
			curve: "bezier-curve(.8,0,.1,1)"
		buttonOpen = false
				
# Open menu function	
open = ->
	buttonActive = true
	button.scale = 0.75
	
	button.animate
		properties:scale:1
		
	middleLine.animate
		properties:opacity:0
		curve:"ease"
		time:0.1

	topLine.animate
		properties:y:button.height/2 - lineHeight/2, rotationZ:135

	bottomLine.animate
		properties:y:button.height/2 - lineHeight/2, rotationZ:-135			
# Close menu function		
close = ->
	buttonActive = false
	button.scale = 0.75
	
	button.animate
		properties:scale:1
		
	middleLine.animate
		properties:opacity:1
		curve:"ease"
		time:0.1

	topLine.animate
		properties: y:middleLine.y - 15, rotationZ:0

	bottomLine.animate
		properties:y:middleLine.y + 15, rotationZ:0
	
index1 = new TextLayer
	parent: $.$01
	text: "0"
	color: "#CA2C43"
	fontFamily: "DIN Condensed"
	fontSize: 320
	fontWeight: 500
	autoSize: true
	x: 400
	y: 200
	
do angleRand = ->
	angle = Math.floor(Math.random() * (65 - 35) + 35)
	index1.text = "#{angle}"
	setTimeout angleRand, 2000
	
index2 = new TextLayer
	parent: $.$02
	text: "0"
	color: "#fff"
	fontFamily: "DIN Condensed"
	fontSize: 320
	fontWeight: 500
	autoSize: true
	x: Align.center()
	y: 200
	
do releaseRand = ->
	release = Math.floor(Math.random() * (-2 + 9) - 2)
	index2.text = "#{release}"
	setTimeout releaseRand, 2000
	
index3 = new TextLayer
	parent: $.$03
	text: "0"
	color: "#fff"
	fontFamily: "DIN Condensed"
	fontSize: 320
	fontWeight: 500
	autoSize: true
	x: Align.center()
	y: 200
	
do elevationRand = ->
	elevation = Math.floor(Math.random() * (9) - 0)
	index3.text = "#{elevation}"
	setTimeout elevationRand, 2000
	
index4 = new TextLayer
	parent: $.$04
	text: "0"
	color: "#fff"
	fontFamily: "DIN Condensed"
	fontSize: 320
	fontWeight: 500
	autoSize: true
	x: Align.center()
	y: 200
	
do speedRand = ->
	speed = Math.floor(Math.random() * (25 - 10) + 10)
	index4.text = "#{speed}"
	setTimeout speedRand, 2000


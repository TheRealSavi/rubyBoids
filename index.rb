require "matrix"
require "ruby2d"
require_relative "boid.rb"
require_relative "savio"

set width: 1280, height: 720
set title: "Boids", fullscreen:false, background: 'black'
# set borderless: true
set resizable:true

class BoidCanvas
  attr_accessor :x, :y, :width, :height, :flock
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
    @flock = []

    Image.new(
      'bg.jpg',
      x: @x, y: @y,
      width: @width, height: @height,
      z: 0
    )
  end
end

myCanvas = BoidCanvas.new(0, 0, Window.width * 0.75, Window.height)

$maxSpeedSlider = Slider.new(x:Window.width * 0.75 + 10,y:100,length:Window.width * 0.18,min: 0.0,max: 50.0,value: 14,size: 8,name: "Max Speed")
$maxForceSlider = Slider.new(x:Window.width * 0.75 + 10,y:200,length:Window.width * 0.18,min: 0.0,max: 5.0,value: 0.35,size: 8,name: "Max Force")

$alignSlider = Slider.new(x:Window.width * 0.75 + 10,y:400,length:Window.width * 0.18,min: 0,max: 300,value: 190,size: 8,name: "Align")
$cohesionSlider = Slider.new(x:Window.width * 0.75 + 10,y:500,length:Window.width * 0.18,min: 0,max: 300,value: 200,size: 8,name: "Cohesion")
$separationSlider = Slider.new(x:Window.width * 0.75 + 10,y:600,length:Window.width * 0.18,min: 0,max: 300,value: 150,size: 8,name: "Separation")



90.times do
  myCanvas.flock.push(Boid.new(myCanvas))
end

update do
  myCanvas.flock.each do |boid|
    boid.flock(myCanvas.flock)
    boid.update
  end
end

show

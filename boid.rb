class Boid
  attr_accessor :position, :velocity, :acceleration
  def initialize(thisCanvas)
    @thisCanvas = thisCanvas

    @maxSpeed = $maxSpeedSlider.value
    @maxForce = $maxForceSlider.value

    @position = Vector[rand(@thisCanvas.x..@thisCanvas.width), rand(@thisCanvas.y..@thisCanvas.height)]
    @velocity = Vector[rand(-@maxSpeed..@maxSpeed),rand(-@maxSpeed..@maxSpeed)]
    @acceleration = Vector[0,0]

    @size = 0.03 * Window.width

    @model = Image.new(
      'bird.png',
      x: @position.element(0),
      y: @position.element(1),
      width: @size, height: @size,
      z: 1
    )
  end

  def align(boids)
    percepetion = $alignSlider.value

    avg = Vector[0,0]
    total = 0
    boids.each do |other|
      distance = (@position - other.position).r
      if distance <= percepetion && other != self
        avg += other.velocity
        total += 1
      end
    end
    if total > 0
      avg /= total
      avg *= (@maxSpeed / avg.r)
      avg -= @velocity
      avg[0] = avg[0].clamp(-@maxForce, @maxForce)
      avg[1] = avg[1].clamp(-@maxForce, @maxForce)
    end
    return avg
  end

  def cohesion(boids)
    percepetion = $cohesionSlider.value

    avg = Vector[0,0]
    total = 0
    boids.each do |other|
      distance = (@position - other.position).r
      if distance <= percepetion && other != self
        avg += other.position
        total += 1
      end
    end
    if total > 0
      avg /= total
      avg -= @position
      avg *= (@maxSpeed / avg.r)
      avg -= @velocity
      avg[0] = avg[0].clamp(-@maxForce, @maxForce)
      avg[1] = avg[1].clamp(-@maxForce, @maxForce)
    end
    return avg
  end

  def separation(boids)
    percepetion = $separationSlider.value

    avg = Vector[0,0]
    total = 0
    boids.each do |other|
      distance = (@position - other.position).r
      if distance <= percepetion && other != self
        diff = @position - other.position
        diff /= distance ** 2
        avg += diff
        total += 1
      end
    end
    if total > 0
      avg /= total
      avg *= (@maxSpeed / avg.r)
      avg -= @velocity
      avg[0] = avg[0].clamp(-@maxForce, @maxForce)
      avg[1] = avg[1].clamp(-@maxForce, @maxForce)
    end
    return avg
  end

  def edges
    if @position.element(0) > @thisCanvas.width - @size
      @position[0] = @thisCanvas.x
    end
    if @position.element(0) < @thisCanvas.x
      @position[0] = @thisCanvas.width - @size
    end
    if @position.element(1) > @thisCanvas.height - @size
      @position[1] = @thisCanvas.y
    end
    if @position.element(1) < @thisCanvas.y
      @position[1] = @thisCanvas.height - @size
    end
  end

  def flock(boids)
    @acceleration = Vector[0,0]

    a = self.align(boids)
    c = self.cohesion(boids)
    s = self.separation(boids)

    @acceleration += a
    @acceleration += c
    @acceleration += s
  end

  def update()
    self.edges

    @maxSpeed = $maxSpeedSlider.value
    @maxForce = $maxForceSlider.value

    @model.x = @position.element(0)
    @model.y = @position.element(1)

    @velocity[0] = @velocity[0].clamp(-@maxSpeed, @maxSpeed)
    @velocity[1] = @velocity[1].clamp(-@maxSpeed, @maxSpeed)

    @position += @velocity
    @velocity += @acceleration
  end
end

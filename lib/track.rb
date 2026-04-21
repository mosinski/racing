require './lib/line2'
require './lib/track_layouts'
require './lib/circuit_geometry'

class Track
  attr_reader :layout, :path2d
  attr_accessor :lines, :quads, :background

  def initialize(layout: :original)
    @layout = layout
    @lines = []
    @quads = []
    @path2d = nil
    @background = Background.new

    n = TrackLayouts::N
    seg_l = 200.0

    if layout == :ring
      c = CircuitGeometry.ring_path(n, seg_l)
      @path2d = { px: c[:px], pz: c[:pz] }
      g = CircuitGeometry.gforce_curve_from_path(c[:px], c[:pz], n)
      n.times { |i| @lines << make_planar_line(i, g[i], :ring) }
    elsif layout == :stadium
      c = CircuitGeometry.stadium_path(n, seg_l)
      @path2d = { px: c[:px], pz: c[:pz] }
      g = CircuitGeometry.gforce_curve_from_path(c[:px], c[:pz], n)
      n.times { |i| @lines << make_planar_line(i, g[i], :stadium) }
    else
      draw_lines_from_layouts
    end
    drawQuads
  end

  def draw_lines_from_layouts
    0.upto(TrackLayouts::N - 1) do |i|
      @lines << TrackLayouts.build_line(i, @layout)
    end
  end

  def make_planar_line(i, g_curve, style)
    line = Line2.new
    line.z = i * 200
    # Opposite sign from atan2 path so positive curve matches existing g-force / background feel
    line.curve = -g_curve
    n = TrackLayouts::N
    case style
    when :ring
      line.y = 320.0 * Math.sin(2.0 * Math::PI * i / n)
    when :stadium
      line.y = 180.0 * Math.sin(4.0 * Math::PI * i / n) + 40.0 * Math.sin(16.0 * Math::PI * i / n)
    end
    line
  end

  def drawQuads
    for i in 0..1599
      self.quads << Array.new(3) {
        Quad.new(
          x1: 0, y1: 0,
          x2: 0, y2: 0,
          x3: 0, y3: 0,
          x4: 0, y4: 0
        )
      }
    end
  end

  def drawQuad(i, j, color, x1, y1, w1, x2, y2, w2, z: nil)
    quad = self.quads[i][j]
    quad.x1 = x1 - w1
    quad.y1 = y1
    quad.x2 = x2 - w2
    quad.y2 = y2
    quad.x3 = x2 + w2
    quad.y3 = y2
    quad.x4 = x1 + w1
    quad.y4 = y1
    quad.color = color
    # Set @z without Renderable#z= (no remove/re-add; racing.rb re-sorts @objects by z each frame)
    quad.instance_variable_set(:@z, z) unless z.nil?
  end

  # One road/rumble trapezoid between two projected scanlines.
  # When p.Y < l.Y (hill crest, p is higher on the screen, l is lower on the screen), the
  # default order pL → lL → lR → pR makes Ruby2D’s triangulation (1-2-3) + (1-3-4) fold like a
  # bow-tie and the wrong half is filled — only the “downhill” face appears. Winding
  # pL → pR → lR → lL fixes the interior for that case; see Quad#render two-triangle layout.
  def draw_road_strip(i, j, color, p, l, p_w, l_w, z: nil)
    quad = self.quads[i][j]
    if p.Y < l.Y
      quad.x1 = p.X - p_w;  quad.y1 = p.Y
      quad.x2 = p.X + p_w;  quad.y2 = p.Y
      quad.x3 = l.X + l_w;  quad.y3 = l.Y
      quad.x4 = l.X - l_w;  quad.y4 = l.Y
    else
      quad.x1 = p.X - p_w;  quad.y1 = p.Y
      quad.x2 = l.X - l_w;  quad.y2 = l.Y
      quad.x3 = l.X + l_w;  quad.y3 = l.Y
      quad.x4 = p.X + p_w;  quad.y4 = p.Y
    end
    quad.color = color
    quad.instance_variable_set(:@z, z) unless z.nil?
  end

  def drawBackground(pos, speed)
    if speed > 0
      background.move(-self.lines[pos].curve * (speed / 200.0))
    elsif speed < 0
      background.move(self.lines[pos].curve * (speed / 200.0))
    end
  end
end

require 'ruby2d'

# Pooled billboard-style tree sprites along the road edges, drawn back-to-front
# so near trees occlude far ones. Placement is deterministic from segment +index+
# (stable while driving) but looks irregular like noise.
class RoadsideTrees
  attr_reader :pool

  def initialize
    @pool = []
    90.times do |i|
      path = i.even? ? 'images/tree1.png' : 'images/tree2.png'
      img = Image.new(path, x: -10_000, y: -10_000, z: 2, width: 1, height: 1, show: true)
      @pool << img
    end
  end

  # +rows+ is ordered near-to-far like the road loop. Each is a snapshot
  # { x:, y:, w:, scale:, i: } (not a Line2, which is re-used each frame).
  def draw(rows)
    @index = 0
    rows.reverse_each do |row|
      break if @index >= @pool.size

      scale = row[:scale]
      y = row[:y]
      w = row[:w]
      next unless scale && scale.positive?
      next if y < 20 || y > 900
      next if w < 3

      i = row[:i]
      # ~1/12 rows can host trees. (Earlier parity-xor gating was broken: for h % n with
      # even n, h is even and i*0x1bf58 is even, so (h ^ (i*0x1bf58)) & 1 was always 0.)
      h = mix32(i)
      next if h % 12 != 0

      h_l = mix32(i * 2 + 1) & 0xff
      h_r = mix32(i * 2 + 3) & 0xff
      # ~40% per side, independent, so you get irregular gaps and sometimes one or both.
      place(row, :left)  if h_l < 100
      place(row, :right) if h_r < 100
    end

    @index.upto(@pool.size - 1) do |k|
      @pool[k].x = -10_000
    end
  end

  private

  def mix32(i)
    x = (i * 0x5bd1e995) & 0xffffffff
    (x ^ (x >> 16)) * 0x9e37_79b1 & 0xffffffff
  end

  def place(row, side)
    return if @index >= @pool.size

    img = @pool[@index]
    w = row[:w]
    height = (w * 0.5).clamp(24, 520)
    width = height * (120.0 / 200.0)
    img.width = width
    img.height = height

    h = mix32(row[:i] * 2 + (side == :left ? 1 : 3))
    edge = 1.22 + (h & 0x3f) / 256.0 * 0.24 # 1.22–1.46 from road: slight random stand-off
    j = ((h >> 6) & 0x1f) / 32.0 - 0.5 # -0.5 .. 0.5
    nudge = w * 0.08 * j
    base = side == :left ? (row[:x] - w * edge) : (row[:x] + w * edge)
    cx = base + nudge
    yb = row[:y]
    img.x = cx - width / 2
    img.y = yb - height
    img.z = yb.floor
    @index += 1
  end
end

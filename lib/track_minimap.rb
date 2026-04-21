# frozen_string_literal: true

require 'ruby2d'

# Top-down map. Planar closed circuits use real (x, z) from Track#path2d. Other tracks use
# integrated lateral vs. arclength (unwound, honest, not a fake ring).
class TrackMinimap
  MARGIN = 10
  INNER_PAD = 6
  Z_BACK = 3_200
  Z_TRACK = 3_201
  Z_CAR   = 3_202

  attr_reader :n

  def initialize(track, road_w, seg_l, win_w,
                  map_w: 208, map_h: 160, y_top: 10)
    @n = track.lines.length
    @road_w = road_w
    @seg_l = seg_l.to_f
    @s_max = @n * @seg_l
    @map_w = map_w
    @map_h = map_h
    @x0 = win_w - map_w - MARGIN
    @y0 = y_top
    @use_path2d = track.path2d && !track.path2d[:px].nil?
    if @use_path2d
      @px = track.path2d[:px]
      @pz = track.path2d[:pz]
      @wx0, @wy0, @wscale = self.class.fit_path_bounds(@px, @pz, map_w, map_h, INNER_PAD * 2)
    else
      @laterals = self.class.build_laterals(track)
    end
    @inner_w = map_w - 2 * INNER_PAD
    @inner_h = map_h - 2 * INNER_PAD
    if !@use_path2d
      l = @laterals
      @min_l = l.min
      @max_l = l.max
      @span_l = [(@max_l - @min_l).abs, 1.0].max
    end

    @bg = Rectangle.new(
      x: @x0, y: @y0, width: @map_w, height: @map_h,
      color: '#141824', z: Z_BACK
    )
    @border = [
      Line.new(x1: @x0, y1: @y0, x2: @x0 + @map_w, y2: @y0, width: 2, color: '#4a5a6a', z: Z_BACK + 0.1),
      Line.new(x1: @x0 + @map_w, y1: @y0, x2: @x0 + @map_w, y2: @y0 + @map_h, width: 2, color: '#4a5a6a', z: Z_BACK + 0.1),
      Line.new(x1: @x0 + @map_w, y1: @y0 + @map_h, x2: @x0, y2: @y0 + @map_h, width: 2, color: '#4a5a6a', z: Z_BACK + 0.1),
      Line.new(x1: @x0, y1: @y0 + @map_h, x2: @x0, y2: @y0, width: 2, color: '#4a5a6a', z: Z_BACK + 0.1)
    ]
    @track_lines = @use_path2d ? build_path_segments : build_unwound_segments
    @dot = Circle.new(
      x: @x0 + map_w / 2, y: @y0 + map_h / 2, radius: 4.5, sectors: 20,
      color: '#ff2a2a', z: Z_CAR
    )
    update_pos(0.0, 0.0)
  end

  def self.fit_path_bounds(px, pz, map_w, map_h, margin)
    x_min = px.min
    x_max = px.max
    z_min = pz.min
    z_max = pz.max
    spanx = [x_max - x_min, 1.0].max
    spanz = [z_max - z_min, 1.0].max
    sc = 0.88 * [(map_w - margin) / spanx, (map_h - margin) / spanz].min
    cx = 0.5 * (x_min + x_max)
    cz = 0.5 * (z_min + z_max)
    [cx, cz, sc]
  end

  def self.build_laterals(track)
    x = 0.0
    dx = 0.0
    track.lines.map do |line|
      cur = x
      x += dx
      dx += line.curve
      cur
    end
  end

  def self.unwound_lateral(laterals, n, pos, seg_l, car_x, road_w)
    tlen = n * seg_l
    pos %= tlen
    j = (pos / seg_l).to_i
    j = n - 1 if j >= n
    t = (pos - j * seg_l) / seg_l
    t = 0.0 if t.negative?
    t = 1.0 if t > 1.0
    l0 = laterals[j]
    l1 = (j < n - 1) ? laterals[j + 1] : laterals[0]
    l0 * (1.0 - t) + l1 * t + (car_x * road_w)
  end

  def update_pos(pos, car_x)
    if @use_path2d
      x, z = self.class.pos_on_path_full(@px, @pz, @n, @seg_l, pos, car_x, @road_w)
      mx, my = to_screen_path(x, z)
    else
      s = pos % @s_max
      lat = self.class.unwound_lateral(@laterals, @n, s, @seg_l, car_x, @road_w)
      mx, my = to_screen_unwound(lat, s)
    end
    @dot.x = mx
    @dot.y = my
  end

  def self.pos_on_path_full(px, pz, n, seg_l, pos, car_x, road_w)
    tlen = n * seg_l
    s = pos % tlen
    j = (s / seg_l).to_i
    j = n - 1 if j >= n
    t = (s - j * seg_l) / seg_l
    t = 0.0 if t.negative?
    t = 1.0 if t > 1.0
    j2 = j + 1
    x = px[j] * (1.0 - t) + px[j2] * t
    z = pz[j] * (1.0 - t) + pz[j2] * t
    dx = px[j2] - px[j]
    dz = pz[j2] - pz[j]
    len = Math.hypot(dx, dz)
    len = 1.0 if len < 1e-6
    nx = -dz / len
    nz = dx / len
    [x + nx * (car_x * road_w * 0.3), z + nz * (car_x * road_w * 0.3)]
  end

  def remove
    @bg.remove
    @border.each(&:remove)
    @track_lines.each(&:remove)
    @dot.remove
  end

  private

  def to_screen_path(wx, wz)
    cx = @x0 + 0.5 * @map_w
    cy = @y0 + 0.5 * @map_h
    m = @wscale
    [cx + m * (wx - @wx0), cy - m * (wz - @wy0)]
  end

  def to_screen_unwound(lat, s)
    cx = @x0 + INNER_PAD
    cy = @y0 + INNER_PAD
    mxl = 0.75 * @inner_w / @span_l
    mzs = 0.75 * @inner_h / @s_max
    m = [mxl, mzs].min
    [cx + m * (lat - @min_l), cy + m * s]
  end

  def build_path_segments
    lines = []
    n = @n
    (0..(n - 1)).each do |i|
      a = to_screen_path(@px[i], @pz[i])
      b = to_screen_path(@px[i + 1], @pz[i + 1])
      lines << Line.new(
        x1: a[0], y1: a[1], x2: b[0], y2: b[1], width: 2.0,
        color: '#3d6a7a', z: Z_TRACK
      )
    end
    lines
  end

  def build_unwound_segments
    lines = []
    (0..(@n - 1)).each do |i|
      s0 = i * @seg_l
      s1 = s0 + @seg_l
      l0 = @laterals[i]
      l1 = (i < @n - 1) ? @laterals[i + 1] : @laterals[0]
      a = to_screen_unwound(l0, s0)
      b = to_screen_unwound(l1, s1)
      lines << Line.new(
        x1: a[0], y1: a[1], x2: b[0], y2: b[1], width: 2.0,
        color: '#3d6a7a', z: Z_TRACK
      )
    end
    lines
  end
end

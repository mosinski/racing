# frozen_string_literal: true

# 2D centerlines for closed-circuit (planar) tracks: N equal-arclength samples, lap = N*seg_l.
# x = horizontal, z = "forward" in world; x feeds the road project offset, path feeds minimap.
module CircuitGeometry
  module_function

  def wrap_delta(d)
    d -= 2.0 * Math::PI while d > Math::PI
    d += 2.0 * Math::PI while d < -Math::PI
    d
  end

  # CCW ring; circumference 2*PI*R = n*seg_l
  def ring_path(n, seg_l)
    r = n * seg_l / (2.0 * Math::PI)
    px = (0..n).map { |i| t = 2.0 * Math::PI * i / n; r * Math.sin(t) }
    pz = (0..n).map { |i| t = 2.0 * Math::PI * i / n; r * Math.cos(t) }
    dtheta = 2.0 * Math::PI / n
    {
      px: px, pz: pz, dtheta: dtheta, r: r
    }
  end

  def stadium_point(s, w_str, r, total)
    s %= total
    w = w_str
    pr = Math::PI * r

    if s < w
      [-0.5 * w + s, -r]
    elsif s < w + pr
      u = s - w
      theta = -0.5 * Math::PI + (u / pr) * Math::PI
      [0.5 * w + r * Math.cos(theta), r * Math.sin(theta)]
    elsif s < 2.0 * w + pr
      u = s - (w + pr)
      [0.5 * w - u, r]
    else
      u = s - (2.0 * w + pr)
      theta = 0.5 * Math::PI + (u / pr) * Math::PI
      [-0.5 * w + r * Math.cos(theta), r * Math.sin(theta)]
    end
  end

  # Stadium: 2 * w_str (straights) + 2*PI*r (arcs) = n*seg_l
  def stadium_path(n, seg_l, r_turn: 30_000.0)
    total = n * seg_l
    a = 2.0 * r_turn * Math::PI
    w = 0.5 * (total - a)
    w = 10_000.0 if w < 10_000.0
    px = []
    pz = []
    (0..n).each do |i|
      s = i * total / n.to_f
      x, z = stadium_point(s, w, r_turn, total)
      px << x
      pz << z
    end
    { px: px, pz: pz, w_str: w, r: r_turn, total: total }
  end

  # heading of edge (i) -> (i+1) for i=0..n-1
  def edge_headings(px, pz, n)
    (0..(n - 1)).map do |i|
      dx = px[i + 1] - px[i]
      dz = pz[i + 1] - pz[i]
      Math.atan2(dz, dx)
    end
  end

  # G-force / background want one scalar per segment: turn at vertex i of polyline
  def gforce_curve_from_path(px, pz, n, scale: 100.0)
    heads = edge_headings(px, pz, n)
    (0..(n - 1)).map do |i|
      h_in = i.zero? ? heads[n - 1] : heads[i - 1]
      h_out = heads[i]
      d = wrap_delta(h_out - h_in)
      scale * d
    end
  end
end

# frozen_string_literal: true

require './lib/line2'

# Elevation and curve for each of N segments (0..1599). Kept in one place so :original matches
# the pre-menu behaviour and other layouts stay obviously different to drive.
module TrackLayouts
  N = 1600

  module_function

  def build_line(i, layout)
    line = Line2.new
    line.z = i * 200

    case layout
    when :original
      build_original_line(line, i)
    when :coastal
      build_coastal_line(line, i)
    when :switchback
      build_switchback_line(line, i)
    when :ring, :stadium
      # Built from CircuitGeometry in Track#initialize, not used here
      build_original_line(line, i)
    else
      build_original_line(line, i)
    end
    line
  end

  def build_original_line(line, i)
    if (i > 300) && (i < 700)
      line.curve = 0.5
    end
    if i > 1100
      line.curve -= 0.7
    end
    amp = 1_200.0
    blend = (i < 700) ? 0.0 : (i >= 800 ? 1.0 : (i - 700) / 100.0)
    line.y = Math.sin(i / 30.0) * amp * blend
  end

  def build_coastal_line(line, i)
    if (i > 150) && (i < 600)
      line.curve = 0.25
    end
    if (i > 900) && (i < 1200)
      line.curve -= 0.35
    end
    amp = 600.0
    blend = (i < 400) ? 0.0 : (i >= 550 ? 1.0 : (i - 400) / 150.0)
    line.y = Math.sin((i + 20) / 40.0) * amp * blend
  end

  def build_switchback_line(line, i)
    if (i > 200) && (i < 500)
      line.curve = 0.75
    end
    if (i > 500) && (i < 800)
      line.curve = -0.5
    end
    if i > 1000
      line.curve -= 0.45
    end
    amp = 1_400.0
    blend = (i < 500) ? 0.0 : (i >= 650 ? 1.0 : (i - 500) / 150.0)
    line.y = Math.sin((i - 5) / 24.0) * amp * blend
  end
end

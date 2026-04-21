# frozen_string_literal: true

require 'ruby2d'

# Full-width horizontal lines with Y labels (screen space, origin at top) for debug screenshots.
module YScreenRuler
  # @param z [Integer] z for lines; labels and caption use z+1 and z+2. Use ~1500–1900 to sit
  #   above the road and trees, below the car and HUD (typically 2000+).
  def self.install!(width, height, step: 100, z: 1_800)
    Text.new(
      'Screen Y: 0 = top, down = larger —',
      size: 12, x: 4, y: 2, z: z + 2, color: 'yellow', opacity: 0.9
    )

    y = 0
    while y < height
      Line.new(
        x1: 0, y1: y, x2: width, y2: y,
        z: z, width: 1, color: 'yellow', opacity: 0.35
      )
      # Label just under the line so it is readable; avoid y < 0 for the caption row
      label_y = y < 3 ? (y + 3) : (y - 1)
      Text.new(
        "Y=#{y}",
        size: 12, x: 4, y: label_y, z: z + 1, color: 'yellow', opacity: 0.85
      )
      y += step
    end
  end
end

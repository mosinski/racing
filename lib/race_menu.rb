# frozen_string_literal: true

require 'ruby2d'

# Simple full-screen track picker (Up/Down, Enter or Space to start).
class RaceMenu
  MENU_Z = 5_000

  TRACKS = [
    { id: :original,   title: 'Hills Classic',  blurb: 'Curves + rolling hills' },
    { id: :coastal,    title: 'Coastal Run',    blurb: 'Gentler bends, lower hills' },
    { id: :switchback, title: 'Switchback',     blurb: 'Tighter curves, steeper rollers' },
    { id: :ring,       title: 'Velodrome',      blurb: 'True closed loop — circular plan' },
    { id: :stadium,    title: 'Oval Stadium',   blurb: 'Straights + U-turns like a real short oval' }
  ].freeze

  attr_reader :active, :selection

  def initialize(window_w, window_h)
    @active = true
    @selection = 0
    @bg = Rectangle.new(
      x: 0, y: 0, width: window_w, height: window_h,
      color: '#0a0f14', z: MENU_Z
    )
    @title = Text.new(
      'Racing', size: 56, x: window_w / 2 - 90, y: 80, z: MENU_Z + 1, color: 'white', font: 'assets/fonts/LCD.TTF'
    )
    @subtitle = Text.new(
      'Choose a track', size: 22, x: window_w / 2 - 95, y: 150, z: MENU_Z + 1, color: '#88aacc'
    )
    @rows = Array.new(TRACKS.size) do |idx|
      Text.new(
        '', size: 20, x: 120, y: 220 + idx * 56, z: MENU_Z + 2, color: 'white'
      )
    end
    @hint = Text.new(
      'Up / Down  —  Enter or Space to race',
      size: 18, x: 120, y: window_h - 100, z: MENU_Z + 2, color: '#6688aa'
    )
    refresh_labels
  end

  def move(dir)
    return unless @active

    @selection = (@selection + dir) % TRACKS.size
    @selection += TRACKS.size if @selection.negative?
    refresh_labels
  end

  def selected_layout
    TRACKS[@selection][:id]
  end

  def hide!
    return unless @active

    @active = false
    @bg.remove
    @title.remove
    @subtitle.remove
    @rows.each(&:remove)
    @hint.remove
  end

  private

  def refresh_labels
    TRACKS.each_with_index do |t, idx|
      prefix = (idx == @selection) ? '> ' : '  '
      @rows[idx].text = "#{prefix}#{t[:title]}  —  #{t[:blurb]}"
      @rows[idx].color = (idx == @selection) ? '#ffcc44' : '#cccccc'
    end
  end
end

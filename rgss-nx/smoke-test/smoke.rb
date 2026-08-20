# Original, asset-free RGSS-NX smoke test.
# No RPG Maker RTP or Pokémon content is required.

Graphics.resize_screen(640, 480) if Graphics.respond_to?(:resize_screen)

background = Bitmap.new(640, 480)
background.fill_rect(0, 0, 640, 480, Color.new(20, 22, 28, 255))
background.fill_rect(0, 0, 640, 10, Color.new(80, 170, 255, 255))
background.fill_rect(0, 470, 640, 10, Color.new(80, 170, 255, 255))

begin
  background.font.size = 30
  background.draw_text(0, 125, 640, 48, "RGSS-NX M0", 1)
  background.font.size = 20
  background.draw_text(0, 190, 640, 36, "mkxp-z / RGSS is executing on this device", 1)
  background.draw_text(0, 230, 640, 36, "Press the Confirm input to toggle the test panel", 1)
rescue Exception => e
  STDERR.puts("[RGSS-NX] smoke text rendering failed: #{e.class}: #{e.message}") rescue nil
end

sprite = Sprite.new
sprite.bitmap = background

active = false
loop do
  Input.update

  if Input.trigger?(Input::C)
    active = !active
    color = active ? Color.new(80, 200, 120, 255) : Color.new(80, 90, 110, 255)
    background.fill_rect(120, 320, 400, 70, color)
    begin
      background.font.size = 20
      background.draw_text(120, 337, 400, 36, active ? "INPUT: OK" : "INPUT: waiting", 1)
    rescue Exception
    end
  end

  Graphics.update
end

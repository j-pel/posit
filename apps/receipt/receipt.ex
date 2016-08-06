defmodule Receipt do
  use Application
  
  def start(_type, _args) do
      Port.open(:spawn, "png2pos -c logo.png > /dev/usb/lp0")
      Port.open(:spawn, "echo \"\x1dV\x41\x03\" >> /dev/usb/lp0")
  end

end

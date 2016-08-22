defmodule Receipt do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Starts a worker by calling: Receipt.Worker.start_link(arg1, arg2, arg3)
      # worker(Receipt.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: Receipt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def find_printer() do
    {:ok, usb_ports} = File.ls("/dev/usb")
    Enum.find(usb_ports, &is_printer("/dev/usb/#{&1}"))
  end
  
  defp is_printer(port) do
    {props, 0} = System.cmd "udevadm", ["info", "-q", "property", "--name", port]
    String.contains? props, "ID_MODEL=TM-T88V"
  end

# ESC/POS helping bits:
# ESC = "0x1b"
# GS  = "0x1d"
# NUL = "0x00"

  def print_ticket() do
    #File.copy "test/logo.prn", "ticket.prn"
    #{:ok, file} = File.open("ticket.prn", [:binary,:append])
    {:ok, file} = File.open("ticket.prn", [:binary,:write])
    IO.binwrite file, [0x1b,"@"] # Reset to defaults
    IO.binwrite file, [0x1b,"a",0x01] # Centered
    IO.binwrite file, [0x1b,"E",0x01] # Bold on
    IO.binwrite file, ["Ozio Caff", 0x82, 0x0a]
    IO.binwrite file, [0x1b,"E",0x00] # Bold off
    IO.binwrite file, ["Todos merecemos unos minutos de Ozio", 0x0a]
    cut_ticket file
    #System.cmd "png2pos", ["-c", "test/logo.png"]
    #System.cmd "dd", ["if=ticket.prn","of=/dev/usb/#{find_printer}"]    
  end

  def open_drawer(file) do
    IO.binwrite file, [0x1d,0x56,0x41,0x40]
  end

  def cut_ticket(file) do
    IO.binwrite file, [0x1d,0x56,0x41,0x40]
  end
end

defmodule Receipt do
  use Application
# ESC/POS helping bits:
  @esc 0x1b
  @gs  0x1d
  @lf  0x0a

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

  def print_ticket() do
    #System.cmd "png2pos", ["-c", "test/logo.png"]
    File.copy "test/logo.prn", "ticket.prn"
    {:ok, file} = File.open("ticket.prn", [:binary,:append])
    #{:ok, file} = File.open("ticket.prn", [:binary,:write])
    IO.binwrite file, [@esc,"@"] # Reset to defaults
    open_drawer file
    IO.binwrite file, [@esc,"a",0x01] # Centered
    #IO.binwrite file, [@esc,"E",0x01] # Bold on
    #IO.binwrite file, ["Ozio Caff", 0x82, @lf]
    #IO.binwrite file, [@esc,"E",0x00] # Bold off
    IO.binwrite file, ["El caf", 0x82, " de Colombia al estilo italiano", @lf]
    #IO.binwrite file, ["Todos merecemos unos minutos de Ozio", 0x0a]
    cut_ticket file
    System.cmd "dd", ["if=ticket.prn","of=/dev/usb/#{find_printer}"]    
  end

  def open_drawer(file) do
    IO.binwrite file, [@esc,"p",0x00,25,250]
  end

  def cut_ticket(file) do
    IO.binwrite file, [@gs,"V",0x41,0x40]
  end

  def print_barcode(file, code) do
    IO.binwrite file, [@gs,"h", 0x80] # Barcode height
    IO.binwrite file, [@gs,"f", 0x00] # font
    IO.binwrite file, [@gs,"H", 0x02] # number position
    IO.binwrite file, [@gs,"k", 0x04] # print the barcode
    IO.binwrite file, [code, 0x00, 0x0a]
  end

end

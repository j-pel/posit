defmodule Store do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Store.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: Store.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc ~S"""
  Parses the given instruction into a command.

  ## Examples

      iex> Store.parse "CREATE order\r\n"
      {:ok, {:create, :order}}

      iex> Store.parse "GET order 1\r\n"
      {:ok, {:get, :order, "1"}}

  """
  def parse(line) do
		case String.split(line) do
			["CREATE", "order"] -> {:ok, {:create, :order}}
			["GET", "orders"] -> {:ok, {:get, :orders}}
			["GET", "order", key] -> {:ok, {:get, :order, key}}
			["PUT", "order", key, value] -> {:ok, {:put, :order, key, value}}
			["DELETE", "order", key] -> {:ok, {:delete, :order, key}}
			_ -> {:error, :unknown_command}
		end
  end

	@doc ~S"""
  Runs the given command.

      iex> Store.run {:get, :order, "1"}
      [{1, :undefined, :undefined, :undefined, :undefined, :undefined, "2015-07-23 23:15:09", :undefined, :undefined, :undefined}]

  """
	def run(command)

	def run({:get, :orders}) do
    {:ok, db} = :esqlite3.open('test/till.db3')
		[{n}] = :esqlite3.q('select rowid from orders order by rowid desc limit 1', db)
    {:ok, orders: n}
	end

	def run({:create, :order}) do
    {:ok, db} = :esqlite3.open('test/till.db3')
    :ok = :esqlite3.exec('insert into orders (`x`, `y`) values (43,34)',db)
		[{n}] = :esqlite3.q('select last_insert_rowid()', db)
    {:ok, order: n}
	end

	def run({:get, :order, key}) do
    {:ok, db} = :esqlite3.open('test/till.db3')
    :esqlite3.q(['select * from orders where rowid=',key], db)
	end


end

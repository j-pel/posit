defmodule StoreTest do
  use ExUnit.Case
  doctest Store

  test "accesing sqlite3 database" do
    {:ok, db} = :esqlite3.open('test/till.db3')
    assert [{"2015-07-23 23:15:09"}] == :esqlite3.q('select order_time from orders limit 1',db)
  end
	
end
        

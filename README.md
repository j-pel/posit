#POSit

A distributed Point of Sale system for small business.

The idea is to use small computers such as Raspberry pi or the US$9 CHIP to form a distributed and decentralized network of cheap machines around one or multiple shops. Those machines will be responsible of keeping data and to retrieve data from fixed or mobile devices acting as tills or inventory machines.

## Installation

CHIPs are a better fit because of size, price and out-of-box wifi ability. Raspberry pi configuration is similar to the one described in here.
In order to prepare a CHIP to run POSit, flash a Debian release on the CHIP and then install Elixir following the default instructions.
Install the following:

    sudo apt-get install build-essential git

Clone this repository. Then go to posit main directory and run:

    mix deps.get
    mix deps.compile
    mix test 

Those small computers have single core ARM processors, so a default Erlang BEAM machine will complain with: "Non-SMP VMAborted". To overcome this, use the following command switch:

    ELIXIR_ERL_OPTIONS="-smp enable" mix test

All tests must succeed. After this step, your CHIP is ready to run POSit. Connect it to a receipt printer and a cash drawer and there you have a single wireless till for your shop.

To run POSit with an interactive Elixir shell, do the following:

    MIX_ENV=prod iex --erl "-smp enable" -S mix

If Elixir complains because it is expecting utf8, a tweak may be needed:

    sudo apt-get install locales
    sudo dpkg-reconfigure locales

Select the desired utf8 variant from the locales list and then logout and login again.

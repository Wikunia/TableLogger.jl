# TableLogger

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://wikunia.github.io/TableLogger.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://wikunia.github.io/TableLogger.jl/dev)
[![Build Status](https://github.com/wikunia/TableLogger.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/wikunia/TableLogger.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/wikunia/TableLogger.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/wikunia/TableLogger.jl)

**TableLogger.jl** is a Julia package which allows you to easily log data in a table for a nice visual tabular log. 
This can be used for your machine learning, optimization or any other project in which you want to have an updated line in your table every x seconds or whenever there was a significant change.

## Installation

Currently the package isn't registered yet so it needs to be installed via url i.e. with:

```julia
] add https://github.com/Wikunia/TableLogger.jl
```

## Usage

First you need to define the structure of the table that you want to display.

The following will create three columns `#Open`, `#Closed` and `Time [s]`.
```julia
table = init_log_table(
    (id=:open_nodes, name="#Open"),
    (id=:closed_nodes, name="#Closed"),
    (id=:time, name="Time [s]", width=10, alignment=:right);
    width = 20,
    alignment = :center
)
```

You can then print the header with:

```julia
print_header(table)
```

which will print:

```
       #Open              #Closed        Time [s] 
==================================================
```

now you can add values to the each column with `set_value!` i.e:

```julia
set_value!(table, :open_nodes, 10)
set_value!(table, :closed_nodes, 0)
set_value!(table, :time, 0.1)
```

then with `print_line(table)` a new line will be printed.
Such that together with the header your output would be:

```
       #Open              #Closed        Time [s] 
==================================================
         10                  0                0.1  
```


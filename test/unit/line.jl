@testset "Get line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
        (id=:closed_nodes, name="#Closed", alignment=:right),
        (id=:time, name="#Time", alignment=:left),
    )
    set_value!(table, :open_nodes, 10)
    set_value!(table, :closed_nodes, 20)
    set_value!(table, :time, 1.1)
    line = TableLogger.get_line(table)
    @test occursin("10", line)
    @test occursin("20", line)
    @test occursin("1.1", line)
    @test occursin("20  1.1", line)
    @test length(line) == sum(table.setup.widths)
end

@testset "Shall print line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
        (id=:closed_nodes, name="#Closed"),
    )
    set_value!(table, :open_nodes, 10)
    set_value!(table, :closed_nodes, 20)
    @test TableLogger.shall_print_line(table; force=true)
    @test TableLogger.shall_print_line(table)

    TableLogger.update_for_new_row(table)
    TableLogger.fill_from_prev!(table)

    @test !TableLogger.shall_print_line(table)
    @test TableLogger.shall_print_line(table; force=true)
end

@testset "Diff5 shall print line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
    )
    set_value!(table, :open_nodes, Diff5(10))
    @test TableLogger.shall_print_line(table; force=true)
    @test TableLogger.shall_print_line(table)

    TableLogger.update_for_new_row(table)
    set_value!(table, :open_nodes, Diff5(12))
    @test !TableLogger.shall_print_line(table)
    set_value!(table, :open_nodes, Diff5(15))
    @test TableLogger.shall_print_line(table)
end


@testset "DiffX shall print line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
    )
    Diff7 = DiffX(7)
    set_value!(table, :open_nodes, Diff7(10))
    @test TableLogger.shall_print_line(table; force=true)
    @test TableLogger.shall_print_line(table)

    TableLogger.update_for_new_row(table)
    set_value!(table, :open_nodes, Diff7(12))
    @test !TableLogger.shall_print_line(table)
    set_value!(table, :open_nodes, Diff7(15))
    @test !TableLogger.shall_print_line(table)
    set_value!(table, :open_nodes, Diff7(17))
    @test TableLogger.shall_print_line(table)
end

@testset "Diffd1 shall print line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
    )
    Diffd1 = DiffX(0.1)
    set_value!(table, :open_nodes, Diffd1(10.0))
    @test TableLogger.shall_print_line(table; force=true)
    @test TableLogger.shall_print_line(table)

    TableLogger.update_for_new_row(table)
    set_value!(table, :open_nodes, Diffd1(10.02))
    @test !TableLogger.shall_print_line(table)
    set_value!(table, :open_nodes, Diffd1(10.09))
    @test !TableLogger.shall_print_line(table)
    set_value!(table, :open_nodes, Diffd1(10.101))
    @test TableLogger.shall_print_line(table)
end
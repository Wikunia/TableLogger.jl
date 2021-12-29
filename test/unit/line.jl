@testset "Get line" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
        (id=:closed_nodes, name="#Closed"),
    )
    set_value!(table, :open_nodes, 10)
    set_value!(table, :closed_nodes, 20)
    line = TableLogger.get_line(table)
    @test occursin("10", line)
    @test occursin("20", line)
    @test length(line) == sum(table.setup.widths)
    @test line == "         10                  20         "
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
end
@testset "DisplayArray" begin

    io = IOBuffer()

    array = DS.DisplayArray(10, 40, background='.')

    @test repr(array) == "DisplayArray(" *
        "size=(10, 40), " *
        "background char=Char(46)" *
    ")"

    DS.render(io, array)
    @test String(take!(io)) ==
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m"

    array[6, 8] = '噢'
    DS.render(io, array)
    @test String(take!(io)) ==
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        ".......噢...............................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m"

    array[4:6, 8:19] = "這是一段\n非常感性的\n字串"
    DS.render(io, array)
    @test String(take!(io)) ==
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        ".......這是一段.........................\n\e[0m" *
        ".......非常感性的.......................\n\e[0m" *
        ".......字串.............................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m" *
        "........................................\n\e[0m"


    # style
    R, G, B = color = (255, 0, 0)
    style = [:bold, :underline, :blink]
    DS.render(io, array, style=style, color=color)
    @test String(take!(io)) ==
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        ".......這是一段.........................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        ".......非常感性的.......................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        ".......字串.............................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m" *
        "\e[38;2;$(R);$(G);$(B)m" *
        "\e[1m\e[4m\e[5m" *
        "........................................\n\e[0m"

end

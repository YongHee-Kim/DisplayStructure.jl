@testset "DisplayArray" begin

    array = DS.DisplayArray(10, 40, background='.')

    @test repr(array) == "DisplayArray(" *
        "size=(10, 40), " *
        "background char=Char(46)" *
    ")"

    DS.render(array)
    @test T.read_strem(T.out_stream)  ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    array[6, 8] = '噢'
    DS.render(array)
    @test T.read_strem(T.out_stream)  ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......噢...............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    array[4:6, 8:19] = "這是一段\n非常感性的\n字串"
    DS.render(array)
    @test T.read_strem(T.out_stream)  ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    # pos
    DS.render(array, pos=(5, 6))
    @test T.read_strem(T.out_stream)  ==
        "\e[5;6H" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

    # last index
    array[2, end-1] = '哈'
    DS.render(array)
    @test T.read_strem(T.out_stream)  ==
        "\e[s........................................\e[u\e[1B" *
        "\e[s......................................哈\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s.......這是一段.........................\e[u\e[1B" *
        "\e[s.......非常感性的.......................\e[u\e[1B" *
        "\e[s.......字串.............................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B" *
        "\e[s........................................\e[u\e[1B"

end

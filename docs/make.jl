using Pkg, Documenter, Literate, SmoothedParticles

#
# Replace SOURCE_URL marker with github url of source
#
function replace_source_url(input,source_url)
    lines_in = collect(eachline(IOBuffer(input)))
    lines_out = IOBuffer()
    for line in lines_in
        println(lines_out,replace(line,"SOURCE_URL" => source_url))
    end
    return String(take!(lines_out))
end

function make_all()
    #
    # Generate Markdown pages from examples
    #
    examples = [
        "static_container.jl",
        "collapse_dry.jl",
        "collapse_dry_implicit.jl",
        "cavity_flow.jl",
        "cylinder.jl",
        "drop.jl",
        "collapse3d.jl",
        "collapse_symplectic.jl",
        "Kepler_vortex.jl"
    ]
    example_md_dir  = joinpath(@__DIR__,"src","examples")
    generated_examples = []

    for example in examples
        base,ext=splitext(example)
        if ext==".jl"
            Literate.markdown(joinpath(@__DIR__,"..","examples",example),
                              example_md_dir,
                              documenter=false,
                              info=false
                             )
            push!(generated_examples, joinpath("examples", base*".md"))
        end
    end


    #generated_examples=joinpath.("examples",readdir(example_md_dir, sort = false))
    println(generated_examples)

    makedocs(
        sitename="SmoothedParticles.jl",
        clean = true,
        doctest = true,
        authors = "O. Kincl",
        modules = [SmoothedParticles],
        format = Documenter.HTML(prettyurls = false),
        pages=[
            "Home"=>"index.md",
            "Examples" => generated_examples,
            "API Documentation" => [
                "core.md",
                "kernels.md",
                "structs.md",
                "geometry.md",
                "IO.md",
                "grids.md",
                "algebra.md"
            ],
        ]
    )
end

make_all()

deploydocs(
    repo = "github.com/OndrejKincl/SmoothedParticles.jl.git",
)  

using Documenter
using ReplGPT

makedocs(sitename = "ReplGPT", format = Documenter.HTML(), modules = [ReplGPT])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(repo = "https://github.com/ThatcherC/ReplGPT.jl.git")

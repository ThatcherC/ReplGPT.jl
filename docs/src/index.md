# ReplGPT.jl

Documentation for ReplGPT.jl

```@contents
```

## Key Management Functions

```@docs
ReplGPT.getAPIkey()
```

```@docs
ReplGPT.setAPIkey(key::String)

ReplGPT.clearAPIkey()
```

## Model Selection

```@docs
ReplGPT.setmodelname(model::String)

ReplGPT.getmodelname()

ReplGPT.clearmodelname()
```

## Conversation Management

```@docs
ReplGPT.initialize_conversation()

ReplGPT.save_conversation(filepath)
```

## Output Formatting

```@docs
ReplGPT.setFormatter(f::Function)

ReplGPT.markdown(s::String)

ReplGPT.plaintext(s::String)
```


## Index

```@index
```

# ihl

IHL is a language in ideation aimed at reducing the pain of developing LLM applications.

## motivation

Most LLMs are programmed (prompted) with natural language, so naturally, a large portion of the development lifecycle is spent on writing and debugging language prompts and templates. This primary modality of model interaction lends itself to the ubiquitous use of string manipulation, *a pattern most beloved by all /s*.

Of course there are many solutions to avoid manually manipulating strings for the specific use case of LLM application development. These libraries and frameworks do their level best to provide a pleasing developer experience by hiding away raw strings manipulation behind a swath of modules, classes, and template constants.

While nothing is inherently wrong with abstracting away the ugly bits, I believe most do so to an extreme degree. When a framework makes it difficult to see the templates and prompts used to invoke a completion, it can be infuriating and counterproductive to the development process. No one wants to descend so far down the callstack they forget what they were looking for in the process (talking about you LangChain).

This frustration is often only felt when using non-OpenAI models, as most of the tooling has first-class support for Sam Altman's GPTs. However, not all organizations are able to use OpenAI; whether for data locality, privacy, compliance, cost, or any other reasons.

After building more than my fair share of LLM applications using various frameworks and models, I say with utmost confidence: **I Hate LLMs**. If I'm to retain ownership of my sanity, I need a better way of developing these applications.

## vision

I settled on solving these problems with a domain specific language purpose built to support the templating, prompting, parsing, and chaining tasks of developing apps with LLMs. 

With the language frontend, I feel compelled to go in the opposite direction to existing solutions: I want a content-first (prompt strings) templating language with a small set of non-string control flow. 

Since we're in the land of the language models, we shouldn't have to go hunting for the directives we give to them, so I want to limit nesting to a few levels at maximum.

Ideally the language should be able to target multiple backends, since I don't want to write a runtime or support the massive amount of libraries, models, and toolkits that exist for making LLM apps. *This requirement is vague and uncertain, and I don't have any decent ideas yet for how anyone other than myself would want to integrate this DSL into their workflows.*

For now it will target LangChain as a backend, since that's what I'm working with right now.

## ideas scratchpad

Very early language samples, the goal is to nail down primitives and avoid re-inventing the same thing as everyone else

### Tool

plain keywords:

```
tool WikipediaLookup {
    with query
    do   Look up information using wikipedia
}

OR

tool WikipediaLookup with Query {
    Look up information using wikipedia
}

OR

tool WikipediaLookup with Query:
    Look up information using wikipedia
```

`@`-prefixed keywords:

```
@tool WeatherLookup {
    @with location
    @do  Look up information about the weather
}
```

embedded tool?

```
@tool AddTwo {
    @with 
        first
        second
    @do Add two numbers together 
    @python first + second
}
```


### Template

plain keywords, variables `@`-prefixed - don't like the `@<tool> with @<input>` statement too much

edit: this one has gotten away from me, not sure what it does anymore.

```
template ZeroShotReAct {
    with @input
    use
        @WikipediaLookup
        @WeatherLookup
    start
        Solve a question answering task with interleaving Thought, Action, 
        and Observation steps. You have access to the following tools:

        @tools

        Question: the input question you must answer
        Thought: you should always think about what to do
        Action: the action to take, should be one of @tools
        Action Input: the input to the action
        Observation: the result of the action
        ... (this Thought/Action/Action Input/Observation)
        Thought: I now know the final answer

        Begin!

        Question: @input
        Thought:
    stop Observation
    with 
        @act Action
        @inp Action Input
    inject @act with @inp
    repeat Observation
    stop
}
```

maybe too many `@`s?

```
@template ZeroShotReAct {
    @with input
    @use
        WikipediaLookup
        WeatherLookup
    @do
        Solve a question answering task with interleaving Thought, Action, 
        and Observation steps. You have access to the following tools:

        @@tools

        Question: the input question you must answer
        Thought: you should always think about what to do
        Action: the action to take, should be one of @@tools
        Action Input: the input to the action
        Observation: the result of the action
        ... (this Thought/Action/Action Input/Observation)
        Thought: I now know the final answer

        Begin!

        Question: @@input
        Thought:
    @pause @parse Observation
        @@act @parse Action
        @@inp @parse Action Input
        @@obs @call act @with inp
}
```

Declare agent tools with `@tool`, tool inputs with `@with`, LLM directive with `@do`:

``` 
@tool <TOOL_NAME> {
    @with <TOOL_INPUT>
    @do   <TOOL_DIRECTIVE>
}
OR
@tool <TOOL_NAME> {
    @with
        <TOOL_INPUT_1>
        <TOOL_INPUT_2>
        ...
        <TOOL_INPUT_N>
    @do
        <MULTI_LINE...>
        ...
        <...TOOL_DIRECTIVE>
}
```

Other thoughts:

- Maybe svelte-inspired format would work, include language code (py/js/go/...) and template in the same file
- Maybe SQL CTE-style syntax
    - `WITH [TOOLS|VARIABLES|PARSERS] DO [PROMPTS|TEMPLATES]` ???

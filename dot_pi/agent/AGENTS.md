# Subagent fan-out

When a request covers two or more areas that can be investigated separately — separate
modules, repos, or questions — launch them as parallel children before reading any of it:

    subagent({ workflow: "parallel", args: { tasks: [
      { agent: "scout", task: "<one area: what to find>" },
      { agent: "scout", task: "<another area: what to find>" },
    ] } })

An area qualifies when one reader could answer it without reading what another child reads.
Synthesize the children's reports; do not re-read their sources yourself.
Single-file edits, write tasks, and sequential work stay in the parent.

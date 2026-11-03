# Subagents

Delegate the reading; keep the writing. A child's intermediate output never enters this
conversation, so the parent pays for its report, not for the pile of files behind it.

Launch a child when a request:
- covers two or more areas a separate reader could answer on its own (a comparison still
  fans out per area — the parent writes the comparison);
- needs a broad sweep: repo-wide search, more than a handful of files, external research;
- would otherwise flood this conversation with intermediate output.

Stay inline for one file read, one grep, a small edit, or anything answerable in one turn.

    subagent({ agent: "scout", task: "<what to find, what to quote, what to skip>" })

    subagent({ workflow: "parallel", args: { tasks: [
      { agent: "scout", task: "<area A>" },
      { agent: "scout", task: "<area B>" },
    ] } })

Brief each child with exact paths, the question, and the shape of the answer you want.
Write the deliverable, make the edits, and decide yourself. Never re-read what a child
read or duplicate its work; after launching, do not poll — finish local work and let
completion wake you.

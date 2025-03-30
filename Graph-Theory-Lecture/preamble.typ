#import "@preview/dvdtyp:1.0.1": * // template
#import "@preview/lovelace:0.3.0": * // pseudocode
#import "@preview/mitex:0.2.5": * // latex to typst
#import "@preview/quick-maths:0.2.1": shorthands
#import "@preview/diagraph:0.3.2": * // graph
#import "@preview/codly:1.3.0": * // code block
#import "@preview/codly-languages:0.1.1": *





// link format
#show link: set text(fill: blue)

// math notation overloads
#show: shorthands.with(
  ($+-$, $plus.minus$),
  ($|-$, math.tack),
  ($<--$, math.arrow.l.double.long),
  ($-->$, math.arrow.r.double.long),
  ($<-->$, math.arrow.l.r.double.long)
)


/**
#set math.equation(
  numbering: "(1)", 
  supplement: [Eq.],
  block: true
  )
 */

#let theorem-style = builder-thmbox(color: colors.at(6), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let exercise = theorem-style("exercise", "Exercise")

#let lemma-style = builder-thmbox(color: colors.at(4), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let lemma = lemma-style("lemma", "Lemma")

#let remark-style = builder-thmbox(color: colors.at(15), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let remark = remark-style("remark", "Remark")

#let proposition-style = builder-thmbox(color: colors.at(8), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let proposition = proposition-style("proposition", "Proposition")

#let definition-style = builder-thmbox(color: colors.at(10), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let definition = definition-style("definition", "Definition")

#let axiom-style = builder-thmbox(color: colors.at(3), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let axiom = axiom-style("axiom", "Axiom")

#let example-style = builder-thmbox(color: colors.at(16), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let example = example-style("example", "Example")

#let problem-style = builder-thmbox(color: colors.at(2), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let problem = problem-style("problem", "Problem")

#let exercise-style = builder-thmbox(color: colors.at(0), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let exercise = exercise-style("exercise", "Exercise")

#let solution-style = builder-thmbox(color: colors.at(1), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let solution = solution-style("solution", "Solution")

#let hint-style = builder-thmbox(color: colors.at(14), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let hint = hint-style("hint", "Hint")

#let notation-style = builder-thmbox(color: colors.at(12), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let notation = notation-style("notation", "Notation")

#let previosTemplate = adjacency(
    (
    (none, "", "", ""),
    (none, none, "", ""),
    (none, none, none, ""),
    (none, none, none, none),
    ),
    rankdir: "LR",
    directed: false,
    vertex-labels: ("A", "B", "C", "D")
  )
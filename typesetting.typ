#import "@preview/ctheorems:1.1.3": *
#import "@preview/gentle-clues:1.2.0"
#import "@preview/quick-maths:0.2.1"
#import "@preview/stack-pointer:0.1.0"
#import "@preview/mitex:0.2.5"
#import "@preview/algo:0.3.5"
#import "@preview/codedis:0.1.0"
#import "@preview/physica:0.9.5": *
#import "@preview/codly:1.2.0"
#show: thmrules

/**

#let definition = thmbox(
 "definition", // identifier
 "Definition", // head
 fill: rgb("#e8f8e8"), // background color
)

#let theorem = thmbox(
 "theorem", // identifier
 "Theorem", // head
 fill: rgb("#e8e8f8")
)

#let example = thmplain(
 "example",
 "Example",
 titlefmt: strong,
).with(numbering: none)


 */

#let lemma = thmplain(
  "lemma",
  "Lemma",
  titlefmt: strong,
)

#let corollary = thmplain(
 "corollary", 
 "Corollary", 
 titlefmt: strong,
)

#let remark = thmbox(
  "remark",
  "Remark",
  fill: rgb("#f8e8e8"),
  titlefmt: strong,
).with(numbering: none)
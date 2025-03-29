#import "@preview/dvdtyp:1.0.1": * // template
#import "@preview/lovelace:0.3.0": * // pseudocode
#import "@preview/cetz:0.3.3"  // plot
#import "@preview/mitex:0.2.5": * // latex to typst
#import "@preview/quick-maths:0.2.1": shorthands
#import "@preview/diagraph:0.3.2": * // graph

#let is_lecture = false

#show: dvdtyp.with(
  title: "From Structural Induction to Graph Theory",
  subtitle: [Motivation, Algroithms, Applications, and Correctness],
  author: "Eric Yang Xingyu",
  abstract: "This is a handout for the lecture on graph theory for my fellows. It covers the basic concepts of graph theory, including the definition of graphs, trees, and the basic algorithms for graph traversal. The handout also includes the correctness proof of the algorithms. Before delve into the graph theory, we will first introduce the concept of structural induction, which is the foundation of the correctness proof of the graph algorithms, and other structural algorithms.",
)

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
#let notation = definition-style("notation", "Notation")

#outline()
//#pagebreak()

= From Induction to General Induction
#remark[
  This lecture note is compiled using typst, and has two versions, one for the lecturer and one for the
  student. The latter version will be used during the lecture as handouts for the students. After the
  lecture, the lecturer version will be shared with students for further study or reference, which contains
  hints for lecture and solution/proofs for examples and exercises.
]
== Recap on Induction
#definition("Induction")[
  Induction is a method of proof in which we prove that a statement is true for all natural numbers by proving that it is true for the smallest natural number and then proving that if it is true for some natural number, then it is true for the next natural number.
]

The most common use case of induction is to prove a statement defined on the natural numbers. 
#example[
  Prove that $1 + 2 + 3 ... + n = n(n+1)/2$ for all $n >= 1$.
]
#proof[
  Not discussed as it is trivial.
]
#if is_lecture{
  hint[
  - Different points of view on understanding the statement:
    + RHS is a mapping, say $f: NN -> NN$, where $f(n) = n(n+1)/2$, moreover, it is a closure.
    + LHS is a series expression of the function $f(n) = n(n+1)/2$, where $n in NN$
  - Discuss can we change the quantifier to $forall n >= 0$.
  ]

  
}


=== Motivation & Assumption
#if is_lecture {
  hint[
    - Based on the prociple of induction, also known as the fifth axiom of the natural numbers, we can prove that a statement is true for all natural numbers.
    - Brief on the completeness of the natural numbers, which is the foundation of induction.
  ]
}
The principle of induction is based on the completeness of the natural numbers, which is the foundation of the induction. The completeness of the natural numbers is the property that every non-empty subset of the natural numbers has a least element. This property is the foundation of the induction, which allows us to prove a statement for all natural numbers by proving it for the smallest natural number and then proving that if it is true for some natural number, then it is true for the next natural number.

#definition("Naive Definition of Natural Numbers")[
  The natural numbers are the set of positive integers, possibly including zero.
]

Is $0 in NN$ is a question that has been debated for centuries until now. In different branches of mathematics, the definition of natural numbers varies. In this lecture, we will use $NN_0$ for the set of natural numbers including zero, and $NN$ for the set of natural numbers excluding zero.
#if is_lecture{
  hint[
    - in number theory and algebra, $0 in NN$ is not included.
    - in set theory, $0 in NN$ is usually included.
    - in computer science, $0 in NN$ is included.
    - mension what is an axiom and why we need it.
  ]
}

#axiom("Peano Axioms")[
  The Peano axioms are a set of axioms for the natural numbers presented by the 19th-century Italian mathematician Giuseppe Peano. These axioms define the natural numbers as a set of objects, a number system, and a set of operations.
  1. $0 in NN$
  2. $forall n in NN, n+1 in NN$
  3. $forall n in NN, n+1 != 0$
  4. $forall n, m in NN, n+1 = m+1 => n = m$
  5. (Induction) If a set $S$ of natural numbers contains $0$ and also the successor of every number in $S$, then $S = NN$.
]

#remark[
  It is quite normal in both computer science and mathematics that a extremely complex system can be built on a few simple rules, or we say axioms here. Some examples are
  systems of differential equations, recurrence relations, etc. 
]

#if is_lecture{
  [
  ]
  hint("counter-examples if we remove some axioms")[
    - If we remove the axiom 1, then $NN$ will not contain $0$.
    - If we remove the axiom 2, then $NN$ will not contain the successor of every number.
    - If we remove the axiom 3, then 0 can be a successor of some number. In this case, the predecessor of 0 can only be -1, which is not in $NN$.
    - If we remove the axiom 4, then the successor function is not injective, meaning that a predecessor can not determine the successor uniquely.
    - If we remove the axiom 5, then the principle of induction is not valid.
    - We do not discuss in details as it is not the focus of this lecture.
  ]
}

=== Weak Induction
#definition("Weak Induction")[
  Weak induction is a method of proof in which we prove that a statement is true for all natural numbers by proving that it is true for the smallest natural number and then proving that if it is true for some natural number, then it is true for the next natural number. Formally, let $P(n)$ be a statement for each $n in NN_0$. If $P(0)$ is true, and $forall k in NN_0, P(k) => P(k+1)$, then $forall n in NN_0, P(n)$ is true.
]

#example[
  Prove that $forall n in NN_0, 3 divides n^3+2n$.
]
#remark[
  The statement $3 divides n^3+2n$ means that $n^3+2n$ is divisible by 3, which means that 
  $ exists m in ZZ: n^3+2n = 3m. $
  Accordingly, if $3 divides.not n^3+2n$, then $n^3+2n$ is not divisible by 3, which means that 
  $
    exists m in ZZ: n^3+2n =  3m + r, r in ZZ_(>0)^(<3)
  $
]

#if is_lecture{
  proof[
    We will prove this statement using weak induction.
    - Base case: $P(0)$ holds since $0 = 3 times 0 + 0$.
    - Inductive step: Assume $P(k)$ is true, prove $P(k+1)$ is true. We have
    $
      k^3 + 2k = 3m, m in NN_0,
    $
    and we want to prove that $P(k+1)$ is true:
    $
      (k+1)^3 + 2(k+1) = 3m, m in NN_0.
    $
    By expanding the left side, we have
    $
      "LHS" = (k^3 + 3k^2 + 3k + 1) + (2k + 2)
    $
    Rearrange the terms, we have
    $
      "LHS" = (k^3 + 2k) + 3k^2 + 3k + 3,
    $
    where $P(k) => k^3 + 2k = 3m$.
    Hence 
    $
      "LHS" = 3m + 3(k^2 + k + 1) = 3(m + k^2 + k + 1),
    $
    where $m + k^2 + k + 1$ is some natural number, as $m, k in NN_0$.
    Therefore, $P(k+1)$ is true.
    - Conclusion: by the principle of induction, we have $forall n in NN_0, P(n)$ is true.
    
  ]
}
- Chain of logic
  - Base case: $P(0)$ holds.
  - Inductive step: Assume $P(k)$ is true, prove $P(k+1)$ is true. Finally we have
  $
    forall k>=0, P(k) => P(k+1)
  $
  - Conclusion: by the principle of induction, we have $forall k>=0, P(k)$ is true.
=== Strong Induction
#definition("Strong Induction")[
  Strong induction is a method of proof in which we prove that a statement is true for all natural numbers by proving that it is true for the smallest natural number and then proving that if it is true for all natural numbers less than or equal to some natural number, then it is true for the next natural number. Formally, let $P(n)$ be a statement for each $n in NN_0)$. If $P(0)$ is true, and $forall k in NN_0, (forall m<=k, P(m)) => P(k+1)$, then $forall n in NN, P(n)$ is true.
]

#example[
  Prove that every integer greater than 1 can be written as a product of prime numbers.
]
#if is_lecture{
  proof[
    We will prove this statement using strong induction.
    - Base case: $P(2)$ holds since 2 is a prime number.
    - Inductive step: Assume $P(k)$ is true for all $k <= n$, prove $P(n+1)$ is true. 
    
    We have two cases:
      If $n+1$ is a prime number, then $P(n+1)$ holds.
      If $n+1$ is not a prime number, then $n+1 = a times b$, where $a, b in NN_0$ and $a, b < n+1$. By the inductive hypothesis, $a$ and $b$ can be written as a product of prime numbers. Therefore, $n+1$ can be written as a product of prime numbers.
    - Conclusion: by the principle of induction, we have $forall n in NN_0, P(n)$ is true.
  ]
}
- Chain of logic: 
  - Base case: $P(0)$ holds.
  - Inductive step: Assume $P(0), P(1), ..., P(k)$ are true, prove $P(k+1)$ is true. Finally we have
  $
    forall k>=0,  (forall m<=k, P(m)) => P(k+1) "or"\
    forall k>=0, (P(0) and P(1) and ... and P(k)) => P(k+1) "or"\
    forall k>=0, and.big_(m<=k) P(m) => P(k+1)
  $

=== Generalised Induction
#definition("Generalised Induction")[
  Generalised induction is a method of proof in which we prove that a statement is true for all objects in a set by proving that it is true for the smallest object and then proving that if it is true for all objects smaller than or equal to some object, then it is true for the next object. Formally, we implicitly define a bijection between the set of objects and the natural numbers, and then prove the statement for all natural numbers, as what we do in normal induction.
]
- pattern:
  - The conclusion holds when the structure is minimized.
  - Assume the conclusion holds for all smaller sub-structures, prove the conclusion holds for the current structure.
  - The conclusion holds for all structures.
- Why Generalize Induction?
  - Natural numbers are insufficient for complex structures (e.g., proving properties of graphs or programs).
  - Unified framework: Well-foundedness captures the essence of induction, allowing it to apply broadly.

==== Structural Induction
#definition("Structural Induction")[
  Structural induction is a generalisation of mathematical induction to data structures. It is a method of proof in which we prove that a property holds for all elements of a data structure by proving that it holds for the smallest elements and then proving that if it holds for all sub-structures of some element, then it holds for the element itself.
]


#if is_lecture{
  hint[
    To show the definition of string and character before proceed to the example.
  ]
}
In the context of computer science, we often use structural induction, which is a kind of generalised induction, to prove properties of data structures including strings, trees, and graphs.

#example("Well-formed Parentheses")[
  A Well-formed string of parentheses is a string that consists of a series of opening and closing parentheses, such that each closing parenthesis matches the most recent unmatched opening parenthesis. For example, the strings "(()())" and "((()))" are well-formed, while the strings "())(" and "(()" are not well-formed. Prove that every well-formed string of parentheses has an equal number of opening and closing parentheses.
]

#remark[
  #let open = "open"
  #let close = "close"
  Let $Sigma = { (, ) }$. Let $Sigma^*$ be the set of all finite strings over $Sigma$.
  Let $open: Sigma^* -> NN_0$ and $close: Sigma^* -> NN_0$ be functions counting the number of opening and closing parentheses in a string $S$, respectively. ($NN_0$ denotes the set of non-negative integers).
  The set of *Well-Formed Parentheses* strings, denoted $"WFP"$, is a subset of $Sigma^*$ defined recursively as the smallest set satisfying:

    [*Base Case:*] The empty string $lambda$ is in $"WFP"$.

    [*Recursive Step 1:*] If $S'$ is in $"WFP"$, then the string $( S' )$ is in $"WFP"$, where (S') is the concatenation of $S'$ with an opening and closing parenthesis.
    
    [*Recursive Step 2:*] If $S'$ and $T'$ are in $"WFP"$, then their concatenation $S' T'$ is in $"WFP"$.
]
#if is_lecture{
  let open = "open"
  let close = "close"
  proof[
  We want to prove the property $P(S): open(S) = close(S)$ holds for all $S in "WFP"$ using structural induction on the definition of $"WFP"$.

  *Base Case:* We need to show $P(lambda)$ holds.
  For the empty string $S = lambda$, we have $open(lambda) = 0$ and $close(lambda) = 0$.
  Since $0 = 0$, $P(lambda)$ holds.

  *Inductive Step:* We consider the two ways a non-empty well-formed string can be constructed according to the recursive definition.

    *Case 1: Construction via Rule (2)*
    Assume the property holds for some $S' in "WFP"$ (this is the Inductive Hypothesis, IH1). That is, assume $P(S')$ holds, meaning $open(S') = close(S')$.
    We need to show that the property also holds for $S = ( S' )$.
    By definition of the counting functions:
    $ open(S) = open(( S' )) = 1 + open(S') $
    $ close(S) = close(( S' )) = 1 + close(S') $
    Using the Inductive Hypothesis (IH1), $open(S') = close(S')$. Substituting this into the equation for $open(S)$:
    $ open(S) = 1 + open(S') = 1 + close(S') $
    Comparing this with the equation for $close(S)$, we see $open(S) = close(S)$.
    Thus, $P((S'))$ holds.

    *Case 2: Construction via Rule (3)*
    Assume the property holds for some $S' in "WFP"$ and $T' in "WFP"$ (this is the Inductive Hypothesis, IH2). That is, assume $P(S')$ and $P(T')$ hold, meaning $open(S') = close(S')$ and $open(T') = close(T')$.
    We need to show that the property also holds for the concatenation $S = S' T'$.
    By definition of the counting functions for concatenation:
    $ open(S) = open(S' T') = open(S') + open(T') $
    $ close(S) = close(S' T') = close(S') + close(T') $
    Using the Inductive Hypothesis (IH2), $open(S') = close(S')$ and $open(T') = close(T')$. Substituting these into the equation for $open(S)$:
    $ open(S) = open(S') + open(T') = close(S') + close(T') $
    Comparing this with the equation for $close(S)$, we see $open(S) = close(S)$.
    Thus, $P(S' T')$ holds.

    *Conclusion:* Since the property $P(S)$ holds for the base case ($lambda$) and is preserved under both recursive construction rules (Rules 2 and 3), by the principle of structural induction, we conclude that $open(S) = close(S)$ for all well-formed parentheses strings $S in "WFP"$.
]
}

#example[
#let charset = $Sigma^*$
#let char = $Sigma$
  Let $char$ be a finite alphabet. A string over $char$ is a finite sequence of characters from $char$ recursively defined by the alphabet. We use $charset$ to denote the set of all strings over $char$. For some string $w in charset$, let $w^R$ denote the reversed string of $w$. Prove that for any two strings $w_1, w_2 in charset$, 
  $
    w_1^R w_2^R = (w_2 w_1)^R
  $  
Note: you may use $lambda$ to denote the empty string. Additionally, $w^R$ is recursively defined as follows:
- If $w = lambda$, then $w^R = lambda$.
- If $w = x w'$, where $x in char$ and $w' in charset$, then $w^R = w'^R x$.

]
#if is_lecture{
  let charset = $Sigma^*$
  let char = $Sigma$
  proof[
  Let $P(w_1)$ be the statement "for all $w_2 in charset$, $w_1^R w_2^R = (w_2 w_1)^R$". We prove $P(w_1)$ holds for all $w_1 in charset$ by structural induction on $w_1$.

  *Base Case:* $w_1 = lambda$.
  We need to show $P(lambda)$, which is $lambda^R w_2^R = (w_2 lambda)^R$ for all $w_2 in charset$.
  - The left-hand side (LHS) is $lambda^R w_2^R = lambda w_2^R = w_2^R$ (by definition $lambda^R = lambda$ and property of $lambda$).
  - The right-hand side (RHS) is $(w_2 lambda)^R = (w_2)^R = w_2^R$ (by property of $lambda$).
  Since LHS = RHS, the base case holds.
  
  *Inductive Step:* Assume $P(w_1')$ holds for some $w_1' in charset$. That is, assume the 
  
  *Inductive Hypothesis (IH)*:
  $ w_1'^R w_2^R = (w_2 w_1')^R quad "for all " w_2 in charset $
  We need to show that $P(x w_1')$ holds for any character $x in char$. That is, we need to prove:
  $ (x w_1')^R w_2^R = (w_2 (x w_1'))^R quad "for all " w_2 in charset $
  Let's evaluate the LHS and RHS separately.
  - LHS: $(x w_1')^R w_2^R = (w_1'^R x) w_2^R$
    $  " by recursive definition of reverse: " (u v)^R = v^R u^R " with " u=x, v=w_1' " gives " (x w_1')^R = w_1'^R x^R = w_1'^R x) $
    $ = w_1'^R (x w_2^R) quad " (by associativity of concatenation) " $
  - RHS: $(w_2 (x w_1'))^R$
    $ = ((w_2 x) w_1')^R quad " (by associativity of concatenation) " $
    Now, let $w_2' = w_2 x$. Note that $w_2' in charset$. We can apply the Inductive Hypothesis $P(w_1')$ with $w_2'$:
    $ = (w_2' w_1')^R = w_1'^R w_2'^R quad " (by IH applied to " w_1' " and " w_2' ") " $
    Substitute $w_2' = w_2 x$ back:
    $ = w_1'^R (w_2 x)^R $
    Now we evaluate $(w_2 x)^R$. We use the property $(u v)^R = v^R u^R$, which can be proven separately by induction using the base definition. Let $u = w_2$ and $v = x$.
    $ (w_2 x)^R = x^R w_2^R $
    Since $x$ is a single character, $x^R = x$.
    $ (w_2 x)^R = x w_2^R $
    Substitute this back into the RHS expression:
    $ = w_1'^R (x w_2^R) $
  Comparing the results:
  - LHS = $w_1'^R (x w_2^R)$
  - RHS = $w_1'^R (x w_2^R)$
  Since LHS = RHS, the inductive step holds.

  *Conclusion:* By the principle of structural induction, the statement $w_1^R w_2^R = (w_2 w_1)^R$ holds for all $w_1, w_2 in charset$.
]
}

- Other generalised induction(not covered in this lecture):
  - #link("https://encyclopediaofmath.org/wiki/Transfinite_induction")[Transfinite Induction]
  - #link("https://encyclopediaofmath.org/wiki/Noetherian_induction")[Noetherian Induction]


= Introduction to Graph Theory
#definition("Graph")[
  A graph $G$ is an ordered pair $G = (V, E)$, where $V$ is a set of vertices and $E$ is a set of edges. Each edge is a pair of vertices $(u, v)$, where $u, v in V$. We use $V(G)$ and $E(G)$ to denote the set of vertices and edges of $G$, respectively.
]
- In a nutshell, a graph is an abstraction of some tangible or intangible objects and their relationships.
- The vertices represent the objects, and the edges represent the relationships between the objects.

#figure(
  image("graphExample1.png", width: 45%),
  caption: "An example of a graph for road traffic",
)
- The above is a Directed Graph, where the edges have directions.
- The graph is also weighted, meaning that the edges have weights, or attached with a value.
- Using the notation $G = (V, E)$, we can represent the graph as $G = ({A, B, C, D}, {(A, B), (B, C), (C, A), (C, D), (D, B)})$.

== Some Basic Notions
#definition("Weight of Edges")[
  The weight of an edge in a graph is a value associated with the edge. The weight can represent the cost, distance, probability or any other value associated with the edge.
]

#definition("Direction of Edges")[
  The edges of a graph can be directed or undirected. In a *directed graph*, the edges have directions, meaning that the edge $(u, v)$ is different from the edge $(v, u)$. In an *undirected graph*, the edges do not have directions, meaning that the edge $(u, v)$ is the same as the edge $(v, u)$.
]


#let image1 = adjacency(
(
(none, "AB=BA"),
(none, none),
),
rankdir: "LR",
directed: false,
vertex-labels: ("A", "B")
)
#let image2 = adjacency(
(
(none, "AB"),
("BA", none),
),
rankdir: "LR",
directed: true,
vertex-labels: ("A", "B")
)
#figure(
  image1,
  caption: "Undirected Graph"
)
#figure(
  image2,
  caption: "Directed Graph"
)

#definition("Loop")[
  A loop is an edge that connects a vertex to itself. In a graph, a loop is an edge of the form $(v, v)$, where $v in V$.
]

#figure(
    adjacency(
    (
    ("", ""),
    (none, ""),
    ),
    rankdir: "LR",
    directed: true,
    vertex-labels: ("A", "B")
  ),
  caption: "Graph with a loop"
)

#definition("Simple Graph")[
  A simple graph is a graph in which there is at most one edge between any two vertices and no edge from a vertex to itself.
]

#let Yes = table.cell(fill: green.lighten(60%))[Yes]
#let No = table.cell(fill: red.lighten(60%))[No]
#let graphTypeTable = table(
  columns: (auto, auto, auto, auto),
  align: horizon,
  [Type], [Edges], [Multiple Edges?], [Loops Allowed?],
  [Simple graph], [Undirected], No, No,
  [Multigraph], [Undirected], Yes, No,
  [Pseudograph], [Undirected], Yes, Yes,
  [Simple directed graph], [Directed], No, No,
  [Directed multigraph], [Directed], Yes, Yes,
  [Mixed graph], [Directed and undirected], Yes, Yes,
)

#figure(
  caption: "Graph Typology",
  graphTypeTable  
)

== Applications of Graph
  Graphs are widely used in computer science, mathematics, and other fields to model relationships between objects. Some common applications of graphs include:
  - Social networks: representing relationships between people.
  - Road networks: representing roads and intersections.
  - Network traffic: representing data flow between devices.
  - Computer networks: representing connections between computers.
  - Scheduling: representing tasks and dependencies between tasks.
  - Circuit design: representing components and connections between components.
#example[
  An example of a graph for network traffic is the webpage ranking. Webpage ranking is an algorithm used by search engines to rank web pages in search results. The algorithm uses a graph to represent the web pages and the links between them. We cannot discuss the details of the algorithm here, but in this algorithm, we use a directed weighted graph to represent possibility of a user visiting a webpage from another webpage.
  #figure(
  image("webpageRanking.png", width: 50%),
  caption: "An example of a graph for network traffic",
)
We will look into the details of this example in matrix representation of a graph.
]

== More Terminologies
#definition("Degree of a Vertex")[
  The degree of a vertex $v$ in a graph is the number of edges incident to $v$. In an undirected graph, the degree of a vertex is the number of edges connected to the vertex. In a directed graph, the degree of a vertex is the sum of the in-degree and out-degree of the vertex, where the in-degree is the number of edges pointing to the vertex, and the out-degree is the number of edges pointing from the vertex.
]
#let degreeG = adjacency(
(
("AB", "AC"),
("BA", "CA"),
),
rankdir: "LR",
directed: false,
)
=== Path and Cycle
#definition("Path")[
  A path in a graph is a sequence of vertices in which each vertex is connected to the next vertex by an edge. A path is simple if it does not contain any repeated vertices.
]
For example, in the graph below, the sequence $A -> B -> C -> D$ is a path.
#figure(
  adjacency(
    (
    (none, "", "", ""),
    (none, none, "", ""),
    (none, none, none, ""),
    (none, none, none, none),
    ),
    rankdir: "LR",
    directed: false,
    vertex-labels: ("A", "B", "C", "D")
  ),
  caption: "A graph with cycle"
)<graphWithCycle>
We also introduce some special subsets of paths.
#definition("Cycle")[
  A cycle in a graph is a path that starts and ends at the same vertex. A cycle is simple if it does not contain any repeated vertices except the starting and ending vertex.
]
For example, in the previous graph, the sequence $A->B->C->D->A$ is a cycle.

==== Euler Path and Circuit
#definition("Euler Path")[
  An Euler path in a graph is a path that visits every edge exactly once. An Euler path may start and end at different vertices.
]
Still using @graphWithCycle as an example

#definition("Euler Circuit")[
  An Euler circuit in a graph is a cycle that visits every edge exactly once. An Euler circuit starts and ends at the same vertex.
]

=== Connected & Ascyclic Graph
#definition("Connected Graph")[
  A graph is connected if there is a path between every pair of vertices in the graph.
]
#definition("Acyclic Graph")[
  A graph is acyclic if it does not contain any cycles.
]
#definition("Complete Asyclic Graph")[
  A complete acyclic graph is a graph in which every pair of vertices is connected by a *unique* path.
]
#figure(
  adjacency(
    (
    (none, "", "", none),
    (none, none, none, none),
    (none, none, none, ""),
    (none, none, none, none),
    ),
    rankdir: "LR",
    directed: false,
    vertex-labels: ("A", "B", "C", "D")
  ),
)
#remark[
  A more well-known name for a complete acyclic graph is a *tree*.
]

=== Subgraph
#definition("Subgraph")[
  A subgraph of a graph $G = (V, E)$ is a graph $G' = (V', E')$ such that $V' subset.eq V$ and $E' subset.eq E$. That is, a subgraph is a graph that contains a subset of the vertices and edges of the original graph.
]
In a straightforward way, a subgraph is a graph that can be obtained by removing some vertices and edges from the original graph.

=== Complete Graph
#definition("Complete Graph")[
  A complete graph is a graph in which every pair of vertices is connected by an edge.
  The number of edges in a complete graph with $n$ vertices is
  $
    binom(n, 2) = n(n-1)/2.
  $
]
#figure(
  adjacency(
    (
    (none, "AB", "AC", "AD"),
    ("BA", none, "BC", "BD"),
    ("CA", "CB", none, "CD"),
    ("DA", "DB", "DC", none),
    ),
    rankdir: "LR",
    directed: true,
    vertex-labels: ("A", "B", "C", "D")
  ),
)
#remark[
  A complete graph with $n$ vertices is denoted by $K_n$.
]
=== Bipartite Graph
#definition("Bipartite Graph")[
  A bipartite graph is a graph whose vertices can be divided into two disjoint sets $V_1$ and $V_2$ such that every edge connects a vertex in $V_1$ to a vertex in $V_2$.
]
#if is_lecture{
  hint[
    To show the bipartite graph on the white board for clarification.
  ]
  
}
#figure(
  adjacency(
    (
    (none, none, "AC", "AD"),
    (none, none, "BC", "BD"),
    ("CA", "CB", none, none),
    ("DA", "DB", none, none),
    ),
    rankdir: "LR",
    directed: true,
    vertex-labels: ("A", "B", "C", "D")
  ),
)

=== Finite and Infinite Graph
#definition("Finite Graph")[
  A graph is finite if it has a finite number of vertices and edges.
]
#definition("Infinite Graph")[
  A graph is infinite if it has an infinite number of vertices or edges.
]
#remark[
  The concept of infinite graphs is essential in mathematics and computer science, especially in the study of infinite structures and algorithms on infinite structures.
]

#problem[
  Anything discussed earlier in the lecture can be abstract by a infinite graph?
]

== Useful Results on Graph
===  Handshaking Theorem
#theorem("Handshaking Theorem")[
  The handshaking theorem states that for any simple graph, the sum of the degrees of all vertices is equal to twice the number of edges. A loop at a vertex $v$ is typically counted as contributing 2 to $deg(v)$.

  Formally, let $G = (V, E)$ be an undirected graph with $m = |E|$ edges. Then
  $
    sum_(v in V) deg(v) = 2m.
  $
]
How can we prove it? Eventhough it is trivial, we can prove it by structural induction on the definition of a undirected graph.

#if is_lecture{
  proof[
    We can prove handshaking theorem by structural induction on the definition of a undirected graph.
    Base case: For a graph with no edges, the sum of the degrees of all vertices is 0, which is equal to twice the number of edges.
    
    Inductive step: Assume the handshaking theorem holds for some undirected graph $G$, such that 
    $ sum_(v in V) deg(v) = 2m. $
    Now we need to prove that adding an edge between any $v_1$, $v_2$ in $V$ preserves the theorem for a new graph $G'$, that is, 
    $
      sum_(v in V) deg(v) = 2(m+1).
    $

    Let $G' = (V, E')$ be the graph obtained by adding an edge between $v_1$ and $v_2$ to $G$. The number of edges in $G'$ is $m+1$.
    By the definition of undirected graph, an edge between $v_1$ and $v_2$ contributes 1 to the degree of both $v_1$ and $v_2$. Therefore, the sum of the degrees of all vertices in $G'$ is $m + 2 = 2(m+1)$.

    The same reasoning is still applicable when we add more vertices to the graph and connect a new vertex to the existing vertices. Therefore, the handshaking theorem holds for all undirected simple graphs.
  ]
}

#problem[
  There are 605 people in a party. Each person shakes hands with some other people. Suppose that each of them shakes hands with at least one person. Prove that there must be someone who shakes hands with at least two persons.
]
#if is_lecture{
  solution[
    Let $G = (V, E)$ be an undirected simple graph representing the handshaking relationships between the people at the party. The vertices of the graph represent the people, and the edges represent the handshaking relationships. By the handshaking theorem, the sum of the degrees of all vertices is equal to twice the number of edges. Since each person shakes hands with at least one person, the degree of each vertex is at least 1. Therefore, the sum of the degrees of all vertices is at least 605. By the handshaking theorem, the sum of the degrees of all vertices is equal to twice the number of edges. Since the sum of the degrees of all vertices is at least 605, the number of edges is at least 302.5, which is not an integer. Therefore, there must be at least one person who shakes hands with at least two people.
  ]
}

#theorem("Number of Vertices with Odd Degree")[
  In any simple graph $G$, the number of vertices with odd degree is always even.
]
#if is_lecture{
  proof[
    By handshaking theorem, the sum of the degrees of all vertices is equal to twice the number of edges. We split the vertice set $V$ into two disjoint sets $V_1$ and $V_2$, where $V_1$ contains the vertices with odd degree and $V_2$ contains the vertices with even degree. Let $n_1 = |V_1|$ and $n_2 = |V_2|$. Then we have
    $
      sum_(v in V_1) deg(v) + sum_(v in V_2) deg(v) = 2m,
    $
    where $m$ is the number of edges in the graph. Since the degree of each vertex in $V_2$ is even, the sum of the degrees of all vertices in $V_2$ is even. Therefore, the sum of the degrees of all vertices in $V_1$ must be even. Since each and every vertex in $V_1$ has an odd degree, and therefore $|V_1| = 2k$, where $k in NN$. Therefore, the number of vertices with odd degree is always even.
  ]
}

#problem[
  Prove that among a group of people($n>2$), there are at least 2 persons where the number of people they know is the same.
]
#if is_lecture{
  proof[
    We first translate the problem into graph theory language:
    for any simple graph $G = (V, E)$, where $V$ is the set of people and $E$ is the set of relationships, we need to prove that there are at least two vertices $v_1, v_2 in V$ such that $deg(v_1) = deg(v_2)$.

    Any vertices in a simple graph can have a degree from 0 to $n-1$, where $n$ is the number of vertices. 

    Yet it is implied that a vertex of degree 0 cannot be adjacent to any other vertex, and a vertex of degree $n-1$ is adjacent to all other vertices. 

    Therefore, the range of possible degrees for a vertex is $[1, n-1]$, while we have $n$ vertices. By the pigeonhole principle, there must be at least two vertices with the same degree.
  ]
}

== Representation of Graph
Graph can be represented in different ways, including adjacency matrix, adjacency list, and incidence matrix. Each representation has its own advantages and disadvantages, and the choice of representation depends on the specific problem being solved. We introduce two of the most common representations: adjacency matrix and adjacency list.
=== Adjacency Matrix
#definition("Adjacency Matrix")[
  An adjacency matrix is a square matrix used to represent a graph. The rows and columns of the matrix correspond to the vertices of the graph, and the entries of the matrix indicate whether there is an edge between the corresponding vertices. If there is an edge between vertices $u$ and $v$, the entry $a_(u v)$ is 1; otherwise, it is 0.

  If the graph is weighted, the entries of the adjacency matrix can be the weights of the edges instead of 0 or 1.
]

#example[
  Consider the graph $G = (V, E)$ with $ V = {A, B, C, D} $ and $ E = {(A, B), (B, C), (C, A), (C, D), (D, B)}. $ The adjacency matrix of $G$ is
  $
    mat(
    0, 1, 1, 0;
    1, 0, 1, 0;
    1, 1, 0, 1;
    0, 1, 1, 0
    )
  $
  #figure(
    adjacency(
    (
    (none, "", "", none),
    (none, none, "", none),
    (none, none, none, ""),
    (none, "", none, none),
    ),
    rankdir: "LR",
    directed: false,
    vertex-labels: ("A", "B", "C", "D")
    )
  )
]

==== Implementation
=== Adjacency List
#definition("Adjacency List")[
  Adjacency List 
]
==== Implementation
=== Trade-offs between Adjacency Matrix and Adjacency List
=== Graph Isomorphism


== Basic Graph Algorithms

=== Breadth-First Search
==== Definition
==== Implementation
==== Complexity Analysis
==== Correctness
=== Depth-First Search
==== Definition
==== Implementation
==== Complexity Analysis
==== Correctness



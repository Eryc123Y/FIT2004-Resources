
#import "graphUtils.typ": radialgraph
#import "preamble.typ": *
#import "@preview/cetz:0.3.4"
#show: codly-init
#let is_lecture = false
#codly(
  languages: (
    py: (
      name: "Python",
      icon: "🐍",
      color: rgb("#3572A5")
    )
  )
)
#show: dvdtyp.with(
  title: "From Induction to Graph Theory",
  subtitle: [Motivation, Algroithms, Applications, and Correctness],
  author: "Eric Yang Xingyu",
  abstract: "This is a handout for the lecture on graph theory for my fellows. It covers the basic concepts of graph theory, including the definition of graphs, trees, and the basic algorithms for graph traversal. The handout also includes the correctness proof of the algorithms. Before delve into the graph theory, we will first introduce the concept of structural induction, which is the foundation of the correctness proof of the graph algorithms, and other structural algorithms.",
)

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

==== Peano Axioms
#axiom("Peano Axioms")[
  The Peano axioms are a set of axioms for the natural numbers presented by the 19th-century Italian mathematician Giuseppe Peano. These axioms define the natural numbers as a set of objects, a number system, and a set of operations.
  1. $0 in NN$
  2. $forall n in NN, n' in NN, "where "n' "is called the successor of" n$
  3. $forall n in NN, n' != 0$
  4. $forall n, m in NN, n' = m' => n = m$
  5. $forall K subset.eq NN, 
    [0 in K and forall n(n in K => n' in K) => K = NN]$
]

#remark[
  It is quite normal in both computer science and mathematics that a extremely complex system can be built on a few simple rules, or we say axioms here. Some examples are
  systems of differential equations, recurrence relations, etc. 
]

#problem("Some Counter Examples")[
  - For a number system consists of only ${0}$, what axioms are violated?
  - For a number system consists of only ${0, 1}$, what axioms are violated?
  - For a number system consists of only ${0, 1, 2}$, what axioms are violated?
  - How can we find a counter example to show that axiom 5 is necessary?
  
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
#let pred = "pred"
#let succ = "succ"
==== Define Arithmetic Operations on Natural Numbers
We can define the arithmetic operations on natural numbers using the Peano axioms. 
#notation("pred and succ")[
  pred() and succ() are the predecessor and successor functions on natural numbers, respectively.
  formally, $pred: NN -> NN$ and $succ: NN -> NN$.
  We will use $pred(n)$ and $succ(n)$ to denote the predecessor and successor of $n$ in the following.
]

#definition("Addition on Natural Numbers")[
  The addition of two natural numbers $m$ and $n$ is defined recursively as follows:
  1. $m + 0 = m$
  2. $m + succ(n) = succ(m + n)$
]
#definition("Multiplication on Natural Numbers")[
  The multiplication of two natural numbers $m$ and $n$ is defined recursively as follows:
  1. $m times 0 = 0$
  2. $m times succ(n) = m times n + m$
]

#problem[
  How can we define the *subtraction* and *integer division* on natural numbers using the Peano axioms?
]

#if is_lecture{
  solution[
    We can define the subtraction and division on natural numbers using the Peano axioms in a similar way as we define the addition and multiplication.
    #definition("Subtraction on Natural Numbers")[
    The subtraction of two natural numbers $m$ and $n$ is defined recursively as follows:
    1. $m - 0 = m$
    2. $m - succ(n) = pred(m - n)$
    ]
    For the division, we can define it as the inverse operation of multiplication, which is a bit more complex. We will not discuss it in detail in this lecture.
    #definition("Division on Natural Numbers")[
    The integer division of two natural numbers $m$ and $n$ is defined recursively as follows:
    1. $m div n = 0$, if $m < n$
    2. $m div n = (m-n) div n + 1$, if $m >= n$
    ]
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

#remark[
  Using structual induction is always dependent on the recursive definition of the data structure we are working on.
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
  image("graphExample1.png", width: 35%),
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


// directed and undirected graph example graphs
#let image1 = radialgraph(
      nodes: ("A", "B", "C", "D"),
      edges: (
        ("A", "B"),
        ("B", "C"),
        ("C", "D"),
        ("D", "A"),
        ("A", "C"),
      ),
      radius: 1.8cm,
    )
#let image2 = radialgraph(
      nodes: ("A", "B", "C", "D"),
      edges: (
        ("A", "B"),
        ("B", "C"),
        ("C", "D"),
        ("D", "A"),
        ("A", "C"),
      ),
      radius: 1.8cm,
      directed: true,
    )
#let fig1 = figure(
  image1,
  caption: "Undirected Graph"
)
#let fig2 = figure(
  image2,
  caption: "Directed Graph"
)
#figure(
  grid(
  columns: 2,
  column-gutter: 20mm,
  fig1,
  fig2
  )
)



#definition("Loop")[
  A loop is an edge that connects a vertex to itself. In a graph, a loop is an edge of the form $(v, v)$, where $v in V$.
]

#figure(
    adjacency(
    (
    ("", ""),
    ("", ""),
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
]<networkTraffic>

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

#let cycleG = radialgraph(
  nodes: ("A", "B", "C", "D", "E"),
  edges: (
    ("A", "B"),
    ("B", "C"),
    ("C", "D"),
    ("D", "A"),
    ("A", "C"),

    ("D", "E"),
    ("E", "B"),
  ),
  radius: 1.8cm,
)
#figure(
  cycleG,
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

#definition("Euler Circuit")[
  An Euler circuit in a graph is a cycle that visits every edge exactly once. An Euler circuit starts and ends at the same vertex.
]

#problem[
  Can you find an Euler path/cycle in @graphWithCycle?
]

#theorem("Euler's Theorem")[
  Let $G = (V, E)$ be a finite, connected, undirected graph, then $G$:
  - Has an Euler path if and only if it has exactly two or zero vertices of odd degree.
  - Has an Euler circuit if and only if all vertices have even degree.
] 
#if is_lecture{
  proof[ 
    We will prove Euler's theorem by proving the necessity and sufficiency of the conditions. We first proceed to prove the conclusion on Euler circuit.

    *Necessity:* if $G$ has an Euler circuit, then every vertex has even degree. Let $C$ be an Euler circuit in $G$. For any vertex $v in V$, every time $C$ passes through $v$, it uses two edges incident to $v$. Therefore, the degree of $v$ must be even.

    *Sufficiency:* Let $G$ have all vertices of even degree. We will construct an Euler circuit in $G$. We start at any vertex $v_0$ and keep moving along edges until we return to $v_0$. Since every vertex has even degree, we can always find an unvisited edge to move along. Therefore, we can construct an Euler circuit in $G$.

    Now we proceed to prove the conclusion on Euler path.

    *Necessity:* Let $P$ be an euler path in $G$, and its endpoints are $u$ and $v$.
    - for any vertex $w in V$ that is not end point, every time $P$ passes through $w$, it uses two edges incident to $w$. Therefore, the degree of $w$ must be even.
    - for the endpoints $u$ and $v$
      - if $u = v$, then $u$ has even degree. Because we leave $u$ and return to $u$,taking two edges. In this case, all vertices have even degree, so we have zero vertices of odd degree when the euler path is a circuit.
      - if $u != v$, then $u$ and $v$ have odd degree. Because we leave $u$ and return to $v$, taking two edges. In this case, we have two vertices of odd degree when the euler path is a path.
    
    *Sufficiency:* Let $G$ have exactly two or zero vertices of odd degree. We will construct an Euler path in $G$.
    - This is a trivial case, if $G$ has zero vertices of odd degree, then we can start at any vertex and keep moving along edges until we return to the starting vertex. This forms an Euler circuit.
    - If $G$ has two vertices of odd degree, we can start at one of the vertices of odd degree and end at the other. To show this, we can extend the graph $G$ by adding an edge $(u, v)$, where $u$ and $v$ are the two vertices of odd degree. Thus, in the new graph $G'$, all vertices have even degree, and we can construct an Euler circuit in $G'$. Removing the edge $(u, v)$ from the Euler circuit in $G'$, we obtain an Euler path in $G$.

    Therefore, we have proved Euler's theorem.
  ]
}

#lemma("Maximum possible edges in a graph")[
  Let $G = (V, E)$ be a graph with $n$ vertices. 
  
  If $G$ is undirected, then the maximum number of edges in $G$ is $(|V|(|V|-1))/2 = n(n-1)/2$.

  If $G$ is directed, then the maximum number of edges in $G$ is $|V|(|V|-1) = n(n-1)$.
]
#proof[
  We use combinatorial proof techniques to prove this lemma.
  - For an undirected graph, the number of edges is the number of ways to choose two vertices from $V$. This is given by the binomial coefficient $binom(n, 2) = n(n-1)/2$.
  - For a directed graph, the number of edges is the number of ways to choose an ordered pair of vertices from $V$. This is given by the product $n(n-1)$, by the rule of product from combinatorics.
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
  cetz.canvas({
  let data = ([A], ([B], ([D]), ([E])), ([C], ([F]), ([G])))
  cetz.tree.tree(
  data,
  direction: "down"
  )
}),
  caption: "A tree with 7 vertices"
)<tree1>
#remark[
  A more well-known name for a complete acyclic graph is a *tree*. @tree1 is called a binary tree, as each vertex has at most two child nodes. It is also a complete or full binary tree, as all levels are fully filled except possibly for the last level, which is filled from left to right.
]

#problem[
  Can you give a recursive definition of a tree? Thus, give a formal definition of a binary tree.
]
#if is_lecture{
  solution[
    A tree can be defined recursively as follows:
    - Base case: A single vertex/node is a tree.
    - Recursive step: If $T_1, T_2, ..., T_k$ are trees, then a tree can be formed by connecting a new vertex to the roots of $T_1, T_2, ..., T_k$.

    A binary tree is only a case for $k = 2$. Hence, a binary tree can be defined recursively as follows:
    - Base case: A single vertex/node is a binary tree.
    - Recursive step: If $T_1$ and $T_2$ are binary trees, then a binary tree can be formed by connecting a new vertex to the roots of $T_1$ and $T_2$.
  ]
}

==== Binary Tree
Binary tree is one of the most common tree structures in computer science.

We have already discussed the recursive definition of a binary tree. Here is another definition of a binary tree:
#definition("Binary Tree")[
  A binary tree is a tree in which each node has at most two children, which are referred to as the left child and the right child. 
  
  The top vertex of the tree is called the *root* of the tree. The vertices that have no children are called *leaves* (node).

  - A binary tree is called a *full binary tree* if each node has either zero or two children.
  - A binary tree is called a *complete binary tree* if all levels are fully filled except possibly for the last level, which is filled from left to right.
  - A binary tree is called a *perfect binary tree* if all internal nodes have two children and all leaves are at the same level.
]

#example[
  The tree @tree1 is a binary tree. It is also a complete binary tree, as all levels are fully filled except possibly for the last level, which is filled from left to right. Node A 
]

#problem[
  Prove that a tree with $n$ vertices has $n-1$ edges.
]
#if is_lecture{
  proof[
    We will prove this proposition by structural induction on the definition of a tree.
    - Base case: A tree with only one vertex has no edges, so the proposition holds for the base case.
    - Inductive step: Assume the proposition holds for any tree $T$ with $n-1$ vertices, we need to prove the proposition holds for a tree $T'$ obtained by adding a new vertex to $T$.
    By the recursive definition of a tree, the new vertex can be added as a child of an existing vertex.
    - if we append the new vertex to a leaf node, then the number of edges in the tree increases by 1. So the number of edges in the tree is $n-1+1 = n$.
    - if we append the new vertex to an internal node, then the number of edges in the tree also increases by 1. So the number of edges in the tree is $n-1+1 = n$.
    In both cases, we add a new vertex to the tree, so the number of vertices in the tree is $n+1$, and we have $n+1-1 = n$, so the proposition holds for the inductive step.
    Therefore, by structural induction, the proposition holds for all trees.
  ]
}

#problem[
  The level of a node in a tree is the number of edges on the path from the root to the leaf node. The root is at level 0.

  For a binary tree of $n$ nodes, the maximum height of the tree is $n-1$. Prove this proposition.
]

#if is_lecture{
  let height = "height"
  proof[
    We will prove the proposition by structural induction on the definition of a binary tree.
    - Base case: The tree has only one node. The root is at level 0, and the height of the tree is 0. Therefore, the proposition holds for the base case.

    - Inductive step: Assume the proposition holds for any binary tree $T$ of level $n-1$, we need to prove the proposition holds for a binary tree $T'$ obtained by adding a new node to $T$.

    By the recursive definition of a binary tree, the new node can be added as either left or right child of an existing node, yet left and right does not matter here.
    We only need to consider:
    - If the new node is added as a child of a leaf node, then the height of the tree increases by 1. So the height of the tree is $n-1+1 = n$.
    - If the new node is added as a child of an internal node, then the height of the tree remains the same. So the height of the tree is $n-1$.
    In both case, we add a new node to the tree, so the number of nodes in the tree is $n+1$, and we have $n+1>n>n-1$, so the proposition holds for the inductive step.

    Therefore, by structural induction, the proposition holds for all binary trees.
  ]
}

#problem[
  Prove that at the $i$-th level of a binary tree, the maximum number of nodes is $2^i$ (counting from 0).
]
#if is_lecture{
  proof[
    We can prove this by structural induction on the definition of a binary tree.
    - Base case: The root is at level 0, and the maximum number of nodes at level 0 is $2^0 = 1$. Therefore, the proposition holds for the base case.

    - Inductive step: Assume the proposition holds for any full binary tree $T$ of level $i$, we need to prove the proposition holds for a binary tree $T'$ of level $i+1$ obtained by adding new nodes to all current leaf nodes of $T$.

    Since the maximum number of nodes at level $i$ is $2^i$, the number of leaf nodes at level $i$ is $2^i$. Adding two children to each leaf node, the number of nodes at level $i+1$ is $2 times 2^i = 2^(i+1)$. Therefore, the proposition holds for the inductive step.
  ] 
}

#problem[
  If a binary tree of height $h$ has $l$ leaves, then $h >= ceil(log_2 l)$, if the binary tree is full and balanced, then $h = ceil(log_2 l)$. 

  Prove this proposition.
]
#if is_lecture{
  proof[
    Use our previous result that $l <= 2^h$ for a binary tree of height $h$ and $l$ leaves. Because $h$ is an integer, we have $h >= ceil(log_2 l)$. 

    If the tree is full and balanced, then $l = 2^h$, and we have have more than $2^(h-1)$ leaves in total, as we have at least 1 leaf at $h$-th level. Because $l <= 2^h$, we have $2^(h-1) < l <= 2^h$. Taking the logarithm base $2$:
    $
      h-1 < log_2 l <= h.
    $
    Hence, $h = ceil(log_2 l)$.
    ]
}
  
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

#let completG = radialgraph(
  directed: false,
  nodes: ("A", "B", "C", "D"),
  edges: (("A", "B"), ("A", "C"), ("A", "D"), ("B", "C"), ("B", "D"), ("C", "D")),
  radius: 2cm
)

#figure(
  completG,
  caption: "A complete graph with 4 vertices"
)

#remark[
  A complete graph with $n$ vertices is denoted by $K_n$.
]
=== Bipartite Graph
#definition("Bipartite Graph")[
  A bipartite graph is a graph whose vertices can be divided into two disjoint sets $V_1$ and $V_2$ such that every edge connects a vertex in $V_1$ to a vertex in $V_2$.
]

#let bipartiteG = radialgraph(
  directed: false,
  nodes: ("A", "B", "C", "D", "E", "F"),
  edges: (("A", "D"), ("A", "E"), ("B", "D"), ("B", "F"), ("C", "E"), ("C", "F"), ("C", "D"), ("A", "F"), ("B", "E")),
  radius: 2cm,
  radial-start: 30deg

)

#figure(
  bipartiteG,
  caption: "A bipartite graph with 3 vertices in each set"
)

#notation[
  A complete bipartite graph, by convention, is denoted by $K_{m, n}$, where $m$ and $n$ are the number of vertices in the two sets $V_1$ and $V_2$, respectively.

  For example, the graph above is denoted by $K_{3, 3}$.
]


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
  The handshaking theorem states that for any graph, the sum of the degrees of all vertices is equal to twice the number of edges. A loop at a vertex $v$ is typically counted as contributing 2 to $deg(v)$.

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
]<shakehand>
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

  Formally, for a un weighted graph, the adjacency matrix $A$ of a graph $G = (V, E)$ with $n$ vertices is an $n times n$ matrix defined as
  $
    A = (a_(i j)) = mat(
    a_(1 1), a_(1 2), ..., a_(1 n);
    a_(2 1), a_(2 2), ..., a_(2 n);
    dots.v, dots.v, dots.down, dots.v;
    a_(n 1), a_(n 2), ..., a_(n n)
    ),
  $
  where $a_(i j) = 1$ if $(v_i, v_j) in E$ and $a_(i j) = 0$ otherwise.

  For a weighted graph, the adjacency matrix $A$ of a graph $G = (V, E)$ with $n$ vertices is an $n times n$ matrix defined as
  $
    A = (a_(i j)) = mat(
    w_(1 1), w_(1 2), ..., w_(1 n);
    w_(2 1), w_(2 2), ..., w_(2 n);
    dots.v, dots.v, dots.down, dots.v;
    w_(n 1), w_(n 2), ..., w_(n n)
    ),
  $
  where $w_(i j)$ is the weight of the edge $(v_i, v_j)$ if $(v_i, v_j) in E$ and $w_(i j) = 0$ otherwise.
]

#example[
  Consider the graph $G = (V, E)$ with $ V = {A, B, C, D} $ and $ E = {(A, B), (B, C), (C, A), (C, D), (D, B)}. $ The adjacency matrix of $G$ is
  

  #let matrixG = radialgraph(
    directed: false,
    nodes: ("A", "B", "C", "D"),
    edges: (("A", "B"), ("B", "C"), ("C", "A"), ("C", "D"), ("D", "B")),
    radius: 2cm
  )
#figure(
  grid(
  columns: 2,
  column-gutter: 20mm,
  figure(
    matrixG,
    
  ),
  $
    mat(
    0, 1, 1, 0;
    1, 0, 1, 0;
    1, 1, 0, 1;
    0, 1, 1, 0
    )
  $,
  ),
  caption: "A graph and its adjacency matrix"
)
]

==== Adjacency Matrix Power
#definition("Matrix Power")[
  The power of a matrix $A$ is defined as the matrix obtained by multiplying $A$ by itself $n$ times. The power of a matrix $A$ to the $n$th power is denoted as $A^n$.
  For example, for a $n$ dimensional square matrix:
  $ A = mat(
    a_(11), a_(12), ..., a_(1n);
    a_(21), a_(22), ..., a_(2n);
    dots.v, dots.v, dots.down, dots.v;
    a_(n 1), a_(n 2), ..., a_(n n)
    ), 
  $
  The matrix $A^2$ is obtained by multiplying $A$ by itself:
  $ A^2 = A dot A = mat(
    sum_(k=1)^n a_(1k) a_(k 1), sum_(k=1)^n a_(1k) a_(k 2), ..., sum_(k=1)^n a_(1k) a_(k n);
    sum_(k=1)^n a_(2k) a_(k 1), sum_(k=1)^n a_(2k) a_(k 2), ..., sum_(k=1)^n a_(2k) a_(k n);
    dots.v, dots.v, dots.down, dots.v;
    sum_(k=1)^n a_(n k) a_(k 1), sum_(k=1)^n a_(n k) a_(k 2), ..., sum_(k=1)^n a_(n k) a_(k n)
  )
  $
]

#example("Matrix Power")[
  A simple example of 3 by 3 matrix $A$ is
  $ A = mat(
    1, 2, 3;
    4, 5, 6;
    7, 8, 9
  )
  $
  The matrix $A^2$ is
  $ A^2 = A dot A = mat(
    30, 36, 42;
    66, 81, 96;
    102, 126, 150
  ).
  $
  Let's decompose the calculation of each entry:
  - The entry $a_11 = a_(11) a_(11) + a_(12) a_(21) + a_(13) a_(31) = 
    1 times 1 + 2 times 4 + 3 times 7 = 30$.
  - The entry $a_12 = a_(11) a_(12) + a_(12) a_(22) + a_(13) a_(32) =
    1 times 2 + 2 times 5 + 3 times 8 = 36$.
  - The entry $a_13 = a_(11) a_(13) + a_(12) a_(23) + a_(13) a_(33) =
    1 times 3 + 2 times 6 + 3 times 9 = 42$.
  - The entry $a_21 = a_(21) a_(11) + a_(22) a_(21) + a_(23) a_(31) =
    4 times 1 + 5 times 4 + 6 times 7 = 66$.
  - The entry $a_22 = a_(21) a_(12) + a_(22) a_(22) + a_(23) a_(32) =
    4 times 2 + 5 times 5 + 6 times 8 = 81$.
  - The entry $a_23 = a_(21) a_(13) + a_(22) a_(23) + a_(23) a_(33) =
    4 times 3 + 5 times 6 + 6 times 9 = 96$.
  - The entry $a_31 = a_(31) a_(11) + a_(32) a_(21) + a_(33) a_(31) =
    7 times 1 + 8 times 4 + 9 times 7 = 102$.
  - The entry $a_32 = a_(31) a_(12) + a_(32) a_(22) + a_(33) a_(32) =
    7 times 2 + 8 times 5 + 9 times 8 = 126$.
  - The entry $a_33 = a_(31) a_(13) + a_(32) a_(23) + a_(33) a_(33) =
    7 times 3 + 8 times 6 + 9 times 9 = 150$.
]

#problem[
  Consider the previous matrix, what is the trend of the matrix power $A^n$ as $n$ increases? That is to say, how do we evaluate
  $
    lim_(n -> infinity) A^n.
  $
  Also think about:
  - what is the adjacency matrix of graph in @networkTraffic? 
  - What is the adjacency matrix of the graph in @graphWithCycle? Work on it and try to find is there any interesting property of the matrix and its power. 
]
#if is_lecture{
  solution[
    It is trivial that the matrix power of $A$ will increase as $n$ increases, and all entries will reach infinity as $n$ approaches infinity. 
    That is:
    $
      lim_(n -> infinity) A^n =
      mat(
        infinity, infinity, infinity;
        infinity, infinity, infinity;
        infinity, infinity, infinity
      ).
    $
    The adjacency matrix $M$ of the graph $G$ in @networkTraffic, a weighted directed graph, is
    $
      M = 
      mat(
      0.2, 0.4, 0.4;
      0.1, 0.5, 0.4;
      0.3, 0.3, 0.4
      ),
    $
    when we map the vertex set $V = {G, I, M}$ to ${1, 2, 3}$.
    The matrix power $M^n$ will see some entries converge to a certain value as $n$ increases. We have
    $
      lim_(n -> infinity) M^n =
      mat(
      0.2, 0.4, 0.4;
      0.2, 0.4, 0.4;
      0.2, 0.4, 0.4
      )
    $
    Does these matrix powers elaborate any interesting property of the graph? Before that, we first examine the undirected graph in @graphWithCycle. The adjacency matrix of the graph $G$ is
    $
      M = 
      mat(
        0, 1, 1, 1, 0;
        1, 0, 1, 0, 1;
        1, 1, 0, 1, 0;
        1, 0, 1, 0, 1;
        0, 1, 0, 1, 0
      ).
    $
    The matrix power of $M$ will give us some interesting results. We have
    $
      M^2 = 
      mat(
        3, 1, 2, 1, 2;
        1, 3, 1, 3, 0;
        2, 1, 3, 1, 2;
        1, 3, 1, 3, 0;
        2, 0, 2, 0, 2
      ),
      M^3 =
      mat(
        4, 7, 5, 7, 2;
        7, 2, 7, 2, 6;
        5, 7, 4, 7, 2;
        7, 2, 7, 2, 6;
        2, 6, 2, 6, 0
      ),
      M^4 =
      mat(
        19, 11, 18, 11, 14;
        11, 20, 11, 20, 4;
        18, 11, 19, 11, 14;
        11, 20, 11, 20, 4;
        14, 4, 14, 4, 12
      ).
    $
  ]
}
#proposition("Significance of Matrix Power")[
      For a simple undirected graph $G$, the matrix power $M^n$ will have some interesting properties:
      - the $(i, j)$ entry of $M^n$ is the number of paths of length $n$ from vertex $i$ to vertex $j$.
      - the $(i, i)$ entry of $M^n$ is the number of circuits of length $n$ starting and ending at vertex $i$.
    ]
#proof[
  We will prove the proposition by induction on $n$.

  *Base case*: For $n = 1$, the matrix $M^1$ is the adjacency matrix of the graph $G$, and the $(i, j)$ entry of $M^1$ is 1 if there is an edge between vertex $i$ and vertex $j$ and 0 otherwise. Therefore, the base case holds.

  *Inductive step*: Assume the proposition holds for some $n = k$. We need to prove that the proposition holds for $n = k + 1$. 
  
  Let $M^k$ be the matrix obtained by raising the adjacency matrix $M$ to the $k$th power. The $(i, j)$ entry of $M^k$ is the number of paths of length $k$ from vertex $i$ to vertex $j$. The $(i, i)$ entry of $M^k$ is the number of circuits of length $k$ starting and ending at vertex $i$.
  
  The $(i, j)$ entry of $M^(k+1)$ is the sum of the products of the $(i, k)$ entry of $M^k$ and the $(k, j)$ entry of $M$. Therefore, the $(i, j)$ entry of $M^(k+1)$ is the number of paths of length $k+1$ from vertex $i$ to vertex $j$. The $(i, i)$ entry of $M^(k+1)$ is the sum of the products of the $(i, k)$ entry of $M^k$ and the $(k, i)$ entry of $M$. Therefore, the $(i, i)$ entry of $M^(k+1)$ is the number of circuits of length $k+1$ starting and ending at vertex $i$. Therefore, the proposition holds for $n = k + 1$.

  By the principle of mathematical induction, the proposition holds for all $n in NN$.
]
==== Implementation
#codly(languages: codly-languages)
```python
from typing import TypeVar, Generic, List, Optional, Tuple, Dict, Set, Any

V = TypeVar('V')  # Type for vertex identifiers
E = TypeVar('E')  # Type for edge weights (can be float, int, etc.)

class MatrixGraph(Generic[V, E]):
    """
    A graph implementation using an adjacency matrix.

    Handles directed/undirected and weighted/unweighted graphs.
    For unweighted graphs, the edge value '1' is used in the matrix.
    For weighted graphs, the edge weight is stored.
    'None' indicates the absence of an edge.

    Note: Adding/removing vertices is O(V^2) due to matrix resizing.
          Edge lookups/updates are O(1) after vertex index lookup.
          Space complexity is O(V^2).
          This representation is generally better for dense graphs.
    """

    def __init__(self, directed: bool = False, weighted: bool = False):
        """
        Initializes an empty graph.

        Args:
            directed: True if the graph is directed, False otherwise.
            weighted: True if the graph edges have weights, False otherwise.

        Complexity: O(1)
        """
        self._is_directed: bool = directed
        self._is_weighted: bool = weighted
        self._adj_matrix: List[List[Optional[E]]] = []
        self._vertex_to_index: Dict[V, int] = {}
        self._index_to_vertex: List[V] = []
        self._num_vertices: int = 0
        self._num_edges: int = 0

    def num_vertices(self) -> int:
        """
        Returns the number of vertices in the graph.
        Complexity: O(1)
        """
        return self._num_vertices

    def num_edges(self) -> int:
        """
        Returns the number of edges in the graph.
        Complexity: O(1)
        """
        return self._num_edges

    def is_directed(self) -> bool:
        """
        Returns True if the graph is directed, False otherwise.
        Complexity: O(1)
        """
        return self._is_directed

    def is_weighted(self) -> bool:
        """
        Returns True if the graph is weighted, False otherwise.
        Complexity: O(1)
        """
        return self._is_weighted

    def get_vertices(self) -> List[V]:
        """
        Returns a list of all vertices in the graph.
        Complexity: O(V) - due to copying the list of vertices.
        """
        # Return a copy to prevent external modification of internal list
        return list(self._index_to_vertex)

    def has_vertex(self, vertex: V) -> bool:
        """
        Checks if a vertex exists in the graph.
        Complexity: O(1) average - dictionary lookup. O(V) worst case (highly unlikely with standard hash functions).
        """
        return vertex in self._vertex_to_index

    def _get_vertex_index(self, vertex: V) -> int:
        """
        Helper to get the index of a vertex, raising ValueError if not found.
        Complexity: O(1) average - dictionary lookup. O(V) worst case.
        """
        index = self._vertex_to_index.get(vertex)
        if index is None:
            raise ValueError(f"Vertex '{vertex}' not found in the graph.")
        return index

    def add_vertex(self, vertex: V) -> None:
        """
        Adds a vertex to the graph.

        If the vertex already exists, this method does nothing.
        Complexity: O(V^2) - dominated by matrix resizing (adding a row and column).
                      O(1) average if vertex already exists.

        Args:
            vertex: The vertex identifier to add.
        """
        if self.has_vertex(vertex): # O(1) avg
            return

        new_index = self._num_vertices
        self._vertex_to_index[vertex] = new_index # O(1) avg
        self._index_to_vertex.append(vertex)      # O(1) avg (amortized)

        # Resize matrix: Add a new column to existing rows - O(V)
        for row in self._adj_matrix:
            row.append(None) # O(1) for each row

        # Add a new row for the new vertex - O(V) creation + O(V) append = O(V)
        new_row = [None] * (self._num_vertices + 1)
        self._adj_matrix.append(new_row) # O(1) avg (amortized for list append)

        # Overall: O(1) + O(V) + O(V) = O(V), BUT standard analysis often assumes
        # matrix allocation/copying dominates, leading to O(V^2) practical view if
        # underlying memory needs reallocation or if we consider creating the new row/col elements.
        # Let's stick to O(V^2) as the most common analysis for matrix resizing.
        # If implemented without full reallocation (e.g., pre-allocating larger blocks),
        # it could be closer to O(V), but the standard matrix model implies V^2 for resizing.

        self._num_vertices += 1 # O(1)

    def remove_vertex(self, vertex: V) -> None:
        """
        Removes a vertex and all incident edges from the graph.

        Complexity: O(V^2) - dominated by creating the new smaller matrix and
                      recalculating edges. Index remapping is O(V).

        Args:
            vertex: The vertex identifier to remove.

        Raises:
            ValueError: If the vertex does not exist.
        """
        if not self.has_vertex(vertex): # O(1) avg
            raise ValueError(f"Vertex '{vertex}' not found for removal.")

        idx_to_remove = self._vertex_to_index[vertex] # O(1) avg

        # 1. Adjust edge count ( preliminary check, full recalc below) - O(V)
        # edges_removed = 0 ... (omitted for brevity, recalc is dominant)

        # 2. Remove vertex from mappings - O(1) avg dict del, O(V) list pop
        del self._vertex_to_index[vertex]
        self._index_to_vertex.pop(idx_to_remove)

        # 3. Remap indices - O(V)
        for v, i in self._vertex_to_index.items():
            if i > idx_to_remove:
                self._vertex_to_index[v] = i - 1

        # 4. Create a new smaller matrix - O(V^2)
        new_size = self._num_vertices - 1
        new_matrix = [[None for _ in range(new_size)] for _ in range(new_size)]
        current_new_row = 0
        for old_row_idx in range(self._num_vertices):
            if old_row_idx == idx_to_remove: continue
            current_new_col = 0
            for old_col_idx in range(self._num_vertices):
                if old_col_idx == idx_to_remove: continue
                new_matrix[current_new_row][current_new_col] = self._adj_matrix[old_row_idx][old_col_idx]
                current_new_col += 1
            current_new_row += 1

        self._adj_matrix = new_matrix # O(1) reference assignment
        self._num_vertices -= 1       # O(1)

        # 5. Recalculate edge count - O(V^2)
        self._recalculate_num_edges()


    def _recalculate_num_edges(self):
        """
        Helper to recalculate the edge count by iterating the matrix.
        Complexity: O(V^2) - iterates through the entire matrix.
        """
        count = 0
        for r in range(self._num_vertices):
            for c in range(self._num_vertices):
                if self._adj_matrix[r][c] is not None:
                    if self._is_directed:
                        count += 1
                    else:
                        if r <= c: # Count undirected edges once
                            count += 1
        self._num_edges = count


    def add_edge(self, source: V, destination: V, weight: Optional[E] = 1) -> None:
        """
        Adds an edge between source and destination vertices.

        If the graph is unweighted, the weight parameter is ignored, and 1 is stored.
        If the graph is weighted, a weight must be provided (defaults to 1 if None).
        If the edge already exists, its weight is updated (if weighted).

        Complexity: O(1) average - after vertex index lookups (which are O(1) avg).

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.
            weight: The weight of the edge (used only if graph is weighted). Defaults to 1.

        Raises:
            ValueError: If source or destination vertices do not exist.
            ValueError: If the graph is weighted and weight is None.
        """
        u_idx = self._get_vertex_index(source) # O(1) avg
        v_idx = self._get_vertex_index(destination) # O(1) avg

        edge_value: Optional[E]
        if self._is_weighted:
            if weight is None:
                 edge_value = 1 # Defaulting to 1
            else:
                 edge_value = weight
        else:
            edge_value = 1 # Use 1 for unweighted graphs

        # Check if edge is newly added - O(1)
        is_new_edge = self._adj_matrix[u_idx][v_idx] is None

        # Matrix update - O(1)
        self._adj_matrix[u_idx][v_idx] = edge_value
        if not self._is_directed:
            # Additional matrix update - O(1)
            is_new_reverse = self._adj_matrix[v_idx][u_idx] is None if u_idx != v_idx else False
            self._adj_matrix[v_idx][u_idx] = edge_value
            # Edge count update - O(1)
            if is_new_edge or is_new_reverse:
                 self._num_edges += 1
        elif is_new_edge: # Directed
            # Edge count update - O(1)
            self._num_edges += 1

    def remove_edge(self, source: V, destination: V) -> None:
        """
        Removes the edge between source and destination.

        If the graph is undirected, removes the edge in both directions.
        Does nothing if the edge doesn't exist.

        Complexity: O(1) average - after vertex index lookups (which are O(1) avg).

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Raises:
            ValueError: If source or destination vertices do not exist.
        """
        u_idx = self._get_vertex_index(source) # O(1) avg
        v_idx = self._get_vertex_index(destination) # O(1) avg

        # Check existence - O(1)
        edge_existed = self._adj_matrix[u_idx][v_idx] is not None

        if edge_existed:
            # Matrix update(s) - O(1)
            self._adj_matrix[u_idx][v_idx] = None
            if not self._is_directed:
                 if u_idx != v_idx:
                     self._adj_matrix[v_idx][u_idx] = None
                 # Edge count update - O(1)
                 self._num_edges -= 1
            else: # Directed
                # Edge count update - O(1)
                self._num_edges -= 1


    def has_edge(self, source: V, destination: V) -> bool:
        """
        Checks if an edge exists between source and destination.

        Complexity: O(1) average - after vertex index lookups (which are O(1) avg).

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Returns:
            True if the edge exists, False otherwise.

        Raises:
            ValueError: If source or destination vertices do not exist.
        """
        u_idx = self._get_vertex_index(source) # O(1) avg
        v_idx = self._get_vertex_index(destination) # O(1) avg
        # Matrix access - O(1)
        return self._adj_matrix[u_idx][v_idx] is not None

    def get_edge_data(self, source: V, destination: V) -> Optional[E]:
        """
        Gets the weight or data associated with the edge.

        Returns None if the edge does not exist.
        For unweighted graphs, returns 1 if the edge exists.

        Complexity: O(1) average - after vertex index lookups (which are O(1) avg).

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Returns:
            The edge weight/data, or None if the edge doesn't exist.

        Raises:
            ValueError: If source or destination vertices do not exist.
        """
        u_idx = self._get_vertex_index(source) # O(1) avg
        v_idx = self._get_vertex_index(destination) # O(1) avg
        # Matrix access - O(1)
        return self._adj_matrix[u_idx][v_idx]

    def get_neighbors(self, vertex: V) -> List[Tuple[V, Optional[E]]]:
        """
        Gets a list of neighbors for a given vertex, along with edge data.

        Complexity: O(V) - Must iterate through a full row of the matrix.

        Args:
            vertex: The vertex identifier.

        Returns:
            A list of tuples, where each tuple is (neighbor_vertex, edge_weight).
            Returns an empty list if the vertex has no neighbors.

        Raises:
            ValueError: If the vertex does not exist.
        """
        u_idx = self._get_vertex_index(vertex) # O(1) avg
        neighbors = []
        # Iterate through row - O(V)
        for v_idx in range(self._num_vertices):
            edge_data = self._adj_matrix[u_idx][v_idx] # O(1) access
            if edge_data is not None:
                neighbor_vertex = self._index_to_vertex[v_idx] # O(1) access
                neighbors.append((neighbor_vertex, edge_data)) # O(1) avg append
        return neighbors

    def get_edges(self) -> List[Tuple[V, V, Optional[E]]]:
        """
        Gets a list of all edges in the graph.

        For undirected graphs, each edge is listed only once (e.g., (u, v, w) but not (v, u, w)).

        Complexity: O(V^2) - Must iterate through the relevant portion of the matrix
                     (whole matrix for directed, roughly half for undirected).

        Returns:
            A list of tuples, where each tuple is (source_vertex, destination_vertex, edge_weight).
        """
        edges = []
        # Nested loops iterate O(V^2) times (or O(V^2/2) for undirected)
        for u_idx in range(self._num_vertices):
            start_j = u_idx if not self._is_directed else 0
            for v_idx in range(start_j, self._num_vertices):
                edge_data = self._adj_matrix[u_idx][v_idx] # O(1) access
                if edge_data is not None:
                    source = self._index_to_vertex[u_idx]      # O(1) access
                    destination = self._index_to_vertex[v_idx] # O(1) access
                    edges.append((source, destination, edge_data)) # O(1) avg append
        return edges

    def __len__(self) -> int:
        """
        Returns the number of vertices in the graph.
        Complexity: O(1)
        """
        return self.num_vertices()
```

=== Adjacency List
#definition("Adjacency List")[
  An adjacency list is a collection of lists used to represent a graph. Each list in the collection corresponds to a vertex of the graph, and the elements of the list are the vertices adjacent to the corresponding vertex. In an undirected graph, the adjacency list of a vertex $v$ contains all the vertices adjacent to $v$. In a directed graph, the adjacency list of a vertex $v$ contains all the vertices that have an edge pointing to $v$.
]

#example[
  Consider the graph $G = (V, E)$ with $ V = {A, B, C, D} $ and $ E = {(A, B), (B, C), (C, A), (C, D), (D, B)}. $ The adjacency list of $G$ is
  $
    A: {B, C},
    B: {A, C, D},
    C: {A, B, D},
    D: {B}.
  $
#figure(
    grid(
      columns: 2,
      column-gutter: 20mm,
      
      radialgraph(
      directed: false,
      nodes: ("A", "B", "C", "D"),
      edges: (("A", "B"), ("B", "C"), ("C", "A"), ("C", "D"), ("D", "B")),
      radius: 2cm
      ),
    table(
      columns: 2,
      [Node], [Adjacency List],
      [A], [{B, C}],
      [B], [{A, C, D}],
      [C], [{A, B, D}],
      [D], [{B}]
    )
  ),
  caption: "A graph and its adjacency list"
)
]

==== Implementation
#remark[
  Do note that, the adjacency list attached to each vertex can be implemented as a list, set, or any other data structure that supports efficient insertion and deletion of elements. The choice of data structure depends on the specific problem being solved. In our occasion, we use dictionaries to represent the adjacency list:
  
  ```Dict[Vertex, Dict[Neighbor, EdgeWeight]]```
]

#codly(languages: codly-languages)
```python
from typing import TypeVar, Generic, List, Optional, Tuple, Dict, Set, Any, Iterable, Hashable

V = TypeVar('V', bound=Hashable)  # Type for vertex identifiers (must be hashable)
E = TypeVar('E')                  # Type for edge weights (can be float, int, etc.)

class ListGraph(Generic[V, E]):
    """
    A graph implementation using adjacency lists represented by dictionaries.
    The structure is: {vertex: {neighbor: weight/data, ...}, ...}

    Handles directed/undirected and weighted/unweighted graphs.
    For unweighted graphs, the edge value '1' (or True) is often used, here we use 1.
    'None' edge data is possible if explicitly added but generally avoided.

    Note: Vertex addition/lookup is O(1) avg. Edge addition/lookup is O(1) avg.
          Getting neighbors is O(degree(V)). Vertex removal is O(V + E) in the worst case
          (must check all other vertices for incoming edges). Space complexity is O(V + E).
          This representation is generally better for sparse graphs.
    """

    def __init__(self, directed: bool = False, weighted: bool = False):
        """
        Initializes an empty graph.

        Args:
            directed: True if the graph is directed, False otherwise.
            weighted: True if the graph edges have weights, False otherwise.

        Complexity: O(1)
        """
        self._is_directed: bool = directed
        self._is_weighted: bool = weighted

        # The core adjacency list structure: Dict[Vertex, Dict[Neighbor, EdgeData]]
        self._adj_list: Dict[V, Dict[V, Optional[E]]] = {}

        self._num_vertices: int = 0
        self._num_edges: int = 0

    def num_vertices(self) -> int:
        """
        Returns the number of vertices in the graph.
        Complexity: O(1)
        """
        # Alternatively, could use len(self._adj_list), but keeping a counter is safer
        return self._num_vertices

    def num_edges(self) -> int:
        """
        Returns the number of edges in the graph.
        Complexity: O(1)
        """
        return self._num_edges

    def is_directed(self) -> bool:
        """
        Returns True if the graph is directed, False otherwise.
        Complexity: O(1)
        """
        return self._is_directed

    def is_weighted(self) -> bool:
        """
        Returns True if the graph is weighted, False otherwise.
        Complexity: O(1)
        """
        return self._is_weighted

    def get_vertices(self) -> List[V]:
        """
        Returns a list of all vertices in the graph.
        Complexity: O(V) - Collects keys from the dictionary.
        """
        return list(self._adj_list.keys())

    def has_vertex(self, vertex: V) -> bool:
        """
        Checks if a vertex exists in the graph.
        Complexity: O(1) average - dictionary key lookup.
        """
        return vertex in self._adj_list

    def add_vertex(self, vertex: V) -> None:
        """
        Adds a vertex to the graph.

        If the vertex already exists, this method does nothing.
        Complexity: O(1) average - dictionary insertion/check.

        Args:
            vertex: The vertex identifier to add. Must be hashable.
        """
        if vertex not in self._adj_list: # O(1) avg check
            self._adj_list[vertex] = {}  # Add vertex with an empty neighbor dict - O(1) avg insert
            self._num_vertices += 1 # O(1)

    def remove_vertex(self, vertex: V) -> None:
        """
        Removes a vertex and all incident edges from the graph.

        Complexity: O(V + E) worst case. O(V + degree(vertex)) average if graph is sparse.
                    Need to iterate through all vertices potentially (O(V)) to remove
                    incoming edges. Each incoming edge removal is O(1) avg.
                    Removing outgoing edges is O(degree(vertex)).

        Args:
            vertex: The vertex identifier to remove.

        Raises:
            ValueError: If the vertex does not exist.
        """
        if not self.has_vertex(vertex): # O(1) avg check
            raise ValueError(f"Vertex '{vertex}' not found for removal.")

        # 1. Count and remove outgoing edges from the vertex being removed
        # Complexity: O(degree(vertex)) to count, affects edge counter later
        outgoing_edges_data = self._adj_list[vertex]
        outgoing_edge_count = len(outgoing_edges_data) # O(1) for dict len usually, but conceptually O(degree) related work

        # 2. Remove the vertex itself and its outgoing edges list from the main dictionary
        # Complexity: O(1) average deletion
        del self._adj_list[vertex]
        self._num_vertices -= 1 # O(1)

        # 3. Remove all incoming edges pointing to the removed vertex
        # Complexity: O(V + E_in) worst case where E_in is incoming edges, O(V) average for sparse graphs
        # Need to check every *other* vertex's neighbor list
        incoming_removed_count = 0
        vertices_to_check = list(self._adj_list.keys()) # O(V) to create list
        for u in vertices_to_check: # O(V) iteration
            if vertex in self._adj_list[u]: # O(1) avg check
                del self._adj_list[u][vertex] # O(1) avg deletion
                incoming_removed_count += 1 # O(1)

        # 4. Adjust edge count carefully based on directedness
        # O(1) operations
        if self._is_directed:
            # Total edges removed = outgoing + incoming
            self._num_edges -= (outgoing_edge_count + incoming_removed_count)
        else: # Undirected
            # Each edge (u, v) was represented as u->v and v->u.
            # Removing vertex 'v' deleted its entry (v -> neighbors), accounting for outgoing_edge_count edges.
            # Iterating through others deleted incoming edges (u -> v).
            # Since each edge is counted once, the total number of edges removed is simply outgoing_edge_count.
            # (The incoming_removed_count should equal outgoing_edge_count if implemented correctly).
             self._num_edges -= outgoing_edge_count


    def add_edge(self, source: V, destination: V, weight: Optional[E] = 1) -> None:
        """
        Adds an edge between source and destination vertices.

        If the graph is unweighted, the weight parameter is ignored and 1 is stored.
        If the graph is weighted, the provided weight is stored (defaults to 1 if None).
        If the edge already exists, its weight is updated.

        Complexity: O(1) average - Dictionary lookups and insertions.

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.
            weight: The weight of the edge (used only if graph is weighted). Defaults to 1.

        Raises:
            ValueError: If source or destination vertices do not exist.
        """
        # Ensure vertices exist first - O(1) avg each
        if source not in self._adj_list:
            raise ValueError(f"Source vertex '{source}' not found.")
        if destination not in self._adj_list:
            raise ValueError(f"Destination vertex '{destination}' not found.")

        edge_value: Optional[E]
        if self._is_weighted:
            edge_value = weight if weight is not None else 1 # Default weight 1 if None - O(1)
        else:
            edge_value = 1 # Use 1 for unweighted graphs - O(1)

        # Check if edge is new before adding/updating - O(1) avg
        is_new_edge = destination not in self._adj_list[source]

        # Add/update the edge - O(1) avg
        self._adj_list[source][destination] = edge_value

        # Handle edge count and undirected case
        if self._is_directed:
            if is_new_edge:
                self._num_edges += 1 # O(1)
        else: # Undirected
            # Also add/update the reverse edge, but only if not a self-loop
            if source != destination:
                 # Check if reverse is new *before* adding/updating it - O(1) avg
                is_new_reverse = source not in self._adj_list[destination]
                 # Add/update reverse edge - O(1) avg
                self._adj_list[destination][source] = edge_value
            else:
                is_new_reverse = False # Self-loop already handled by is_new_edge

            # Increment count only once if the edge was truly new (not just an update)
            # For undirected, this means it didn't exist in *either* direction before.
            # In our implementation, is_new_edge covers the source->dest check.
            # If it's a self-loop, is_new_reverse is False.
            # If not a self-loop, is_new_reverse checks dest->source.
            # An edge is conceptually new if it wasn't present in the canonical direction (e.g., source->dest).
            if is_new_edge:
                 self._num_edges += 1 # O(1)

    def remove_edge(self, source: V, destination: V) -> None:
        """
        Removes the edge between source and destination.

        If the graph is undirected, removes the edge in both directions.
        Does nothing if the edge doesn't exist.

        Complexity: O(1) average - Dictionary lookups and deletions.

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Raises:
            ValueError: If source or destination vertices do not exist.
        """
        # Check vertex existence - O(1) avg each
        if source not in self._adj_list:
            raise ValueError(f"Source vertex '{source}' not found.")
        if destination not in self._adj_list:
            raise ValueError(f"Destination vertex '{destination}' not found.")

        # Check if edge exists before trying to delete - O(1) avg
        if destination in self._adj_list[source]:
            del self._adj_list[source][destination] # O(1) avg deletion
            edge_was_removed = True
        else:
            edge_was_removed = False

        # If edge existed and was removed, decrement count and handle undirected
        if edge_was_removed:
            self._num_edges -= 1 # O(1)

            # If undirected, remove the reverse edge as well (if not a self-loop)
            if not self._is_directed and source != destination:
                # Check existence before deleting reverse for robustness - O(1) avg
                if source in self._adj_list[destination]:
                    del self._adj_list[destination][source] # O(1) avg deletion
                # Do NOT decrement edge count again for undirected


    def has_edge(self, source: V, destination: V) -> bool:
        """
        Checks if an edge exists between source and destination.

        Complexity: O(1) average - Dictionary lookups.

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Returns:
            True if the edge exists, False otherwise. Returns False if vertices don't exist.
        """
        if source not in self._adj_list: # O(1) avg check
            return False
        # Check if destination is a key in the source's neighbor dictionary - O(1) avg
        return destination in self._adj_list[source]

    def get_edge_data(self, source: V, destination: V) -> Optional[E]:
        """
        Gets the weight or data associated with the edge.

        Returns None if the edge or vertices do not exist.
        For unweighted graphs, returns 1 if the edge exists.

        Complexity: O(1) average - Dictionary lookups.

        Args:
            source: The source vertex identifier.
            destination: The destination vertex identifier.

        Returns:
            The edge weight/data, or None if the edge/vertex doesn't exist.
        """
        if source not in self._adj_list: # O(1) avg check
            return None
        # dict.get() returns None if key (destination) not found - O(1) avg
        return self._adj_list[source].get(destination)

    def get_neighbors(self, vertex: V) -> Iterable[Tuple[V, Optional[E]]]:
        """
        Gets an iterable of neighbors for a given vertex, along with edge data.

        Complexity: O(degree(vertex)) - Iterates through the vertex's neighbor dictionary items.
                     Getting the items view itself is O(1).

        Args:
            vertex: The vertex identifier.

        Returns:
            An iterable view (dict_items) of tuples (neighbor_vertex, edge_weight).
            Use list() around the result if a list copy is needed.

        Raises:
            ValueError: If the vertex does not exist.
        """
        if vertex not in self._adj_list: # O(1) avg check
            raise ValueError(f"Vertex '{vertex}' not found.")

        # .items() provides an efficient view for iteration - O(1) to create view
        # Iteration over the view takes O(degree(vertex))
        return self._adj_list[vertex].items()

    def get_edges(self) -> List[Tuple[V, V, Optional[E]]]:
        """
        Gets a list of all edges in the graph.

        For undirected graphs, each edge is listed only once (conventionally).
        Uses a set to track visited pairs for undirected graphs to avoid duplicates.

        Complexity: O(V + E) - Iterates through all vertices (O(V)) and then through
                     all neighbors for each vertex (totaling O(E) across all vertices).
                     Set operations are O(1) average.

        Returns:
            A list of tuples, where each tuple is (source_vertex, destination_vertex, edge_weight).
        """
        edges = []
        # Used only for undirected graphs to avoid adding (u,v) and (v,u)
        visited_undirected_pairs = set() # O(1) space overhead initially

        # O(V) outer loop
        for source, neighbors in self._adj_list.items():
            # O(degree(source)) inner loop -> totals O(E) over the outer loop
            for destination, weight in neighbors.items():
                if self._is_directed:
                    edges.append((source, destination, weight)) # O(1) avg append
                else:
                    # Ensure undirected edges are added only once
                    # Create a canonical representation (frozenset for hashability regardless of order)
                    edge_pair = frozenset((source, destination)) # O(1) creation (assuming hashable V)
                    if edge_pair not in visited_undirected_pairs: # O(1) avg set lookup
                        edges.append((source, destination, weight)) # O(1) avg append
                        visited_undirected_pairs.add(edge_pair) # O(1) avg set add
        return edges # O(E) size list returned

    def __len__(self) -> int:
        """
        Returns the number of vertices in the graph.
        Allows `len(graph)` syntax.
        Complexity: O(1)
        """
        return self.num_vertices()
```
=== Trade-offs between Adjacency Matrix and Adjacency List
#definition("Sparse and Dense Graph")[
  A graph is considered sparse if the number of edges is much less than the number of vertices squared, i.e., $|E| << |V|^2$. Sparse graphs have relatively few edges compared to the number of possible edges.

  Accordingly, a graph is considered dense if the number of edges is close to the number of vertices squared, i.e., $|E| ~ |V|^2$. Dense graphs have many edges compared to the number of possible edges.
]

#if is_lecture{
  hint[
    Recall on typical sparse and dense graphs:
    - Social networks, citation networks, and the World Wide Web are examples of sparse graphs.
    - Binary tree: $|E| = |V| - 1 << |V|^2$.
    - Complete graph: $|E| = (|V|(|V| - 1)) / 2 ~ |V|^2$.
  ]
}

#figure(
  caption: [Comparison of Adjacency Matrix and Adjacency List Graph Implementations],
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    column-gutter: 0mm,
    row-gutter: 0mm,
    // Header row with different styling
    table.header(
      [*Feature / Operation*], 
      [*Adjacency Matrix (`MatrixGraph`)*], 
      [*Adjacency List (`ListGraph`)*], 
      [*Winner / Notes*]
    ),
    // Data rows
    [*Space Complexity*], [$O(V^2)$], [$O(V + E)$], [*List* (*especially for sparse graphs*)],
    [*Add Edge*], [$O(1)$ avg], [$O(1)$ avg], [*Tie* (*both fast on average*)],
    [*Remove Edge*], [$O(1)$ avg], [$O(1)$ avg], [*Tie* (*both fast on average*)],
    [*Check Edge / Get Weight*], [$O(1)$ avg], [$O(1)$ avg], [*Tie* (*both fast on average*)],
    [*Get Neighbors(u)*], [$O(V)$], [$O(deg(u))$], [*List* (*much faster for sparse graphs*)],
    [*Get All Edges*], [$O(V^2)$], [$O(V + E)$], [*List* (*much faster for sparse graphs*)],
    [*Add Vertex*], [$O(V)$ *or* $O(V^2)$ *if resizing*], [$O(1)$ avg], [*List* (*much faster & simpler*)],
    [*Remove Vertex*], [$O(V^2)$], [$O(V + E)$ *or* $O(V)$ *avg*], [*List* (*generally better*)],
  )
)<graph-comparison>




== Basic Graph Algorithms
We discuss two fundamental graph traversal algorithms: Breadth-First Search (BFS) and Depth-First Search (DFS). These algorithms are used to explore and search a graph, and they can be applied to both directed and undirected graphs.
=== Breadth-First Search
==== Definition
#definition("Breadth-First Search (BFS)")[
  Breadth-First Search (BFS) is a graph traversal algorithm that explores the graph level by level. Starting from a source vertex, BFS visits all its neighbors first, then the neighbors' neighbors, and so on. The algorithm uses a *queue* to keep track of the vertices to visit next.
]
#figure(
  kind: "algorithm",
  supplement: [Algorithm],

  pseudocode-list(booktabs: true, numbered-title: [Breadth-First Search])[
    + function BFS(graph, initial_vertex):
      + visited = set()
      + queue = [initial_vertex]
      + visited.add(initial_vertex)
      + *while* queue is *not* empty:
        + current_vertex = queue.dequeue()
        + *for* neighbor *in* graph.get_neighbors(current_vertex):
          + *if* neighbor *not in* visited:
            + visited.add(neighbor)
            + queue.enqueue(neighbor)
      + *return* visited
  ]
) <BFSPseudocode>

#figure(
  image("BFS.png", width: 50%),
  caption: "Breadth-First Search (BFS) traversal of a graph starting from vertex A."
)

==== Complexity Analysis
===== Space Complexity
For a graph with $V$ vertices and $E$ edges:
- If implemented by adjacency matrix, the space complexity of Breadth-First Search (BFS) is $O(V)$. This is because:
  - we maintain a queue of vertices to visit, which can contain all vertices in the worst case, contributing $O(V)$ auxilary space.
  - we maintain a set of visited vertices, which can contain all vertices in the worst case, contributing $O(V)$ auxilary space.
- If implemented by adjacency list, the space complexity of Breadth-First Search (BFS) is also $O(V)$. The reason is similar to the adjacency matrix case, but the space usage is more efficient for sparse graphs.
===== Time Complexity
#definition([Big-O Notation])[
  By assuming the input of an algorithm is of variable size $n$, we use big-O notation to analyse the assymptotic upper bound of the time complexity when $n -> infinity$. We state that, in the worst case, the time complexity $T(n)$ of an algorithm with input size $n$ has $T(n) = O(g(n))$, if
  $ exists (c >0 and r in NN^+ ) "such that" forall n>r, 0 <= f(n ) <= c dot g(n), $ 
  where $f(n)$ is the exact time complexity of the algorithm, and $g(n)$ is the upper bound of the time complexity.
  ]
For a graph with $V$ vertices and $E$ edges:
- If implemented by adjacency matrix, the time complexity of Breadth-First Search (BFS) is $O(V^2)$. This is because:
  - The queue operations (enqueue and dequeue) will be excecuted for each vertex, contributing $O(V)$ time.
  - The loop to visit neighbors of each vertex will be executed for each vertex. For adjacency matrix, we will run a outer loop of $|V|$ and inner loop of $|V|$ in the worst case, contributing $O(V^2)$ time.
- If implemented by adjacency list, the time complexity of Breadth-First Search (BFS) is $O(V + E)$. This is because:
  - The queue operations (enqueue and dequeue) are will be excecuted for each vertex, contributing $O(V)$ time.
  - The loop to visit neighbors of each vertex will be executed for each vertex. For adjacency list, we will run a outer loop of $|V|$ and inner loop of $deg(V)$ in the worst case, and $max(deg(V)) = E$ in the worst case, contributing $O(V + E)$ time.

=== Depth-First Search
==== Definition
#definition("Depth-First Search (DFS)")[
  Depth-First Search (DFS) is a graph traversal algorithm that explores the graph by going as deep as possible along each branch before backtracking. Starting from a source vertex, DFS visits the first neighbor, then the neighbor's neighbor, and so on until it reaches a dead-end. The algorithm uses a *stack* to keep track of the vertices to visit next.
]

#figure(
  kind: "algorithm",
  supplement: [Algorithm],

  pseudocode-list(booktabs: true, numbered-title: [Depth-First Search])[
    + function DFS(graph, initial_vertex):
      + visited = set()
      + stack = [initial_vertex]
      + *while* stack is *not* empty:
        + current_vertex = stack.pop()
        + *if* current_vertex *not in* visited:
          + visited.add(current_vertex)
          + *for* neighbor *in* graph.get_neighbors(current_vertex):
            + *if* neighbor *not in* visited:
              + stack.push(neighbor)
      + *return* visited
  ]
) <DFSPseudocode>

#figure(
  image("image.png", width: 50%),
  caption: "Depth-First Search (DFS) traversal of a graph starting from vertex A."
)
==== Complexity Analysis
===== Space Complexity
For a graph with $V$ vertices and $E$ edges:
- If implemented by adjacency matrix, the space complexity of Depth-First Search (DFS) is $O(V)$. This is because:
  - we maintain a stack of vertices to visit, which can contain all vertices in the worst case, contributing $O(V)$ auxilary space.
  - we maintain a set of visited vertices, which can contain all vertices in the worst case, contributing $O(V)$ auxilary space.
- If implemented by adjacency list, the space complexity of Depth-First Search (DFS) is also $O(V)$. The reason is similar to the adjacency matrix case, but the space usage is more efficient for sparse graphs.
===== Time Complexity
For a graph with $V$ vertices and $E$ edges:
- If implemented by adjacency matrix, the time complexity of Depth-First Search (DFS) is $O(V^2)$. This is because:
  - The stack operations (push and pop) are will be excecuted for each vertex, contributing $O(V)$ time in the worst case.
  - The loop to visit neighbors of each vertex will be executed for each vertex. For adjacency matrix, we will run a outer loop of $|V|$ and inner loop of $|V|$ in the worst case, contributing $O(V^2)$ time.
- If implemented by adjacency list, the time complexity of Depth-First Search (DFS) is
  $O(V + E)$. This is because:
  - The stack operations (push and pop) are will be excecuted for each vertex, contributing $O(V)$ time.
  - The loop to visit neighbors of each vertex will be executed for each vertex. For adjacency list, we iterate through all vertices by accessing $V$ times of $O(1)$ operetion in the hash table, and iterate through all edges by accessing $E$ times of $O(1)$ operation in the inner hash table, contributing $O(V + E)$ time.




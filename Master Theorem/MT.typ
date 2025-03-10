#import "@preview/dvdtyp:1.0.1": * // template
#import "@preview/lovelace:0.3.0": * // pseudocode
#import "@preview/cetz:0.3.3"  // plot
#import "@preview/mitex:0.2.5": * // latex to typst
#import "@preview/quick-maths:0.2.1": shorthands

#show: dvdtyp.with(
  title: "Master Theorem and Recurssion",
  subtitle: [Motivation, formal proof, and examples],
  author: "Eric Yang Xingyu",
  abstract: lorem(0),
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

#set math.equation(
  numbering: "(1)", 
  supplement: [Eq.],
  block: true
  )

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

#let example-style = builder-thmbox(color: colors.at(16), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let example = example-style("example", "Example")

#let problem-style = builder-thmbox(color: colors.at(2), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let problem = problem-style("problem", "Problem")

#let exercise-style = builder-thmbox(color: colors.at(0), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))
#let exercise = exercise-style("exercise", "Exercise")


#outline()
#pagebreak()

= Background
Recursive algorithms are algorithms that call themselves. They are often used to solve problems that can be broken down into smaller subproblems. While it is easy to write recursive algorithms, it is often difficult to analyze their time complexity. This is usually because recursive algorithms is not like iteratively implemented algorithms where you can easily count the number of iterations, and all you need to do is to multiply the time complexity of each iteration by the number of iterations. In recursive algorithms, the number of recursive calls is implied by the input size, and the time complexity of each call is not always the same, usually dependent on the complexity of the subproblems.

#definition("Recursive Algorithm")[
  A recursive algorithm is an algorithm that calls itself to solve a problem by breaking it down into smaller subproblems. The time complexity of recursive algorithms can be expressed using recurrence relations, as the time complexity of the algorithm is often dependent on the time complexity of solving the subproblem(s).
]
== Example of Recursive Algorithms
We first examine several examples of recursive algorithms in order to understand the nuances to iterative approaches.
=== Binary Search <problems>
We first look at the recursive implementation of the binary search algorithm.
#example("Binary Search")[
  The binary search algorithm is a classic example of a recursive algorithm. 
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true, numbered-title: [Binary Search])[
      + *function* Binarysearch($A$, $x$, low, high)
        + *if* low > high
          +   *return* -1
        + *else*
          +   mid = (low + high) / 2
        +   *if* $A$[mid] = $x$
         +     *return* mid
        +   *else if* $A$[mid] > $x$
          +     *return* Binarysearch($A$, $x$, low, mid - 1)
        +   *else*
          +     *return* Binarysearch($A$, $x$, mid + 1, high)
    ]
  )

  It works by dividing the input array in half and recursively searching the left or right half of the array depending on the value of the middle element. The time complexity of binary search is $O(log n)$, where $n$ is the size of the input array.
]

#problem[
  How does the iterative and recursive implementation of Binary Search differ when it comes to analyzing the time complexity?
]
This is a trivial problem, but it is important to understand the difference between recursive and iterative algorithms. In iterative algorithms, the number of iterations is strictly defined and visible, while in recursive algorithms, the number of recursive calls is not always visible, and the only thing we know, given that the algorithm is correct, is that the recursive algorithm terminates when it reaches the base case. 
#figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true, numbered-title: [Binary Search (iterative)])[
      + *function* Binarysearch_iter($A$, $x$, low, high)
        + *while* low <= high
          +   mid = (low + high) / 2
          +   *if* $A$[mid] = $x$
          +     *return* mid
          +   *else if* $A$[mid] > $x$
            +     high = mid - 1
          +   *else*
            +     low = mid + 1
        + *return* -1
    ]
  )

From the pseudocode itself, we know that the number of iterations is $log_2n$, because the algorithm divides the input array in half each iteration. Some may say, this is also trivial in the recursive case, while the reason is that this algorithm is dependent on a simple recurrence relation, $T(n) = T(n/2) + O(1)$, where $T(n)$ is the time complexity of the algorithm, and $O(1)$ is the time complexity of the operations in the algorithm, we may also use some random letter to denote these constant time operations, so we may also write $T(n) = T(n/2) + c$, where $c$ is a constant.

#remark()[
  While how to express the constant component in the time complexity actually does not really matter, because time complexity is usually analysed asymptotically, and the constant component is usually ignored, and non-rigorously, we may just write $T(n) = T(n/2) + 1$.
]

And here we have some tricky problems:
#problem[ 
  - How can we derive a closed-form solution for the recurrence relation like $T(n) = T(n/2) + c$? 
  - How can we transfer the time complexity $T(n)$ to big $O$ notation?
]


These will be answered in the following sections of the article.



=== Karatsuba Quick Multiplication
We introduce the other example to be discussed in this article, the Karatsuba multiplication algorithm. This algorithm is a fast multiplication algorithm that multiplies two numbers in $O(n^(log_2 3))$ time complexity, which is faster than the naive multiplication algorithm that has a time complexity of $O(n^2)$.

#example("Karatsuba Multiplication")[
  The Karatsuba multiplication algorithm is a recursive algorithm that multiplies two numbers in $O(n^(log_2 3))$ time complexity. The algorithm works by dividing the input numbers into two halves and recursively multiplying the subparts of the numbers. The time complexity of the Karatsuba multiplication algorithm is derived from the recurrence relation $T(n) = 3T(n/2) + c n$.

  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true, numbered-title: [Karatsuba Multiplication])[
      + *function* Karatsuba(x, y)
        + *if* $x$ < 10 *or* $y$ < 10
          +   *return* $x dot y$
        + $n$ = max(length($x$), length($y$))
        + $m$ = $ceil(n / 2)$
        + $x_h$, $x_l$ = split($x$, $m$)
        + $y_h$, $y_l$ = split($y$, $m$)
        + $a$ = Karatsuba($x_h$, $y_h$)
        + $b$ = Karatsuba($x_l$, $y_l$)
        + $c$ = Karatsuba($x_h$ + $x_l$, $y_h + y_l$)$ - a - b$
        + *return* $a times 10^(2m) + c times 10^m + b$
    ]
  )
]
In this article, we do not discuss the details of the algorithm, but only derive the recurrence relation from the recursive implementation. If you want to know more about the algorithm, you can refer to #link("https://en.wikipedia.org/wiki/Karatsuba_algorithm")[wikipedia], or the jupyter notebook under "quick multiplication" in this repository.
#theorem("Karatsuba Multiplication Recurrence Relation")[
  The time complexity of the Karatsuba multiplication algorithm is $T(n) = 3T(n/2) + c n$, where $T(n)$ is the time complexity of the algorithm, and $c$ is a constant, and $n$ is the number of digits of the input numbers.
]
#proof[
  The Karatsuba multiplication algorithm computes the product of two $n$-digit numbers, $x$ and $y$, by splitting each into two parts of approximately $n/2$ digits:
  Let $x = 10^(n/2) dot a + b $ and $y = 10^(n/2) dot c + d$, where $ a, b, c, d$ are numbers with $n/2 $ digits (assuming $n $ is even for simplicity).

  Instead of performing four multiplications (as in the naive $O(n^2)$ method), Karatsuba reduces this to three multiplications of numbers of size $n/2$:
  
  + Compute $p_1 = a dot c $.
  + Compute $p_2 = b dot d $.
  + Compute $p_3 = (a + b) dot (c + d) $.
  The product of $x$ and $y$ is then given by $10^n dot p_1 + 10^(n/2) dot (p_3 - p_1 - p_2) + p_2 $.

  Now we can derive the recurrence relation of exact time complexity of the algorithm.

  In each of $p_1$, $p_2$, and $p_3$, we multiply two numbers of size $n/2$, so the time complexity of each of these operations is $T(n/2)$. Combining together, we have $3T(n/2)$.

  While we also need to consider the cost of non-recursive steps, which is $O(n)$, because we need to split the input numbers into two parts, and combine the results of the subproblems, which are introduced in line 4, 5, 6, and 7 of the pseudocode. But be careful that, we need to add $c n$ instead of just $n$, because the cost of these operations is not always the same, and there are multiple operations that are of $O(n)$ in the non-recursive part of the algorithm.

  Hence, we have rigorously justified the recurrence relation of Karatsuba's time complexity is 
  $ T(n) = 3T(n/2) + c n. $

]



== Some Prereqiosites
Below are some important facts & definitions to be used for our proof and discussion.

=== Complexity Notation
Before we dive into complexity analysis of recursive algorithms, let's recap the complexity notations we will use in this article. Note that we will only use Big O (particularly) and Big Omega notations, as they are the most commonly used notations in complexity analysis.
#definition("Big O Notation")[
  Big O notation is used to describe the upper bound of the growth rate of a complexity function. Formally, $f(n) = O(g(n))$ if there exist positive constants $c$ and $n_0$ such that $ forall n >= n_0, 0 <= f(n) <= c dot g(n). $
]

#definition("Big Omega Notation")[
  Big Omega notation is used to describe the lower bound of the growth rate of a complexity function. Formally, $f(n) = Omega(g(n))$ if there exist positive constants $c$ and $n_0$ such that $ forall n >= n_0, 0 <= c dot g(n) <= f(n). $
]

Average case complexity is not discussed in this article, as it is not commonly used in complexity analysis of recursive algorithms. But generally, we say that 
$ T(f(n)) = Theta(g(n)) <--> [T(f(n)) = O(g(n))] and [T(f(n)) = Omega(g(n))]. $

Average compexity can be defined in different ways when the context varies, while in this occasion, this is not our main focus.

=== Other Lemmas
We will also use some other lemmas to prove the time complexity of the Karatsuba algorithm. These lemmas are quite simple, and they are usually used in the analysis of recursive algorithms.

#lemma("Geometric Series Sum")[
  The sum of a geometric series is given by:
  $
  sum_(i=0)^k a^i = (a^(k+1) - 1)/(a - 1).
  $
]<geosum>
This is a trivial fact, and could be easily obtained by induction. You may refer to other sources if you are confused.

The other lemma is about logarithm, and is a quite useful formula in the analysis of divide-and-conquer algorithms.

#lemma[
  For any positive real numbers $a, b, n$, we have:
  $
    n^(log_a b) = b^(log_a n).
  $
]<changebase>
#proof[
  By logarithm property, we have $n = a^(log_a n)$ and $b = a^(log_a b)$.
  
  Substitute $n = a^(log_a n)$ to the LHS, we have:
  $
  "LHS" = n^(log_a b) = (a^(log_a n))^(log_a b) = a^(log_a n dot log_a b).
  $
  Substitute $b = a^(log_a b)$ to the RHS, we have:
  $
  "RHS" = b^(log_a n) = (a^(log_a b))^(log_a n) = a^(log_a b dot log_a n).
  $
  Thus $"LHS" = "RHS"$, which completes the proof.
]

= Common Methods for Analysing Recursive Algorithms
Now we will try to solve the last problems we mentioned in @problems.

We just recap the definitions of the recurrence relation and the time complexity of the algorithm, and we must first point out one crucial standing point in the analysis of recursive algorithms:

#proposition[
  To analyze the time complexity of a recursive algorithm, we *must* derive a non-recursive expression for the recurrence relation that describes the time complexity of the algorithm, which is bounded only by some variables $n$, where $n$ is the size of the input.
]

This is because the time complexity of the algorithm is usually dependent on the time complexity of solving the subproblems, and the number of subproblems is usually dependent on the size of the input. So we must derive a non-recursive solution for the recurrence relation, which is a direct function of $n$. If we do not do this, the recursive definition cannot be used to argue for time complexity notations, because it is not a function of $n$, but a transition equation that is dependent on the complexity of subproblems, despite the fact that the $T(n)$ is indeed indirectly dependent on $n$. However, *this is not a solid arguement to prove the time complexity of the algorithm, as per the definitions*!

== First-order Linear Recurrence Relations with Constant Coefficients
To facilitate the analysis of recursive algorithms, we first introduce the formal definition of a *linear recurrence relation with constant coefficients*.

Solving recurrence relation is a vast topic in mathematical context, and there are many methods to solve recurrence relations, such as substitution method, master theorem, generating function, characteristic equation, strong/weak induction, and so on. Yet in the context of fundamental algorithm analysis, we are only engaged with *first order linear recurrence relations with constant coefficients*. The name could be a bit intimidating, but the idea is simple.

#definition("First Order Linear Recurrence Relation with Constant Coefficients")[
    A *linear recurrence relation with constant coefficients* is a recurrence relation of the form:
    $ a_n = c_1 a_(n - k_1) + c_2 a_(n - k_2) + ... + c_m a_(n - k_m) + f(n) $
    where:
    - $n$ is a non-negative integer (or, in some contexts, an integer).
    - $m$ is a positive integer representing the *order* of the recurrence.
    - $c_1, c_2, ..., c_m$ are constant coefficients, with $c_m != 0$.
    - $k_1, k_2, ..., k_m$ are distinct positive integer constants.  Without loss of generality, we can assume $0 < k_1 < k_2 < ... < k_m$.
    - $f(n)$ is a function of $n$.
    To uniquely define the sequence $a_n$, we also need $m$ initial conditions:
    $
    a_(n_0) = b_0 \
    a_(n_0 + 1) = b_1 \
    ... \
    a_(n_0 + m - 1) = b_(m-1)
    $
      where $n_0$ is the smallest value of $n$ for the recurrence,
    where $b_0, b_1, ..., b_(m-1)$ are constants.
    - *Homogeneous Recurrence:* If $f(n)$ is the identically zero function (i.e., $f(n) = 0$ for all $n$), the recurrence is called *homogeneous*.
    - *Non-homogeneous Recurrence:* If $f(n)$ is not the identically zero function, the recurrence is called *non-homogeneous*.
    - *First-Order Linear Recurrence:* A *first-order* linear recurrence is a special case where $m=1$ and $k_1 = 1$.  It has the form:
        $a_n = c a_(n-1) + f(n)$
        with *one* initial condition $a_(n_0) = b_0$
]

It's important to note that the choice of using $a_n$ to represent the sequence, as opposed to $T(n)$ or any other notation (e.g., $x_n$, $y_n$), is purely *a matter of convention and symbolic representation*.  The underlying mathematical structure and properties of the recurrence relation remain the same regardless of the specific symbol used to denote the sequence. The choice of notation often depends on context or personal preference. To avoid confusion over the first order linear recurrence relation, we specifically state that the recursive relation of 
    $ a_n = c a_(n - 1) + f(n) $
    is equivalent to the recursive relation of
    $ T(n) = c T(n/k) + f(n), $
    where $k in NN^+$. It is also *important* that, in the sequence expression $a_n$, $n$ is only an index to the sequence, and it is not necessarily the size of the input of the algorithm. In $T(n)$, however, $n$ is the size of the input of the algorithm, that's why we have something like $T(n/k)$, but not $T(n-1)$, which is not meaningful in the context of algorithm analysis.


In the scope of FIT2004, we are only interested in the first-order linear recurrence relation with constant coefficients, which is a simple form of recurrence relation that can be solved using some normal methods, without introducing too many extra mathematical concepts.

#remark[
  Recurrence Relation is an *INMENSE* topic in mathematics, and it is related to many other topics, such as generating functions, characteristic equations, differential equations, system of equations, eigenvalue & eigenvector, graph theory, dynamic system, vector space, polynomial rings, or even advanced topics in abstract algebra, such as group theory, ring theory, field theory! It is highly recommended to take it as a important topic in mathematics, and I really like Chapter 8 of the book #link("https://www.mheducation.com/highered/product/Discrete-Mathematics-and-Its-Applications-Rosen.html")["Discrte Mathematics and its Applications"] by Kenneth H. Rosen, which is a good introduction to the topic. It will be an excellent start to figure out the connection between linear recurrence relations and ordinary differential equations.
]

With the notion of recurrence relation explained, we can now move on to the methods of solving recurrence relations, which are crucial in the analysis of recursive algorithms. But do note that, the method we discuss here is only applicable to the first-order linear recurrence relation with constant coefficients, and it is not applicable to higher-order linear recurrence relations, non-linear recurrence relations, which are more complex and require more advanced mathematical tools to solve, such as generative function.

== Recurssion Tree Method <recursionTree>
One of the most intuitive methods to analyze the time complexity of basic recursive algorithms is by investigating the *recursion tree*. The recursion tree is a visual representation of the recursive calls made by the algorithm, which helps us understand the number of recursive calls and the time complexity of each call. In this method, we will try to find the time complexity of each call with respect to the input size, and then sum up the time complexity of all calls by traversing all levels of the recursion tree.

In the context of Karatsuba's algorithm, we can represent the recursive calls as a tree, where each level of the tree corresponds to a recursive call, and the branching factor is the number of subproblems created at each level. In this case, we have a single root $T(n)$ and three children $T(n/2)$ at each level, so on and so forth. So this is actually a ternary tree.
#scale(75%)[
#figure(caption: "Recursion Tree of Karatsuba Algorithm up to 4 Levels",
  cetz.canvas({
  import cetz.draw: *
  import cetz.tree: *
  let data = ([$T(n)$],
  ([$T(n/2)$], ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$])),
  ([$T(n/2)$], ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$])),
  ([$T(n/2)$], ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]), ([$T(n/4)$], [$T(n/8)$], [$T(n/8)$], [$T(n/8)$]))
  )
  tree(
    data,
    direction: "down",
    draw-node: (node, ..) => {
      circle((), radius: .45, fill: blue, stroke: none)
      content((), text(yellow, [#node.content]))
    },
    draw-edge: (from, to, ..) => {
      let (a, b) = (from + ".center", to + ".center")
      line((a, .4, b), (b, .4, a))
    }
  )
},))
]

Above is the recursion tree of the Karatsuba multiplication algorithm up to 3 levels. Theoretically, we can continue to draw the recursion tree to the leaf nodes, where base cases are reached. Before we proceed to prove the worst-case time complexity of the Karatsuba algorithm, first recap on several facts on trees, that for a binary tree, we have $2^k$ nodes at level $k$, and the number of levels is $(log_2n) + 1$, where $n$ is the number of nodes. We can extend this to a ternary tree, where we have $3^k$ nodes at level $k$, and the number of levels is $log_2n$. 

#problem[
  Prove that the worst-case time complexity of the Karatsuba algorithm is $O(n^(log_2 3))$.
]
#remark[
  For clarity and conciseness, we *assume that* $n$ *is always even* and of the form $2^k$, where $k$ is a positive integer, else, we need to apply ceiling function to some variables, for example $ceil(log_2 n)$ and $ceil(n/2^k)$. From a pragmatic perspective, and computer science practice, this is 100% acceptable. However, I have to mention that, from a mathematical perspective, this is not rigorous enough, and we need to consider the general case, where $n$ is not necessarily a power of 2, and we need to consider the ceiling function!
]
#proof[
  As per what have been mentioned, for input size $n$, we have $3^k$ nodes at level $k$, and the number of levels is $log_2 n$. Additionally, we know that the subproblem at level $k$ is of size $n/2^k$, so the time complexity of one subproblem at level $k$ is $T(n/2^k)$. Hence, we have obtained all the information we need to figure out the total time complexity of the algorithm in a summation form instead of recursive form.

  $ T(n) = 3T(n/2) + c n $
  and each subproblems have its recursive cost and non-recursive cost as well.

  At level $k$, we have $3^k$ problems of size $n/2^k$ with total non-recursive cost $3^k dot c(n/2^k)$, where $c$ is some constant.

  For the recursive cost, it's a quite different case, because we know that the base case is $T(1) = 1$, and each problem invokes three subproblems of size $n/2$, so we have $3T(n/2)$. In the end, we will have a total recursive cost of $3^k T(1)$.
   
  
  This is quite anti-intuitive, but it is true, because the base case is a constant time operation, and $3^k$ is the number of subproblems at level $k$, which is a constant number! Because in this case $n$, the input size, is approaching infinity, so however large $3^k$ is, we always have $k < log_2 n < n$, so $3^k$ is regarded as a constant number. 
  
  *Thus, we conclude that we only need to consider the sum of non-recursive costs in all levels to get $T(n)$*

  So we can sum up all costs by traversing all levels of the recursion tree, and we have:
  $ T(n) = sum_(k=0)^(log_2 n) 3^k (c n/2^k)
   = c n sum_(k=0)^(log_2 n) (3/2)^k
  $

  #remark[
    We are counting from 0 to $log_2 n$, because the root node is at level 0, and the leaf nodes are at level $log_2 n$, so the total number of levels is $log_2 n + 1$.
  ]

  This is a geometric series, and we know that the sum of a geometric series is $sum_(i=0)^k a^i &= (a^(k+1) - 1)/(a - 1)$, so we have:
  $ T(n) &= c n (3^(log_2 n + 1) - 1)/(3/2 - 1) 
   = c n (3^(log_2 n + 1) - 1)/(1/2) \
   &= 2c n (3^(log_2 n + 1) - 1) 
   = 2c n (3^(log_2 n) dot 3 - 1) \
   &= 2c n (n^(log_2 3) dot 3 - 1) because n^(log_a b) = b^(log_a n) ("by base change formula")\
   &= 6c n^(log_2 3) - 2c n 
  $

  Now we use the formal definition of Big O notation, to show that $T(n) = O(n^(log_2 3))$:
  $ T(n) <= 6c n^(log_2 3) - 2c n <= 6c n^(log_2 3), $
  as $n in NN^+$, and $exists c_0 in RR^+$, $exists n_0 in NN^+$, $forall n >= n_0, 0 <= 6c n^(log_2 3) - 2c n <= 6c n^(log_2 3)$, where $c_0 = 6c$, $n_0 = 1$, so we have proven that $T(n) = O(n^(log_2 3))$.
]

As you see, the recursion tree method is quite intuitive, and we do not completely apply the properties of the recursive relation except for its recursive definition. Yet it is not always the case that we can solve the time complexity of the algorithm by recursion tree method, because the recursion tree method is only applicable to some simple recursive algorithms, where the number of subproblems is a constant number, and the size of the subproblems is a constant fraction of the input size. This method is usually more time-consuming than substitution method, which is more mechanical and less intuitive.

After reading through the proof, you can try out some more basic exercise to grasp the concept of recursion tree method. Below are some recommended exercises.

=== Exercises

#exercise[
  Use the recursion tree method to analyze the time complexity of Binary Search algorithm.
]

#exercise[
  Derive the recurrence relation of the following recursive algorithm, and thus
  use the recursion tree method to analyze the time complexity of the following recursive algorithm:
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Recursive($n$)
        + *if* $n$ = 1
          +   *return* 1
        + *else*
          +   *return* Recursive($n/2$) + Recursive($n/2$)
    ]
  )
]

#exercise[
  Use the recursion tree method to analyze the time complexity of the following recursive algorithm:
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Recursive($n$)
        + *if* $n$ = 1
          +   *return* 1
        + *else*
          +   *return* 2 $times$ Recursive($n/2$)
    ]
  )
]



#exercise[
  Analyse the time complexity of the following recursive algorithm to generate the $n$th Fibonacci number.
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Fibonacci($n$)
        + *if* $n$ = 0 *or* $n$ = 1
          +   *return* $n$
        + *else*
          +   $a$ = Fibonacci($n - 1$)
          +   $b$ = Fibonacci($n - 2$)
          +   *return* $a + b$
    ]
  )
  Find the number of recursive calls made by the algorithm for a given input $n$ (the number of nodes in the recursive tree), and prove that 
  $ T(n) = Theta(phi.alt^n), "where" phi.alt = (1+sqrt(5))/2. $
]

== Telescoping Method
The other method to solve the time complexity of recursive algorithms is the telescoping method. The method is a more mechanical method, because it has almost the same treatment to all cases. It is called "telescoping" method, because it is like telescoping a series, where we try to find a pattern in the time complexity of the algorithm, and then we use the base case and undetermined coefficients to derive an exact expression for the recurrence relation and thus prove the time complexity of the algorithm.

But in a nutshell, this method is quite similar to mathematical induction. You need to find a pattern and take an educated guess, but you donot need hypothesis, because you already have the base case, which can be used to derive the exact expression of the recurrence relation.

#proof[
  We iteratively enumerate the first few terms of the recurrence relation:

  #mitex(
    `
    $$
  \begin{aligned}
  T(n) & =3 T(n / 2)+c n \\
  & =3[3 T(n / 4)+c(n / 2)]+c n \\
  & =9 T(n / 4)+(3 / 2) c n+c n \\
  & =9[3 T(n / 8)+c(n / 4)]+(3 / 2) c n+c n \\
  & =27 T(n / 8)+(9 / 4) c n+(3 / 2) c n+c n \\
  & =\cdots
  \end{aligned}
  $$
    `
  )

and we can generalise the pattern that:
$ T(n) = 3^k T(n / 2^k) + c n sum_(i=0)^(k-1) (3/2)^i, $
which is quite similar to what we have derived in the recursion tree method.

Note that, the base case is $T(1) = O(1)$, which implies that $n/2^k = 1$, so $k = log_2 n$, and we can substitute this to the expression above
  #mitex(
    `
    $$ T(n) = 3^{log_2(n)} \cdot T(1) + cn \cdot [1 + (3/2) + (3/2)^2 + ... + (3/2)^{log_2(n)-1}]. $$
    `
  )
  The constant part of the expression does not depend on $n$, so when $n -> infinity$, the time complexity is dominated by the term $3^(log_2 n) = n^(log_2 3)$, which is the approximately $n^(1.585)$.

  The last step of using the formal definition of Big O notation to prove that $T(n) = O(n^(log_2 3))$ is the same as the recursion tree method, so we will not repeat it here.

]

=== Exercises
Below are some recommended exercises to practice the telescoping method. But you may also try to solve the problems using recursion tree method, or whatever else, and compare the results. 

#exercise[
  Use the telescoping method to analyze the time complexity of the following recursive algorithm:
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Recursive($n$)
        + *if* $n$ = 1
          +   *return* 1
        + *else*
          +   *return* 5 $times$ Recursive($n/2$) + $n$
    ]
  )
]

#exercise[
  Telescoping a closed-form expression for the following recursively defined time complexity:
  $ T(n) = cases(
  T(n/3) + T(2n/3) + n^2 ", if" n > 1,
  1 ", if" n = 1
  ) $
  and thus prove the worst case time complexity of the algorithm is $O(n log n)$
]



== Mathematical Induction
Another method to establish the time complexity of the Karatsuba algorithm is mathematical induction (MI). While this approach is not typically the most efficient for _deriving_ the time complexity of recursive algorithms from scratch—since it requires knowing the target complexity beforehand—it is an excellent tool for _verifying_ a conjectured time complexity, such as $T(n) = O(n^(log_2 3))$. In this case, we already suspect the complexity from the recursion tree and substitution methods, and induction provides a rigorous proof of correctness, especially when the target is known.

#proof[
  We use mathematical induction to prove that the worst-case time complexity of the Karatsuba algorithm satisfies $T(n) = O(n^(log_2 3))$ for all $n$ of the form $n = 2^m$, where $m$ is a positive integer, consistent with our earlier assumption. The recurrence relation is $T(n) = 3T(n/2) + c n$, with the base case $T(1) = O(1)$.

  Consider $n = 1$ (i.e., $m = 0$):  
  - $T(1)$ is a constant-time operation (e.g., multiplying two single-digit numbers), so $T(1) = d$ for some constant $d > 0$.  
  - We need to show $T(1) = O(1^(log_2 3))$. Since $1^(log_2 3) = 1$, and $T(1) = d <= d dot 1 = d dot 1^(log_2 3)$, the base case holds with a constant $c_0 >= d$.

  Assume the statement holds for all $n = 2^k$ where $k < m$, i.e., there exists a constant $c_0 > 0$ such that $T(n) <= c_0 n^(log_2 3)$ for all such $n$. (We'll determine $c_0$ later to ensure the inequality holds.)

  We need to prove the statement for $n = 2^m$, i.e., $T(n) <= c_0 n^(log_2 3)$. Using the recurrence relation:  
  $ T(n) = 3T(n/2) + c n, $  
  where $n/2 = 2^(m-1)$. Since $n/2 < n$ and $n/2 = 2^(m-1)$ is a power of 2, we can apply the inductive hypothesis:  
  $ T(n/2) <= c_0 (n/2)^(log_2 3). $  
  Substitute this into the recurrence:  
  $ T(n) <= 3 dot c_0 (n/2)^(log_2 3) + c n. $  
  Simplify the expression:  
  $ (n/2)^(log_2 3) = n^(log_2 3) dot (1/2)^(log_2 3) = n^(log_2 3) dot 2^(-log_2 3). $  
  Since $2^(log_2 3) = 3$, we have $2^(-log_2 3) = 1/3$. Thus:  
  $ T(n) <= 3 dot c_0 n^(log_2 3) dot (1/3) + c n = c_0 n^(log_2 3) + c n. $  
  We need $T(n) <= c_0 n^(log_2 3)$, so:  
  $ c_0 n^(log_2 3) + c n <= c_0 n^(log_2 3) $  
  must hold. This inequality is false unless the additional term $c n$ is accounted for. Instead, we adjust our hypothesis to include a lower-order term or choose $c_0$ sufficiently large. Since $log_2 3 approx 1.585 > 1$, $c n = O(n^(log_2 3))$, and for large $n$, $c n <= c_1 n^(log_2 3)$ for some constant $c_1$. Thus:  
  $ T(n) <= c_0 n^(log_2 3) + c n <= c_0 n^(log_2 3) + c_1 n^(log_2 3) = (c_0 + c_1) n^(log_2 3). $  
  Choose $c_0$ large enough in the hypothesis (e.g., $c_0 >= d + c$) to absorb lower-order terms across all $n$. To be precise, let’s hypothesize a form that matches our earlier closed-form solution, such as $T(n) <= a n^(log_2 3) - b n$, and test it (as derived from the recursion tree: $T(n) = 6c n^(log_2 3) - 2c n$):  
  - Try $T(n) <= 6c n^(log_2 3) - 2c n$.  
  - Base case: $T(1) = d <= 6c dot 1 - 2c = 4c$, true if $c >= d/4$.  
  - Inductive step:  
    $ T(n) & <= 3 [6c (n/2)^(log_2 3) - 2c (n/2)] + c n = 3 [6c n^(log_2 3) dot 2^(-log_2 3) - c n] + c n \
    &= 6c n^(log_2 3) - 3c n + c n = 6c n^(log_2 3) - 2c n, $  
    which matches exactly.

  Thus, $T(n) <= 6c n^(log_2 3) - 2c n <= 6c n^(log_2 3)$, and by the definition of Big O, $T(n) = O(n^(log_2 3))$.

  The induction confirms that $T(n) = O(n^(log_2 3))$, consistent with the recursion tree and substitution methods. This approach leverages the recurrence directly and verifies our earlier result rigorously.
]

Again, induction is quite handy for proving the time complexity of recursive algorithms. But only when it is possible to make conjecture on the time complexity of the algorithm, and the conjecture is correct, or in the context of exam, you are given the conjecture, and you need to prove it. It is not a good method to derive the time complexity of the algorithm from scratch, because it requires some intuition and educated guess.

=== Exercises
#exercise[
  Discuss the worst time complexity of the following recursive algorithm, and prove it using the induction method:
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Recursive($n$)
        + *if* $n$ = 1
          +   *return* 1
        + *else*
          +   *return* Recursive($n/2$) + Recursive($n/3$) + Recursive($n/6$)
    ]
  )
  Hint: this is a different case where each subproblem has a different size, and therefore, we will have multiple summations in the final expression of the time complexity, which could not be combined. Take an educated guess, or the computation will be quite complex.
]

#exercise[
  The merge sort algorithm has a time complexity of
  $
    cases(
      2T(n/2) + n ", if" n > 1,
      1 ", if" n = 1
    )
  $
  Use the induction method to prove that the worst-case time complexity of the merge sort algorithm is $O(n log n)$.
]

== Substitution Method
The last recommended method to solve the time complexity of recursive algorithms is the substitution method. It is somewaht similar to induction, but it is more mechanical and less intuitive. The method is based on the idea of making an educated guess of the time complexity of the algorithm, and then proving it by the definition of complexity notations by finding appropriate constants that satisfy the definitions.

Now we show how to prove the worst case time complexity of the Karatsuba algorithm using the substitution method.

#proof[
  We start by making an educated guess that the time complexity of the Karatsuba algorithm is $T(n) = O(n^(log_2 3))$. We then prove this by substitution.

  We assume that $T(n) <= c n^(log_2 3)$ for some constant $c > 0$ and all $n$ of the form $n = 2^m$, where $m$ is a positive integer. This is our hypothesis.

  We need to prove that $T(n) = O(n^(log_2 3))$ for all $n$ of the form $n = 2^m$. We use the recurrence relation $T(n) = 3T(n/2) + c n$ and the base case $T(1) = O(1)$.

  Substitute the hypothesis into the recurrence relation:  
  $ T(n) <= 3c (n/2)^(log_2 3) + c n = 3c n^(log_2 3 - 1) + c n = c n^(log_2 3) (3/2) + c n. $  
  We need $T(n) <= c n^(log_2 3)$, so:  
  $ c n^(log_2 3) (3/2) + c n <= c n^(log_2 3) $  
  must hold. This inequality is false unless the additional term $c n$ is accounted for. Instead, we adjust our hypothesis to include a lower-order term or choose $c$ sufficiently large. Since $log_2 3 approx 1.585 > 1$, $c n = O(n^(log_2 3))$, and for large $n$, $c n <= c_1 n^(log_2 3)$ for some constant $c_1$. Thus:  
  $ T(n) <= c n^(log_2 3) + c n <= c n^(log_2 3) + c_1 n^(log_2 3) = (c + c_1) n^(log_2 3). $  
  Choose $c$ large enough in the hypothesis (e.g., $c >= c_1$) to absorb lower-order terms across all $n$. To be precise, let’s hypothesize a form that matches
]

#linebreak()
#remark[
  The technique we play here is a bit abstruce, but we are basically playing with inequality properties. By proper assumption and manipulation, we construct a structure that fits into the definition of Big O notation, and then we prove that the structure is correct by the definition of Big O notation.
]

=== Exercises
Below are some recommended exercises to practice the substitution method.
#exercise[
  Use the substitution method to analyze the time complexity of the following recursive algorithm:
  #figure(
    kind: "algorithm",
    supplement: [Algorithm],
    pseudocode-list(booktabs: true)[
      + *function* Recursive($n$)
        + *if* $n$ = 1
          +   *return* 1
        + *else*
          +   *return* 2 $times$ Recursive($n/2$) + $n^2$
    ]
  )
]

#exercise[
  It is known that an algorithm has a time complexity of $ T(n)= T(n-2) +3$, and $T(1)=T(2)=1$. Use the substitution method to find the worst-case time complexity of the algorithm.

  Hint: this is a very special first-order linear recurrence relation, and we need two base cases to solve it. But our method is still applicable, as long as it is a first-order linear recurrence relation.
]
= Master Theorem: the Silver Bullet
If you have made it this far, after understanding the above-mentioned methods, you are now ready to learn the Master Theorem! The Master Theorem is a powerful tool for solving recurrence relations of a specific form, and it allows us to get the time complexity of an algorithm in a simple and straightforward way, without the need for complex derivations or proofs or calculations like what we have done in the previous sections. However, the most important part is not how the theorem is like and how we can use it, but why it works. We will first discuss the intuition behind the Master Theorem from a basic case, and then generalise it to the Master Theorem.

To make the following contents more readable, we introduce _divide and conquer recurrence relation_. Some of the contents in this part are from Discrete Math and Its Applications by Kenneth H. Rosen @rosenDiscreteMathematicsIts2018. We introduce one terminology from the book here, and we will use it in the following sections.

#definition("Divide and Conquer Recurrence Relation")[
  A *divide and conquer recurrence relation* is a recurrence relation of the form:
  $ T(n) = a T(n/b) + f(n) $
  where:
  - $n$ is a non-negative integer (or, in some contexts, an integer).
  - $a$ and $b$ are positive integers.
  - $f(n)$ is a function of $n$, the size of the input.
  - The recurrence relation describes the time complexity of a divide-and-conquer algorithm that divides the input of size $n$ into $a$ subproblems of size $n/b$ each, and combines the results of the subproblems in $f(n)$ time.
  - In the context of algorithm analysis, we can assume that $n divides b$, i.e., $n$ is divisible by $b$, and thus $n/b in NN^+$.
]

This is something we are very familiar with, because most of the recursive algorithms we have discussed in the previous sections are divide-and-conquer algorithms, such as the Karatsuba algorithm, the merge sort algorithm, the quicksort algorithm, and so on. The Master Theorem is a generalisation of the divide-and-conquer recurrence relation, and it is a powerful tool to solve the time complexity of these algorithms.

While in some cases, the problem is not evenly divided by the algorithm, so we have multiple $T(n)$ terms in the recurrence relation, to which the Master Theorem is not applicable. Our following discussion will be based on the assumption that all problems are evenly divided by the algorithm. Analising the time complexity of algorithms that do not evenly divide the problem is not something can be achived by the Master Theorem, and it requires more advanced mathematical tools, such as #link("https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Combinatorics_(Morris)/02%3A_Enumeration/07%3A_Generating_Functions/7.01%3A_What_is_a_Generating_Function")[generating function].

== Introduction to a Base Case
From previous examples and exercises, we find that, for all evenly divided algorithms, we have the compexity of the form:
$ T(n) = a T(n/b) + f(n) $
where $a$ and $b$ are positive integers, and $f(n)$ is a function of $n$. We can assume that $n$ is divisible by $b$, i.e., $n/b in NN^+$. In most cases, we can assume that $f(n)$ is a polynomial function of $n$, and we can write it as $f(n) = n^c$, where $c$ is a constant. Practically, f(n) has only one term, because in the context of algorithm analysis, we are only interested in the dominant term of the time complexity, and we can ignore the lower-order terms. So rigorously, $n^c$ is the most significant term in $f(n)$. 

It is also important to distinguish that, $a T(n/b)$'s cost is caused by recursive calls themselves, while $f(n)$ are incurred out size of the recurssie calls. In this section, we call it *non-recursive cost*. But note that they are also calculated recursively despite the name, because they are a part of $T(n)$, and $T(n)$ is recursively defined!

The core of *Master Theorem* is discuss the contribution of recursive cost and non-recursive cost to the time complexity of the algorithm. In this section, we only consider the case when $f(n)$ is constant, meaning that $f(n) = c$, where $c$ is some constant. 

#theorem[
  *Basic Master Theorem*:
  let an increasing function $f(n)$ be given, and let $a$ and $b$ be positive integers, and they satisfy
  $ f(n) = a f(n/b) + c $
  $n$ is divisible by $b$, and $a,b in NN^+$, and $c$ is a constant(positive real number). then
  $
    f(n) = 
    cases(
    O(n^(log_b a)) "if" a > 1,
    O(log n) "if" a = 1,
    ).
  $ 

  Additionally, when $n=b^k$ and $a!=1$, where $k in NN^+$,
  $
    f(n) = C_1n^(log_b a) + C_2,
  $
  where $C_1 = f(1)+c/(a-1), C_2 = -c/(a-1)$.
]
#proof[
  Frist, recall that in the examples of the Karatsuba algorithm, we conclude that the recursive part of the total cost can be expressed as the complexity of the base case times by the number of recursive calls, which in this case is $a^k$, where $a$ is the number of subproblems to be solved by one recursive call, and $k$ is the number of levels of the recursion tree. This is derived by applyting the recursive definition until we reach the base case. As for the non-recursive part, similarly, can be written as the sum of a constant series multiplied by the number of levels of the recursion tree, which is $c sum_(i=0)^(k-1) a^i$. With this motivation, consider let $n=b^k$, where $k in NN^+$, and $k$ is the number of levels of the recursion tree. We can write the total cost of the algorithm as:
  $ 
    f(n) = a^k f(1) +  sum_(i=0)^(k-1) a^i c = a^k f(1) + c sum_(i=0)^(k-1) a^i. 
  $ 

  This makes thing very simple, since we only need to discuss the case of $a = 1$ and $a>1$ separately.

  *when $a = 1$*: $sum_(i=0)^(k-1)a^i = sum_(i=0)^(k-1)1 = k$, and thus we have 
  $
    f(n) = f(1) + c k.
  $

  As per stated in the theorem, we have $n = b^k  --> k = log_b n$, therefore
  $
    f(n) = f(1) + c log_b n.
  $
  Now we can discuss the worst-case time complexity of the algorithm when $a=1$.

  Since our base case is constant, we can conclude that $f(n) = O(log n)$ when $a=1$.
  Rigorously, 
  $
    forall n in NN^+, exists c_0 in RR^+, c_0 > c, "such that" f(n) <= c_0 log n.
  $
  Hence, $T(f(n)) = O(log n)$ when $a=1$.

#linebreak()
  #remark[
    *(Optional)* Just remark for discussing the case when $n$ is not a power of $b$. In this case, we must have $b^k < n < b^(k+1)$, where $k$ is a positive integer. We have assumed that $f(n)$ is a increasing function, so we have
    $
      f(n) <= f(b^(k+1)) = f(1) + c(k+1) = f(1) + c +c k <= f(1) + c + c log_b n.
    $
    This also helps to conclude that $f(n) = O(log n)$ when $a=1$. Rigorously,
    $
    forall n in NN^+,  exists c_0 in RR^+, c_0 > c, "such that" f(n) <= c_0 log n.
    $
    Hence, $T(f(n)) = O(log n)$ when $a=1$.
  ]
  *when a > 1*: we still assume that $n = b^k$, where $k in NN^+$, and $k$ is the number of levels of the recursion tree. Recall that 
  $f(n) = a^k f(1) + c sum_(i=0)^(k-1) a^i,$ and we have $sum_(i=0)^(k-1) a^i = (a^k - 1)/(a - 1)$ because it's a geometric series of common ratio $a$. Therefore, we have
  $
    f(n) &= a^k f(1) + c (a^k - 1)/(a - 1)\
    &= a^k f(1)  + (c a^k)/(a-1) - c/(a-1)\
    &= a^k (f(1) + c/(a-1)) - c/(a-1)\
    &=a^(log_b n) (f(1) + c/(a-1)) - c/(a-1)\
    &=n^(log_b a) (f(1) + c/(a-1)) - c/(a-1)\
    &= C_1 n^(log_b a) + C_2
  $
  where $ C_1 = f(1) + c/(a-1)$, $C_2 = -c/(a-1) $.
  We can easily derive the worst case time complexity of the algorithm when $a>1$:
  $
    forall n in NN^+, exists C_0 in RR^+, C_0 > C_1, "such that" f(n) <= C_0 n^(log_b a),
  $
  and hence, $T(f(n)) = O(n^(log_b a))$ when $a>1$.

  #remark[
    *(Optional)* Again we just want to show the treatment of the case when $n$ is not a power of $b$, for those who are interested. In this case, we must have $b^k < n < b^(k+1)$, where $k$ is a positive integer. By our assumption that $f(n)$ is an increasing function, we have
    $
      f(n) &<= f(b^(k+1)) = C_1 a^(k+1) + C_2\
      &<= (C_1 a) a^(log_b n) + C_2\
      &= (C_1 a) n^(log_b a) + C_2\
    $
    where $k <= log_b n < k+1$.

    Again, by the formal definition of Big O notation
    $
      forall n in NN^+, exists C_0 in RR^+, C_0 > C_1, "such that" f(n) <= C_0 n^(log_b a).
    $
    Hence, $T(f(n)) = O(n^(log_b a))$ when $a>1$.
  ]

  To conclude, we have proven all the statements in the theorem.
]

Below is a optional exercise to check your understanding.
#problem[
  Prove the same result using mathematical induction.
]

Now we can reflect on the proof of this basic case of the Master Theorem. The proof is quite simple, and it is based on the intuition that the time complexity of the algorithm is recursively defined and we can find an closed-form, exact expression for the divide-and-conquer recurrence relation.

== Generalisation of the Theorem
Now we can try to take the previous results to a broader context. Previously, we considered only the case when the non-recursive component is only a constant function of $n$. But in practice, the non-recursive component can be a polynomial function of $n$, and in the previous definition of divide-and-conquer recurrence relation that:
$
  T(n) = a T(n/b) + f(n),
$
we can generalise to $f(n) = c n^d$, where $c, d in RR^+ $ and are constants, Thus, the previous case is a special case of this general case, where $d = 0$, so that we have a constant function of $f(n)=c$.
#theorem[
  *Master Theorem*:
  Let an increasing function $f(n)$ be given, and let $a$ and $b$ be positive integers, and they satisfy
  $ f(n) = a f(n/b) + c n^d $
  $n$ is divisible by $b$, and $a,b in NN^+$, and $c, d in RR^+$, and $c, d$ are constants. Then
  $
    f(n) = 
    cases(
    O(n^d log n) &"if" a = b^d,
    O(n^d) &"if" a < b^d,
    O(n^(log_b a)) &"if" a > b^d,
    ).
  $ 
]

#proof[
  First recall the treatment of $T(n)$ in the previous sections, where we applied recursion tree method. We can apply the same treatment to the general case of the recursive complexity applicable in the Master Theorem. 
  
  We can derive the exact form of the recurrence by telescoping the recursive relation:
  $
    f(n) = a f(n/b) + c n^d.
  $<before>
  When $n := n/b$, 
  $
    f(n/b) = a f(n/b^2) + c (n/b)^d. 
  $<after>

  Substitute @after to @before, we have:
  $
    f(n) = a[a f(n/b^2) + c (n/b)^d] + c n^d
        = a^2 f(n/b^2) + c n^d/b^d + c n^d.
  $
  Continue this pattern until we are at the $k$ th level of the recursion tree, we have $k = log_b n$ so $n/b^k = 1$ (actually, but I prefer to keep this form anyway), and the base case is reached, we have:
  $
    f(n) = a^k f(n/b^k) + c  sum_(i=0)^(k-1) n^d (a/b^d)^i.
  $
  Note that $n^d$ is also a constant as $n, d in RR^+$, so we can split it from the summation and get a sum of geometric series, and we have:
  $
    f(n) = a^k f(n/b^k) + c n^d sum_(i=0)^(k-1) (a/b^d)^i.
  $
  The geometric series is quite noticeable here, as it is a ratio of $a$ and $b^d$, which are exactly the variables we discussed by cases in the theorem.
  
  We first discuss the special case when *$a = b^d$*.
  In this case, the geometric series is a constant, and we have:
  $
    f(n) = b^(d k) f(1) + c n^d sum_(i=0)^(k-1) 1 = b^(d k) f(1) + c n^d k.
  $
  Since $k = log_b n$, we have $b^(d k)= b^(log_b n^d) = n^d$, hence
  $
    f(n) = n^d f(1) + n^d c log_b n = n^d (f(1) + c log_b n).
  $
  Since $f(1)$, the cost of base case, is a constant,
  $
    forall n in NN^+, exists c_0 in RR^+, c_0 > c n^d, "such that" f(n) <= c_0 n^d log n.
  $ 

  Hence conclude that $f(n) = O(n^d log n)$ when $a = b^d$.

  In the rest of the cases, the geometric series still plays an important rule in the inference, as it either converge to a constant or diverge to infinity, depending on the ratio of $a$ and $b^d$. 

  Next, we will discuss the case when *$a < b^d$*.
  In this case, the geometric series converges to a constant,
  #remark[
    For those who have diffuculty in understanding the convergence of the sum of the series, here is a unrigorous explaination. When $a < b^d$, as $i$ goes to larger, $a/b^d$ goes smaller, and therefore, when we sum up the series, it tends to converge to a constant. This is a property of geometric series, and it is a well-known fact in mathematics.
  ]
  so we can actually combine the summation $sum_(i=0)^(k-1)(a/b^d)^i$ directly to the constant $c$, and we have:
  $
    f(n) = a^k f(1) + c n^d.
  $ 
  Again, we substitute $k = log_b n$:
  $
    f(n) = a^(log_b n) f(1) + c n^d = n^(log_b a) f(1) + c n^d.
  $
  Since $n$ is the only variable in the expression, let constants $C_1 = f(1)$, $C_2 = log_b a$,
  $
    f(n) = C_1 n^(C_2) + c n^d = n^d (C_1 n^(C_2-d) + c).
  $
  Hence,
  $
    forall n in NN^+, exists C_0 in RR^+, C_0 > C_1 n^(C_2-d) + c, "such that" f(n) <= C_0 n^d. 
  $
  Therefore, $f(n) = O(n^d)$ when $a < b^d$.

  Finally, we discuss the case when *$a > b^d$*.
  In this case, the geometric series diverges to infinity, because $a/b^d > 1$, and we have:
  $
    f(n) = a^k f(1) + c n^d sum_(i=0)^(k-1) (a/b^d)^i.
  $<origin2>
  We may apply @geosum to the series to get the closed-form expression of the complexity function, and we have:
  #let var = $a/(b^d)$
  $
    sum_(i=0)^(k-1) (var)^i = ((var)^k - 1)/((var) - 1).
  $
  We know $k = log_b n$, so:
  $
    sum_(i=0)^(k-1) (var)^i = ((var)^(log_b n) - 1)/(var - 1).
  $<closed_sum>
  Now we can substitute @closed_sum to @origin2, and we have:
  $
    f(n) = a^k f(1) + 1/(var -1) c n^d ((var)^(log_b n) - 1).
  $
  Note that $(b^d)^(log_b n) = n^d$, and $a^(log_b n) = n^(log_b a)$, so we have:
  $
    f(n) &= n^(log_b a) f(1) + (c n^d) /(var - 1) (n^(log_b a)/n^d - 1)\
    &= n^(log_b a) f(1) + (c n^d) /(var - 1) (n^(log_b a -d) - 1).
  $
  Again, let constants $C_1 = f(1)$, $C_2 = (c n^d)/(var - 1)$, 
  $
    f(n) &= C_1 n^(log_b a) + C_2 (n^(log_b a - d) ) - C_2\
    &= C_1 n^(log_b a) + C_2 n^(log_b a) - C_2 n^d -C_2\
    &= (C_1 + C_2) n^(log_b a) - C_2 (n^d + 1)
  $
  Hence we have 
  $
    f(n) = (C_1 + C_2) n^(log_b a) - C_2 (n^d + 1) <= (C_1 + C_2) n^(log_b a).
  $
  Therefore,
  $
    forall n in NN^+, exists C_0 in RR^+, C_0 > C_1 + C_2, "such that" f(n) <= C_0 n^(log_b a).
  $
  Thus, we have $f(n) = O(n^(log_b a))$ when $a > b^d$.

  To conclude, we have proven all the statements in the theorem, and this completes the proof.
]

#problem[
  Can we generalise the result of the conclusion of the Master Theorem to average case time complexity? Think about it!
]

#problem[
  Are there any other way to speed up the derivations? Even though that may be less rigorous, but as long as it is justifiable.
]

=== Reflection on the Proof
What an spetecular proof! Let's reflect on the proof of the Master Theorem. 

In the proof process of the Master Theorem, we are essentially comparing the cumulative contributions of two parts of computational cost: one part comes from the top-down recursive calls of the algorithm, namely the "recursive cost," and the other part is the "non-recursive cost" additionally introduced at each level. Intuitively, this proof tells us that the dominant factor in the overall complexity of the algorithm depends on which part exhibits a faster growth rate after being summed up in the "recursion tree." Specifically, when the number of subproblems generated by the recursive calls (represented by $a$) and the reduction factor of the subproblem size (related to $b^d$) satisfy different relationships, the corresponding geometric series or summation of the entire process will exhibit completely different behaviors—sometimes the series diverges, indicating that the recursive calls dominate the complexity; sometimes the series converges, indicating that the non-recursive cost controls the overall complexity; and in critical cases, the two parts contribute equally, often resulting in an additional logarithmic factor. This discussion of the convergence and divergence of geometric series has actually touched upon important concepts in *mathematical analysis*, such as the limit of a sequence, the radius of convergence of a series, and boundary behaviors. From this perspective, the proof of the Master Theorem is not only an algorithm analysis tool but also a vivid example of mapping discrete recursive processes to continuous mathematical analysis (especially series analysis), allowing us to theoretically see the subtle and profound growth mechanism behind algorithmic complexity!

== Example Use Cases
With all the pains writing the proof, we can now use the Master Theorem to solve the time complexity of the algorithms that fits the divide-and-conquer recurrence relation, without writing lengthy proofs or derivations. Here are some examples of the use of the Master Theorem. These should be quite straightforward, as we have already discussed the intuition behind the theorem.
=== Binary Search
Recall the binary search algorithm, which has a time complexity of $T(n) = T(n/2) + O(1)$, or $T(n) = T(n/2) + c$ We can apply the Master Theorem to solve the time complexity of the binary search algorithm, because it fits the definition of a divide-and-conquer recurrence relation. In this case, $a = 1$, $b = 2$, $d = 0$, so we actually have $a = b^d$. Therefore, the time complexity of the binary search algorithm is $O(log n)$. 
=== Karatsuba Algorithm
Now we move on to analysing Karatsuba Algorithm with Master Theorem. Recall that previously we have to write a bunch of proofs to derive the time complexity of the Karatsuba algorithm, but now we can simply apply the Master Theorem to solve the time complexity at a glance. 

The Karatsuba algorithm has a time complexity of $T(n) = 3T(n/2) + O(n)$, or $T(n) = 3T(n/2) + c n$. In this case, $a = 3$, $b = 2$, $d = 1$, so we have $a > b^d$. Therefore, the time complexity of the Karatsuba algorithm is $O(n^(log_2 3))$. 

== Exercises
#exercise[
  Determine the time complexity for the following recurrence relations using the Master Theorem:
  + $T(n) = 4T(n/2) + n$
  + $T(n) = 2T(n/2) + 1$
  + $T(n) = 3T(n/3) + n^2$
  + $T(n) = 4T(n/2) + n^2$
  + $T(n) = 8T(n/2) + n^2$
]

#exercise[
  For each recurrence relation below, identify which case of the Master Theorem is applicable and then determine the time complexity:

  + $T(n) = 2T(n/3) + 1$
  + $T(n) = 4T(n/2) + n log n$
  + $T(n) = 9T(n/3) + n^2$
  + $T(n) = T(n/2) + 10$
  + $T(n) = 16T(n/4) + n!$
]

#exercise[
  These recurrences are slightly modified. Be careful when applying the Master Theorem, and consider if it's directly applicable or if adjustments are needed.

  + T$(n) = 2T(n/2) + n log n$  (Compare with a similar one in Exercise 2 - note the $log n$ term!)
  + $T(n) = 2T(n/4) + sqrt(n)$ (Note $n/4$ instead of $n/2$)
+ $T(n) = T(n/2) + n / log n$ (Is $f(n) = n / log n $in the polynomial form the theorem expects?)
+ $T(n) = 0.5T(n/2) + n$ (Note the coefficient 0.5 for the recursive term. Does the theorem still apply directly?)
+ $T(n) = 2T(n/2 - 1) + n$ (Note the $n/2 - 1$ instead of $n/2$. Consider the impact for large $n$.)
]

#exercise[
  Consider the recurrence $T(n) = 2T(n/2) + n log n$.  The Master Theorem in its basic form might not directly apply in a very strict sense because $f(n) = n log n$ is not strictly of the form $n^d$. However, can you reason about the time complexity?  Hint:  Think about how the proof of the Master Theorem works and how the sum might change with log n factors.  (This is more of a thinking exercise and might require slightly more advanced analysis.)
]

#bibliography("ref.bib", style: "ieee")
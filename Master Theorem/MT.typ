#import "@preview/dvdtyp:1.0.1": * // template
#import "@preview/lovelace:0.3.0": * // pseudocode
#import "@preview/cetz:0.3.3"  // plot
#import "@preview/mitex:0.2.5": * // latex to typst

#show: dvdtyp.with(
  title: "Master Theorem and Recurssion",
  subtitle: [Motivation, formal proof, and examples],
  author: "Eric Yang Xingyu",
  abstract: lorem(0),
)
#show link: set text(fill: blue)


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



== Complexity Notations Recap
Before we dive into complexity analysis of recursive algorithms, let's recap the complexity notations we will use in this article. Note that we will only use Big O (particularly) and Big Omega notations, as they are the most commonly used notations in complexity analysis.
#definition("Big O Notation")[
  Big O notation is used to describe the upper bound of the growth rate of a complexity function. Formally, $f(n) = O(g(n))$ if there exist positive constants $c$ and $n_0$ such that $ forall n >= n_0, 0 <= f(n) <= c dot g(n). $
]

#definition("Big Omega Notation")[
  Big Omega notation is used to describe the lower bound of the growth rate of a complexity function. Formally, $f(n) = Omega(g(n))$ if there exist positive constants $c$ and $n_0$ such that $ forall n >= n_0, 0 <= c dot g(n) <= f(n). $
]

Average case complexity is not discussed in this article, as it is not commonly used in complexity analysis of recursive algorithms.

= Common Methods for Analysing Recursive Algorithms
Now we will try to solve the last problems we mentioned in @problems.

We just recap the definitions of the recurrence relation and the time complexity of the algorithm, and we must first point out one crucial standing point in the analysis of recursive algorithms:

#proposition[
  To analyze the time complexity of a recursive algorithm, we *must* derive a non-recursive expression for the recurrence relation that describes the time complexity of the algorithm, which is bounded only by some variables $n$, where $n$ is the size of the input.
]

This is because the time complexity of the algorithm is usually dependent on the time complexity of solving the subproblems, and the number of subproblems is usually dependent on the size of the input. So we must derive a non-recursive solution for the recurrence relation, which is a direct function of $n$. If we do not do this, the recursive definition cannot be used to argue for time complexity notations, because it is not a function of $n$, but a transition equation that is dependent on the complexity of subproblems, despite the fact that the $T(n)$ is indeed indirectly dependent on $n$. However, *this is not a solid arguement to prove the time complexity of the algorithm, as per the definitions*!

== Linear Recurrence Relations
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

== Recurssion Tree analysis
One of the most intuitive methods to analyze the time complexity of basic recursive algorithms is by investigating the *recursion tree*. The recursion tree is a visual representation of the recursive calls made by the algorithm, which helps us understand the number of recursive calls and the time complexity of each call. In this method, we will try to find the time complexity of each call with respect to the input size, and then sum up the time complexity of all calls by traversing all levels of the recursion tree.

In the context of Karatsuba's algorithm, we can represent the recursive calls as a tree, where each level of the tree corresponds to a recursive call, and the branching factor is the number of subproblems created at each level. In this case, we have a single root $T(n)$ and three children $T(n/2)$ at each level, so on and so forth. So this is actually a ternary tree.
#scale(75%)[
#figure(caption: "Recursion Tree of Karatsuba Algorithm up to 3 Levels",
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
  $ T(n) = sum_(k=0)^((log_2 n)) 3^k (c n/2^k)
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

== Substitution Method
The other method to solve the time complexity of recursive algorithms is the substitution method. The substitution method is a more mechanical method, because it has almost the same treatment to all cases. It is also called "telescoping" method, because it is like telescoping a series, where we try to find a pattern in the time complexity of the algorithm, and then we use the base case and undetermined coefficients to derive an exact expression for the recurrence relation and thus prove the time complexity of the algorithm.

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
    $$ T(n) = 3^{\log_2(n)} \cdot T(1) + cn \cdot [1 + (3/2) + (3/2)^2 + ... + (3/2)^{\log_2(n)-1}]. $$
    `
  )
  The constant part of the expression does not depend on $n$, so when $n -> infinity$, the time complexity is dominated by the term $3^(log_2 n) = n^(log_2 3)$, which is the approximately $n^(1.585)$.

  The last step of using the formal definition of Big O notation to prove that $T(n) = O(n^(log_2 3))$ is the same as the recursion tree method, so we will not repeat it here.

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
    $ T(n) <= 3 [6c (n/2)^(log_2 3) - 2c (n/2)] + c n = 3 [6c n^(log_2 3) dot 2^(-log_2 3) - c n] + c n = 6c n^(log_2 3) - 3c n + c n = 6c n^(log_2 3) - 2c n, $  
    which matches exactly.

  Thus, $T(n) <= 6c n^(log_2 3) - 2c n <= 6c n^(log_2 3)$, and by the definition of Big O, $T(n) = O(n^(log_2 3))$.

  The induction confirms that $T(n) = O(n^(log_2 3))$, consistent with the recursion tree and substitution methods. This approach leverages the recurrence directly and verifies our earlier result rigorously.
]
= Master Theorem: the Silver Bullet
Congratulations! If you have made it this far, after understanding the above-mentioned methods, you are now ready to learn the Master Theorem! The Master Theorem is a powerful tool for solving recurrence relations of a specific form, and it allows us to get the time complexity of an algorithm in a simple and straightforward way, without the need for complex derivations or proofs or calculations like what we have done in the previous sections. However, the most important part is not how the theorem is like and how we can use it, but why it works. We will first discuss the intuition behind the Master Theorem from a basic case, and then generalise it to the Master Theorem.
== Introduction to a Base Case

== Generalisation of the Base Case

== Example Use Cases
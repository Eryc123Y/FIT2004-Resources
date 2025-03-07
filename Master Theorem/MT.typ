#import "@preview/dvdtyp:1.0.1": * // template
#import "@preview/lovelace:0.3.0": * // pseudocode

#show: dvdtyp.with(
  title: "Master Theorem and Recurssion",
  subtitle: [Motivation, formal proof, and examples],
  author: "Eric Yang",
  abstract: lorem(0),
)

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
  - How can we transfer the time complexity $T(n)$ to big $O$ notation?
  - How can we derive a closed-form solution for the recurrence relation like $T(n) = T(n/2) + c$?  
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
In this article, we do not discuss the details of the algorithm, but only derive the recurrence relation from the recursive implementation.
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
  To analyze the time complexity of a recursive algorithm, we need to derive a closed-form solution for the recurrence relation that describes the time complexity of the algorithm, which is bounded only by some variables $n$, where $n$ is the size of the input.
]

= Master Theorem: the Silver Bullet
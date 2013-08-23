---
layout: post
title:  "The miraculous world of comparison"
date:   2013-08-19 13:46:07
tags: [jbj, WFT]
category: jbj
---

This is kind of a follow-up to my post about [Implicit conversions](/2013/08/15/implicit-conversions). Maybe you remember the little ranting that the operator defines the kind of conversion to apply. Well, when it come to comparison things become even more obscure. In short if may be summarized like this: "Take an educated guess and you may be right - some times you are not".

# The ==

But lets go a bit more in detail: First compare something to an integer
{% highlight php %}
<?php
echo "1: "; var_dump(123 == 123);
echo "2: "; var_dump(123 == 123.0);
echo "3: "; var_dump(123 == "abcd");
echo "4: "; var_dump(123 == "123");
echo "5: "; var_dump(123 == "1.23e2");
echo "6: "; var_dump(123 == "   123.0000000abcdef   ");
?>
{% endhighlight %}
which leads to

~~~
1: bool(true)
2: bool(true)
3: bool(false)
4: bool(true)
5: bool(true)
6: bool(true)
~~~

The last parts could be considered a bit ridiculous, but in the light of implicit conversions it kind of makes sense. Obviously, when comparing to an integer everything is tries to be converted to an integer.

The same rule applies to double, so I will not bore you with another example. Instead: What about string comparison? Well, the `==` operator should be commutative - luckily PHP does not dare to break this rule. Lets take a look:

{% highlight php %}
<?php
echo "1: "; var_dump("123" == 123);
echo "2: "; var_dump("123" == 123.0);
echo "3: "; var_dump("123" == "abcd");
echo "4: "; var_dump("123" == "123");
echo "5: "; var_dump("123" == "1.23e2");
echo "6: "; var_dump("123" == "   123.0000000abcdef   ");
?>
{% endhighlight %}

~~~
1: bool(true)
2: bool(true)
3: bool(false)
4: bool(true)
5: bool(true)
6: bool(false)
~~~

Wut?

Ok, so strings are compared like strings should be - unless they can be converted to a number, though with stricter rules than before. It seems that in this case strings are only treated as numbers if they actually conform to a regular number pattern. Err ... so the `==` operator is commutative but not transitive? Allow PHP answer this question itself:

{% highlight php %}
<?php
echo 'So "123" == 123 ? ', ("123" == 123 ? 'Yep' : 'Nope') . "\n";
echo 'And 123 == "  123  " ? ', (123 == "  123  " ? 'Yep' : 'Nope') . "\n";
echo 'Therefor "123" == "  123  " ? ', ("123" == "  123  " ? 'Yep' : 'Nope') . "\n";
?>
{% endhighlight %}

~~~
So "123" == 123 ? Yep
And 123 == "  123  " ? Yep
Therefor "123" == "  123  " ? Nope
~~~
Little me may add: WFT!

# The < <= > >=

Apart from the strange rules for strings the ordering operators behave just as expected. When ordering string you might stumble over this one:

{% highlight php %}
<?php

echo "1: "; var_dump("2" < "123");
echo "2: "; var_dump("a2" < "a123");
?>
<{% endhighlight %}

~~~
1: bool(true)
2: bool(false)
~~~

So if you want to enforce strict string ordering (i.e. like everyone else does it), you probably have to prepend the strings with a space or something. Or maybe there is another established established pratice for this.


Anyway, what about the other types? Arrays for example.

PHP has the rather reasonable rule that arrays are only `==` if all there elements are `==`. Lets try to order them now

{% highlight php %}
<?php
$a = array(1,2,3);
$b = array(1,2,4);
$c = array(1,2,3,4);

echo '$a < $b: '; var_dump($a < $b);
echo '$b < $c: '; var_dump($b < $c);
echo '$a < $c: '; var_dump($a < $c);
echo '$a > $b: '; var_dump($a > $b);
echo '$b > $c: '; var_dump($b > $c);
echo '$a > $c: '; var_dump($a > $c);
?>
{% endhighlight %}

~~~
$a < $b: bool(true)
$b < $c: bool(true)
$a < $c: bool(true)
$a > $b: bool(false)
$b > $c: bool(false)
$a > $c: bool(false)
~~~

Ok, looks all quite reasonable to me. At least thats the way how arrays should be ordered right?

But, wait! In PHP arrays could be something everyone else calls a map. How exactly do you order a map? Let see:
{% highlight php %}
<?php
$a = array("a" => 1);
$b = array("a" => 2);
$c = array("c" => 1);

echo '$a == $b: '; var_dump($a == $b);
echo '$a < $b: '; var_dump($a < $b);
echo '$a > $b: '; var_dump($a > $b);
echo '$a == $c: '; var_dump($a == $c);
echo '$a < $c: '; var_dump($a < $c);
echo '$a > $c: '; var_dump($a > $c);
?>
{% endhighlight %}

~~~
$a == $b: bool(false)
$a < $b: bool(true)
$a > $b: bool(false)
$a == $c: bool(false)
$a < $c: bool(false)
$a > $c: bool(false)
~~~

Wut?

Here is a little implementors note: In a reasonable object-oriented language one has an `Comparable` or `Ordered` interface/trait with a corresponding `Comparator` (or something very similar). Usually this boils down to a `compare` or `compareTo` method with a tripple state result: `< 0` means lower than, `> 0` greater than and `== 0` means equal.

Considering the example above the `compare` of a PHP array also requires a fourth state: "Not lower, not greater but certainly not equal".

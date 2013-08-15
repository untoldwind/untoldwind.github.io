---
layout: post
title:  "Implicit conversions"
date:   2013-08-15 13:46:07
tags: WFT
category: jbj
---

Lets talk about implicit conversions for a moment. Again, this might be an old hat for seasoned PHP developers, but I realy had some "fun" reimplementing this.

# Conversions

Before we come to the implicit stuff we first have to have to take a closer look at conversions itself. In PHP once any convert pretty much everything into anything else ... well, with some twists that may raise some brows, at least mine.

So, lets  take a look at this example
{% highlight php %}
<?php
echo "1 : "; var_dump((bool)1);
echo "2 : "; var_dump((bool)"true");
echo "3 : "; var_dump((int)"123");
echo "4 : "; var_dump((double)"123.56");
echo "5 : "; var_dump((double)123);
echo "6 : "; var_dump((string)123);
echo "7 : "; var_dump((string)123.56);
echo "8 : "; var_dump((string)true);
?>
{% endhighlight %}

Actually the result is not that much surprising

~~~
1 : bool(true)
2 : bool(true)
3 : int(123)
4 : float(123.56)
5 : float(123)
6 : string(3) "123"
7 : string(6) "123.56"
8 : string(1) "1"
~~~

Well, the last one raises some suspicion: Obviously one can convert the string `"true"` to boolean `true`, but the other way round you get the string `"1"`. Lets take a closer look at the boolean conversions

{% highlight php %}
<?php
echo "1 : "; var_dump((int)true);
echo "2 : "; var_dump((int)false);
echo "3 : "; var_dump((string)true);
echo "4 : "; var_dump((string)false);
?>
{% endhighlight %}
and the result is

~~~
1 : int(1)
2 : int(0)
3 : string(1) "1"
4 : string(0) ""
~~~

Errr ... so boolean `true` is converter to integer `0` resp. string `"1"`, but `false` to integer `0` resp. an empty string `""`?
Seems to be slightly inconsistent, but maybe there is some good reasoning.

But what about string-number conversions?
Yes, it is quite handy to convert strings to number by a cast, but what if the string is not a number? Lets see
{% highlight php %}
<?php
echo "1 : "; var_dump((int)"abc");
echo "2 : "; var_dump((int)" 123abc");
echo "3 : "; var_dump((int)" 123.456abc");
echo "4 : "; var_dump((double)"abc");
echo "5 : "; var_dump((double)" 123.456abc");
?>
{% endhighlight %}
and we get

~~~
1 : int(0)
2 : int(123)
3 : int(123)
4 : float(0)
5 : float(123.456)
~~~

Errr ... ok, so PHP tries to do its best (even by trimming the string accordingly) and if all fails it just produces a `0` resp. `0.0`.
Without any kind of error, warning or at least notice?
Yes, without any kind of error, warning, notice, whatever!

Lets leave it at that for the moment an concentrate on ...

# The implicit part

And here it gets real. PHP applies its conversions as need by the current operation.
For example: Probably one of the must common error of a Java developer is trying to concatinate string with `+`
{% highlight php %}
<?php
$i = 12;
$d = 123.456;
echo "1 : "; var_dump("i = " + $i);
echo "2 : "; var_dump("d = " + $d);
echo "3 : "; var_dump("i = " + $i + " d = " + $d);
echo "4 : "; var_dump("i = " + $i + " 123456789 d = " + $d);
?>
{% endhighlight %}
and you get

~~~
1 : int(12)
2 : float(123.456)
3 : float(135.456)
4 : float(123456924.456)
~~~

Huh?
Well, considering what we have learned in the former section this should not be that surprising any more. The `+` operator (as well as all other arithmetic operators) require number, i.e. all string are implicitly converted to a number, which may or may not succeed. Take this into consideration the example above actually is interpreted like this:

~~~
1 : 0 + 12
2 : 0 + 123.456
3 : 0 + 12 + 0 + 123.456
4 : 0 + 12 + 123456789 + 123.456
~~~

... and it all makes sense now, kind of at least.

Of course, you very soon learn that strings are actually concatinated by the `.` operator. Here the same rules apply, just the other way round, i.e. when using the `.` operator all operants are implicitly converted to string. If we now remember the little quirk with boolean once can produce some (at first sight) surprising results

{% highlight php %}
<?php
echo "1 : " . true . "\n";
echo "2 : " . false . "\n";
?>
{% endhighlight %}
which of course results in

~~~
1 : 1
2 :
~~~

Ok, now that we understood this, lets experiment with some more operators

{% highlight php %}
<?php
echo "1 : "; var_dump("12" - "34");
echo "2 : "; var_dump("12" * "34");
echo "3 : "; var_dump("12" / "34");
echo "4 : "; var_dump("12" % "34");
echo "5 : "; var_dump("12" & "34");
echo "6 : "; var_dump("12" | "34");
?>
{% endhighlight %}
and you get

~~~
1 : int(-22)
2 : int(408)
3 : float(0.35294117647059)
4 : int(12)
5 : string(2) "10"
6 : string(2) "36"
~~~

Which could be also be translated to

1. Ok
2. Ok
3. Hmmm ... I expected an integer, but ... yah, ok
4. Ok
5. Wut?
6. WTF!

Now take a look at the post about [Binary strings](/2013/08/13/binary-strings-wtf). Obviously in case of all bitwise operators strings are not interpreted as number, but as arrays of bytes instead. Of course bitwise operators on numbers work as "expected"

{% highlight php %}
<?php
echo "1 : "; var_dump("12" & "34");
echo "2 : "; var_dump(12 & 34);
echo "3 : "; var_dump("12" | "34");
echo "4 : "; var_dump(12 | 34);
?>
{% endhighlight %}

~~~
1 : string(2) "10"
2 : int(0)
3 : string(2) "36"
4 : int(46)
~~~

Lets just leave it at that for today.

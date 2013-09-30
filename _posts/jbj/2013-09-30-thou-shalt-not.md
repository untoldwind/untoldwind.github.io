---
layout: post
title:  "Thou shalt not modify the array thou are iterating"
date:   2013-09-30 13:46:07
tags: [jbj, WFT]
category: jbj
---

Every programmer knows (or should know) that bad things will happen if one loops over an collection-like structure and make changes to it at the same time. Back in the days of C - depending on the actually implementation of your list - you might have ended up in endless loops, your pointers might direct you to nirvana or even much worse. 

Java quite successfully addressed this problem by introducing the `ConcurrentModificationException`, which is basically a slap on the hand: Don't do this! Alas it still just occurs at runtime, which - depending on your effective test-coverage - might be already much too late.

More modern languages like Scala try to discourage modification of collections right from the beginning in favor of immutable collection transformed by a functional paradigm. Even though the more recent versions of PHP now contain this paradigms as well, in its core PHP is no such thing as a modern language.

So lets take a look at the many ways of looping over an array in PHP

# Brute-force index access

C programmers will love this. Some Java programmers - who started before 1.5 - might as well.

{% highlight php %}
<?php
$a = array("one", "two", "three");

for($i = 0; $i < count($a); $i++)
    echo "$a[$i]\n";
?>
{% endhighlight %}

Ah, the smell of nostalgia. Unluckily it only work with integer-based arrays. And if you add some elements to the array like this ...

{% highlight php %}
<?php
$a = array("one", "two", "three");

for($i = 0; $i < count($a); $i++) {
    echo "$a[$i]\n";
    $a[] = "Dont do this";
}
?>
{% endhighlight %}

... you end up with an endless loop - not surprisingly.

But, seriously, who is still doing it this way?

# The mysterious internal iterator

Did you know that PHP-arrays have a build-in iterator? Old PHP developers certainly know this, but I asked a bit around and got more than one raised eyebrow. Actually you can do something like this

{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

reset($a);
while (list($key, $value) = each($a)) {
    echo "$key => $value\n";
    echo "My next value will be: " . current($a) . "\n";
    echo "My next key will be: " . key($a) . "\n";
}
?>
{% endhighlight %}
(Actually the `reset` is not even necessary at this point, I just added it for emphasis.)

Obviously this also works with with any key-value arrays. Unluckily there is only one iterator per array, so if you want to iterate the same array in an inner loop you have to copy it:

{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

while (list($key, $value) = each($a)) {
    echo "Outer: $key => $value\n";
    $b = $a;
    reset($b);
    while (list($key, $value) = each($b)) {
        echo "Inner: $key => $value\n";
    }
}
?>
{% endhighlight %}
(This time the `reset` is necessary, since the current position of the iterator is copied from `$a`.)

But of couse this method is not safe from modification either:
{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

reset($a);
while (list($key, $value) = each($a)) {
    echo "$key => $value\n";
    $a[] = "Dont do this";
}
?>
{% endhighlight %}

... and you end up in the same endless loop as before.

But, seriously, is there still someone out there, doing it this way?

# The `foreach`

At some point in its history PHP (PHP 4 I presume) introduced the `foreach` statement which should offer a clearer ways of iterating arrays. Actually the basics are indeed quite clean:

{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

foreach($a as $key => $value) {
    echo "Outer: $key => $value\n";
    foreach ($a as $key => $value) {
        echo "Inner: $key => $value\n";
    }
}
?>
{% endhighlight %}
... just works as expected, no need of copying/reseting any more.

And it even prevents the endless loop case demonstrated in the previous sections:
{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

foreach($a as $key => $value) {
    echo "$key => $value\n";
    $a[] = "Here you can do it";
}
?>
{% endhighlight %}

So, everything is shiny ... right?

Hmmm ... just allow me to add a short line in front of the `foreach`:
{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

$b=&$a;
foreach($a as $key => $value) {
    echo "$key => $value\n";
    $a[] = "Now you dont";
}
?>
{% endhighlight %}

And there you have your endless loop again.

WTF!

Well, yes, this little ... uh ... *feature* you will find deeply hidden in the PHP documentation. Usually `foreach` operates on a 'copy' of the array, unless the array is referenced somewhere.

It should be also noted that if you want to access the values of the array as reference, this also counts a reference to the array itself. So this one


{% highlight php %}
<?php
$a = array("one" => "Is the one", "two" => "Is the two", "three" => "Guess who");

foreach($a as $key => &$value) {
    echo "$key => $value\n";
    $a[] = "Now you dont";
}
?>
{% endhighlight %}

... ends up in an endless loop as well. (Note the little `&` in front of the `$value` in case you missed it.)

But, if one does not use these evil `&`-signs everything is shiny ... right?

Hmmm ... allow me to point to a short notice in the PHP manual:

> As **foreach** relies on the internal array pointer changing it within the loop may lead to unexpected behavior.

Thats why I wrote 'copy' instead of copy: Whatever `foreach` actually does internally, it does not create a fully copy of the array to operate on, it still manipulates the internal iterator of the original. In the modern versions of the interpreter this should not be a problem though.

# Summary

The overall lesson of this short excursion in array-looping is already stated in the title: Thou shalt not modify the array thou are iterating!
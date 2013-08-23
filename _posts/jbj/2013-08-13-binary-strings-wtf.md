---
layout: post
title:  "Binary strings"
date:   2013-08-13 13:46:07
tags: [jbj, WFT]
category: jbj
---

This is probably an old hat for PHP veterans, but little me was kind of surprised by this.
After 15 years of Java related development I probably became somewhat detached to the roots: 
Once upon a time there were no strings, just bytes.

It seems that PHP - maybe due to some kind of misplaced nostalgia - still wants to honor these good old times.
Lets take a look what happens if you innocently use umlauts:

{% highlight php %}
<?php
$a = "äöü";

echo strlen($a) . '\n';
?>
{% endhighlight %}

And the result is ... well, actually I can tell you what result you will get on your system, on my system it is

~~~
6
~~~

Duh ... ok, well UTF-8. So PHP strings are actually what a Java programmer would call a byte-array, and they are
now implemented this way in jbj.

On a side note: Of course I am (now) aware of the correct way to handle UTF-8 strings in PHP, it is called
the `mbstring` extension, which ist quite standard on must systems - and probably will be a hell to reimplement
in jbj (maybe not).
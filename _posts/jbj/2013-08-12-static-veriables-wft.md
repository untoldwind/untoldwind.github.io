---
layout: post
title:  "Static variables"
date:   2013-08-12 13:46:07
tags: WFT
category: jbj
---

For those of you who wonder why there is a `de.leanovate.jbj.ast.StaticInitializer` trait with a rather crazy logic, here is a little story.

What do you expect as result of the following PHP script?

{% highlight php %}
<?php
$a = 10;
echo "First: $a\n";

static $a = 20;
echo "Second: $a\n";

if ( $a < 35 ) {
	static $a = 30;
	echo "Third: $a\n";
} else {
	static $a = 40;	
	echo "Fourth: $a\n";
}
?>
{% endhighlight %}

Well?

Not sure what I was thinking, but for course it is:

~~~
First: 10
Second: 40
Fourth: 40
~~~

WTF!

Ok, maybe I do PHP a little injustice as there - some long time ago - might have been a legitimate reasoning of this behavior. The worse par though is that this is not consistent with itself.

Lets say you fool around with `eval()` ... ok, most certainly you you should not, just assume for a moment you do anyway:

{% highlight php %}
<?php
$a = 10;
echo "First: $a\n";

static $a = 20;
echo "Second: $a\n";

if ( $a > 30 ) {
	eval('static $a = 5;');
	echo "Third: $a\n";
} else {
	echo "Fourth: $a\n";
}
echo "Fifth: $a\n";
static $a = 40;	
echo "Final: $a\n";
?>
{% endhighlight %}

And you will end up with this:

~~~
First: 10
Second: 40
Third: 5
Fifth: 5
Final: 40
~~~
 
Something similar can be produced using `include` or `require`.

 So my initial assessment will remain unchanged: WTF!

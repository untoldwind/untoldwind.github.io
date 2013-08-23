---
layout: post
title:  "Global fun"
date:   2013-08-17 13:46:07
tags: [jbj, Fun]
category: jbj
---

I really had a good laugh at this.

Did you know, that PHP as a `$GLOBALS` global variable containing all global veriables as array? Well, if not, now you do. In consequence this means that there are essentially two way to to access global variables: Just take a look at the folling example

{% highlight php %}
<?php
$a = "This is a";
$GLOBALS['b'] = "This is b";
var_dump($GLOBALS['a']);
var_dump($b);
?>
{% endhighlight %}
which results in

~~~
string(9) "This is a"
string(9) "This is b"
~~~

So far so good. Now here's the fun part `$GLOBALS`, being a global variable, contains itself. Well, at least this is quite consequent, though it offers the posibility to do something like this:
{% highlight php %}
<?php
$a = "This is a";
$GLOBALS['b'] = "This is b";
$GLOBALS['GLOBALS']['c'] = "This is c";
var_dump($GLOBALS['a']);
var_dump($GLOBALS['GLOBALS']['b']);
var_dump($c);
?>
{% endhighlight %}
and of course you get

~~~
string(9) "This is a"
string(9) "This is b"
string(9) "This is c"
~~~

Also - with the help of references - you can redefine `$GLOBALS` to anything you like. Lets mess with this a bit more seriously:

{% highlight php %}
<?php
$a = &$GLOBALS;
$a['b'] = "This is b";
$a['a']['c'] = "This is c";
$a['a'] = "This is a";
var_dump($a);
var_dump($b);
var_dump($c);
?>
{% endhighlight %}
just has the same result as above. I do not even want to imagine what else you could do with this.

Instead I just want to conclude, by correcting myself: `$GLOBALS` is not only a "global" variable, actually it is a "superglobal" variable, which essentially means that it is implicitly available in any scope without declaration.

Yep, PHP actually has this kind of concept, you can read it all by yourself in the [PHP Manual](http://www.php.net/manual/en/language.variables.superglobals.php).
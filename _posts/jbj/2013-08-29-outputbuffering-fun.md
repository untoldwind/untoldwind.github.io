---
layout: post
title:  "Output buffering fun"
date:   2013-08-29 13:46:07
tags: [jbj, Fun]
category: jbj
---

I just started to create compatible output buffering in jbj and encountered the following "official" test case:

{% highlight php %}
<?php
echo 0;
	ob_start();
		ob_start();
			ob_start();
				ob_start();
					echo 1;
				ob_end_flush();
				echo 2;
			$ob = ob_get_clean();
		echo 3;
		ob_flush();
		ob_end_clean();
	echo 4;
	ob_end_flush();
echo $ob;
?>
{% endhighlight %}

Actually I do not see a real-world use-case for this kind of buffer nesting, but it is a nice little brain-gym to guess the output of this snippet.

 By the way, it is

 ~~~
 03412
 ~~~

Of course ... I mean, what would you have expected?
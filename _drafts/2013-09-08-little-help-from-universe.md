---
layout: post
title:  "With a little help from the universe"
date:   2013-09-08 13:46:07
tags: [jbj, Scala]
category: jbj
---

For some time I was looking for a suitable way to implement all the predefined functions of PHP without creating lots of boilerplate code. Until recently this was done by reflection, which of cause opens up the way for rather ugly runtime errors. In Java this seems to be the only way - well, apart from instrumentation, which might lead to even harder traceable error cases. Luckily Scala now offers a way to do it all at compile time with macros - as of version 2.10 to be precise. Here is a little story about the stony path to get there.

First of all it worth noting that the whole macro API is still considered "experimental" and supposed to be stabilized in Scala 2.12 or beyond. In other words: Things are still a bit rough at the edges, there is next to no tool support (yet?) and more the likely you will get a bloody nose on your first tries. Of course there are some guides that help you getting started:

* The official documentation: [Def Macros](http://docs.scala-lang.org/overviews/macros/overview.html)
* A very well written Article by Adam Warski: [Starting with Scala Macros: a short tutorial](http://www.warski.org/blog/2012/12/starting-with-scala-macros-a-short-tutorial/#comments)
* ... another one that seems to point in the right direction: [
Automatic generation of delegate methods with Macro Annotations](http://www.warski.org/blog/2013/09/automatic-generation-of-delegate-methods-with-macro-annotations/)

But lets get started at our own pace. One of the simplest examples for a Scala macro probably looks like this:

{% highlight scala %}
import language.experimental.macros
import scala.reflect.macros.Context

object Hello {
  def helloWorld(): Unit = macro helloWorld_impld

  def helloWorld_impld(c: Context)(): c.Expr[Unit] = {
    import c.universe._
    reify {
      println("Hello World!")
    }
  }
}
{% endhighlight %}

Actually there are already a lot of information hidden in these few lines of cose. I will come to that in due time, lets try to get the one running first

# Pitfall No. 1: You can use a macro in the same compilation run

If you think it over, it is quite obvious. Nevertheless your first impulse might be to write a little test program

{% highlight scala %}
object HelloTest {
  def main(args:Array[String]) {
    Hello.helloWorld()
  }
}
{% endhighlight %}

and run it in your IDE of choice. Chances are the Scala compiler will just give you a slap on your hands:

~~~
scala: macro implementation not found: helloWorld (the most common reason for that is
that you cannot use macro implementations in the same compilation run that defines them)
~~~

Well, the message speaks for itself ... and - as stated - it is quite obvious, if you think it over.

There are several ways to circumvent this problem. Most commonly it is suggested that one should at a special source directory to the projects so that macros could be defined and used in two different compilation runs. Like this:

~~~
src
+- main
   +- macros
   +- scala
~~~

In jbj I solves this problem by splitting up the project in to different modules. All macros are defined inside the "jbj-runtime" modules and actually used in the "jbj-core" module (or any other dependent).


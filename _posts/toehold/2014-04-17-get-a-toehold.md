---
layout: post
title:  "Get a toehold"
date:   2014-04-17 13:46:07
tags: [toehold, jbj]
category: toehold
---

So of the feedback at the [BED-Con](http://bed-con.org) encouraged me to reconsider the original goals of `jbj`, which eventually let to an entirely now project called `toehold`.

Even though both project are entirely separate from each other (at least right now), they share a common goal: Allowing the integration of legacy PHP code into a Java-based project with the possibility of a step-by-step migration. 

`jbj` attacks this problem with the bold goal of implementing a comparable PHP interpreter inside the Java-VM in combination with a Code-converter. Though there have been some improvements so far - as well as a great learning experience - jbj is not anyway near completion or even ready for production.

`toehold` approaches the problem in a much simpler far more pragmatic way. Instead of recreating everything from scratch it offers a set of tools to support a close interaction between the Java-VM and the PHP-interpreter. The first building block is a non-blocking FastCGI client based on [akka](http://akka.io) and a corresponding plugin for the [Play framework](http://playframework.com). With these two simple tools its already possible to integrate any kind of PHP-application into (or rather behind) a Play-application.

Of course this should be just the start, and there is some hope that all the work spend on jbj will not be wasted.
---
layout: page
title: untoldwind projects
tagline: github projects
---
{% include JB/setup %}

# News

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

# Projects of interest

* [jbj]({{ BASE_PATH }}projects/jbj.html)
* [durchlauf]({{ BASE_PATH }}projects/durchlauf.html)



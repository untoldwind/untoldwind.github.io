---
layout: page
title: untoldwind's projects
tagline: mostly on github
---
{% include JB/setup %}

# News

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

# Projects of interest

* [toehold]({{ BASE_PATH }}projects/toehold.html)
* [jbj]({{ BASE_PATH }}projects/jbj.html)
* [alfred2-layout]({{ BASE_PATH }}projects/alfred2-layout.html)
* [durchlauf]({{ BASE_PATH }}projects/durchlauf.html)

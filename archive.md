---
layout: default
title: The Archive
---

# Chronological Order

Here is a list of all postings in chronological order.

{% assign postsByYearMonth = site.posts | group_by_exp: "post", "post.date | date: '%B %Y'" %}
<ul>
{% for yearMonth in postsByYearMonth %}
  
    {% for post in yearMonth.items %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
{% endfor %}
</ul>

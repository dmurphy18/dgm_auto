## # date_tag is YYYYMMDDhhmm
## # branch_tag is either branch 2016.11 or tag v2016.11.1
{% import "auto_setup/tag_build_date.jinja" as bd_cfg %}

date_tag: '{{ bd_cfg.date_tag }}'
branch_tag: '{{ bd_cfg.branch_tag }}'

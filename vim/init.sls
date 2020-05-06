{% from "vim/map.jinja" import vim with context %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

{% if salt['pillar.get']('vim:managed_vimrc', True) == True %}
{{ vim.config_root }}/vimrc:
  file.managed:
    - source: salt://vim/files/vimrc
    - template: jinja
    - user: root
    - group: {{ vim.group }}
    - mode: 644
    - template: jinja
    - makedirs: True
    - require:
      - pkg: vim
    - defaults:
        config_root: {{ vim.config_root }}
{% endif %}


{% if vim.get('load_bundles', false) %}

Create Bundle DIR:
  file.directory:
    - name: {{ vim.autoload_dir }}/bundle
    - mode: 755
    - makedirs: True

Place pathogen.vim:
  file.managed:
    - name: {{ vim.autoload_dir }}/pathogen.vim
    - source: salt://vim/files/pathogen.vim
    - mode: 755

'Copy vim bundles {{ vim.bundle_location }}':
  file.recurse:
    - name: {{ vim.autoload_dir }}/bundle
    - source: {{ vim.bundle_location }}
    - file_mode: 755
    - dir_mode: 755
    - quiet: True

{% endif %}

# BEGIN Fix for WordPress plugins and themes
# Certain WordPress plugins and themes do not properly link to PHP files because of symbolic links
# https://github.com/vcnngr/vcnngr-docker-wordpress-nginx/issues/43
rewrite ^/vcnngr/wordpress(/.*) $1 last;
# END Fix for WordPress plugins and themes

# FROM - use this instruction to set Base Functionality You Need
FROM nginx

# COPY - use this instruction to copy files from host to above image
COPY . /usr/share/nginx/html

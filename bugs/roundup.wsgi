#!/usr/bin/python

from wsgiref.simple_server import make_server

# obtain the WSGI request dispatcher
from roundup.cgi.wsgi_handler import RequestDispatcher
tracker_home = '/home/slitaz/bugs'
app = RequestDispatcher(tracker_home)

httpd = make_server('', 8917, app)
httpd.serve_forever()

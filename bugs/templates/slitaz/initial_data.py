#
# TRACKER INITIAL PRIORITY AND STATUS VALUES
#
pri = db.getclass('priority')
pri.create(name=''"critical", order="1")
pri.create(name=''"standard", order="2")
pri.create(name=''"feature", order="3")
pri.create(name=''"task", order="4")

stat = db.getclass('status')
stat.create(name=''"unread", order="1")
stat.create(name=''"deferred", order="2")
stat.create(name=''"chatting", order="3")
stat.create(name=''"in-progress", order="4")
stat.create(name=''"feedback", order="5")
stat.create(name=''"resolved", order="6")

# create the two default users
user = db.getclass('user')
user.create(username="pankso", password=adminpw,
    address=admin_email, roles='Admin')
user.create(username="anonymous", roles='Anonymous')

# add any additional database creation steps here - but only if you
# haven't initialised the database with the admin "initialise" command


# vim: set filetype=python sts=4 sw=4 et si
#SHA: 54e44ed654b0ae4a076ed2d948bbbaaa79590918

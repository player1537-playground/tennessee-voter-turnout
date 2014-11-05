import os
import sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
import json
import collections
import csv

app = Flask(__name__)
app.config.from_object(__name__)

app.config.update(dict(
    DATABASE=":memory:",
    DEBUG=True
))

def connect_db():
    """Connects to the specific database."""
    rv = sqlite3.connect(app.config['DATABASE'])
    init_db(rv)
    rv.row_factory = sqlite3.Row
    return rv

def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()

def init_db(db):
    with open("schema.sql", "r") as f:
        db.executescript(f.read())
        db.commit()

    with open("gen/voter-turnout.csv", "r") as f:
        reader = csv.reader(f)
        _ = next(reader)

        for row in reader:
            db.execute(('INSERT INTO turnout '
                        '       (date, county, registered_voters, '
                        '        total_votes_cast, voter_turnout, '
                        '        absentee_by_mail_voters, early_voters, '
                        '        percentage_of_early_voters, '
                        '        percentage_of_early_and_absentee_voters) '
                        '       VALUES (?, ?, ?, '
                        '               ?, ?, '
                        '               ?, ?, '
                        '               ?, '
                        '               ?)'),
                       row)
        db.commit()

    with open("gen/voter-registration.csv", "r") as f:
        reader = csv.reader(f)
        _ = next(reader)

        for row in reader:
            db.execute(('INSERT INTO registration '
                        '       (date, county, ending_active, ending_inactive, '
                        '        new_registration, new_inactive, purge_active, '
                        '


@app.route("/")
def index_page():
    return render_template("index_page.html")

if __name__ == "__main__":
    app.run()

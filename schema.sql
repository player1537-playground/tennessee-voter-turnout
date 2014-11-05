CREATE TABLE turnout (
       id INTEGER AUTOINCREMENT PRIMARY KEY,
       date DATE NOT NULL,
       county VARCHAR(10) NOT NULL,
       registered_voters INTEGER NOT NULL,
       total_votes_cast INTEGER NOT NULL,
       voter_turnout FLOAT NOT NULL,
       absentee_by_mail_voters INTEGER NOT NULL,
       early_voters INTEGER NOT NULL,
       percentage_of_early_voters FLOAT NOT NULL,
       percentage_of_early_and_absentee_voters FLOAT NOT NULL
);
CREATE INDEX turnout_date_idx ON turnout(date);
CREATE INDEX turnout_county_idx ON turnout(county);

CREATE TABLE registration (
       id INTEGER AUTOINCREMENT PRIMARY KEY,
       date VARCHAR(7) NOT NULL,
       county VARCHAR(10) NOT NULL,
       ending_active INTEGER NOT NULL,
       ending_inactive INTEGER NOT NULL,
       new_registration INTEGER NOT NULL,
       new_inactive INTEGER NOT NULL,
       purge_active INTEGER NOT NULL,
       purge_inactive INTEGER NOT NULL
);
CREATE INDEX registration_date_idx ON registration(date);
CREATE INDEX registration_county_idx ON registration(county);
